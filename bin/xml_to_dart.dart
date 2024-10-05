import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

final parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Print this usage information.',
    negatable: false,
  )
  ..addOption(
    'input',
    abbr: 'i',
    help: 'The input file.',
    mandatory: true,
  )
  ..addOption(
    'output',
    abbr: 'o',
    help: 'The output directory.',
    mandatory: false,
  );

final transformer = const Utf8Decoder().fuse(
  XmlEventDecoder(
    withParent: true,
  ),
);

Future<void> main(
  List<String> arguments,
) async {
  final ArgResults results;

  try {
    results = parser.parse(arguments);
  } on ArgParserException catch (e) {
    print(e.message);
    return;
  }

  if (results.wasParsed('help')) {
    print('Usage: dart xml_to_dart.dart <flags> [arguments]');
    print(parser.usage);
    return;
  }

  final inputOption = results.option('input');
  final input = inputOption != null ? Glob(inputOption) : null;
  if (input == null) {
    print('The option "input" is mandatory.');
    return;
  }

  final output = results.option('output');

  final dartClasses = <DartClass>{};

  await for (final entity in input.list()) {
    if (entity is File && extension(entity.path) == '.xml') {
      final file = File(entity.path);
      await for (final events in file.openRead().transform(transformer)) {
        for (final event in events) {
          if (event is XmlStartElementEvent) {
            final dartFields = <DartField>{};

            for (final attribute in event.attributes) {
              dartFields.add(
                XmlAttributeDartField(
                  name: attribute.localName,
                  namespace: attribute.namespaceUri,
                  dartType: dartTyper(attribute.value),
                ),
              );
            }

            dartClasses.add(
              DartClass(
                name: event.localName,
                namespace: event.namespaceUri,
                dartFields: dartFields,
              ),
            );

            final parent = event.parent;
            if (parent != null) {
              for (final dartClass in dartClasses) {
                if (dartClass.name == parent.name &&
                    dartClass.namespace == parent.namespaceUri) {
                  dartClass.dartFields.add(
                    XmlElementDartField(
                      name: event.localName,
                      namespace: event.namespaceUri,
                      dartType: DartType(
                        name: dartClassNamer(
                          DartClass(
                            name: event.localName,
                            namespace: event.namespaceUri,
                            dartFields: dartFields,
                          ),
                        ),
                        nullabilitySuffix: NullabilitySuffix.none,
                      ),
                    ),
                  );
                }
              }
            }
          } else if (event is XmlCDATAEvent) {
            final parent = event.parent;
            if (parent != null && event.value.isNotEmpty) {
              for (final dartClass in dartClasses) {
                if (dartClass.name == parent.name &&
                    dartClass.namespace == parent.namespaceUri) {
                  dartClass.dartFields.add(
                    XmlCDATADartField(
                      dartType: dartTyper(event.value),
                    ),
                  );
                }
              }
            }
          } else if (event is XmlTextEvent) {
            final parent = event.parent;
            if (parent != null && event.value.isNotEmpty) {
              for (final dartClass in dartClasses) {
                if (dartClass.name == parent.name &&
                    dartClass.namespace == parent.namespaceUri) {
                  dartClass.dartFields.add(
                    XmlTextDartField(
                      dartType: dartTyper(event.value),
                    ),
                  );
                }
              }
            }
          }
        }
      }
    }
  }

  for (final dartClass in dartClasses) {
    final file = File(
      join(
        output ?? Directory.current.path,
        '${dartClass.name.snakeCase}.dart',
      ),
    );

    final sink = file.openWrite();

    final writer = XmlToDartStringWriter(
      sink,
      dartClassNamer: dartClassNamer,
      dartFieldNamer: dartFieldNamer,
    );

    writer.writeXmlImportDirective();
    writer.writeXmlAnnotationImportDirective();

    writer.writePartDirective(dartClass);

    writer.writeDartClass(dartClass);

    await sink.close();
  }
}

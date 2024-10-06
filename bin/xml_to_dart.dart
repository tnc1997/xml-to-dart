import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
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

  final classes = <String, DartClass>{};

  await for (final entity in input.list()) {
    if (entity is File && extension(entity.path) == '.xml') {
      final file = File(entity.path);
      await for (final events in file.openRead().transform(transformer)) {
        for (final event in events) {
          if (event is XmlStartElementEvent) {
            final fields = <String, DartField>{};

            for (final attribute in event.attributes) {
              fields.update(
                camelCaseNamer(
                  attribute.localName,
                  attribute.namespaceUri,
                ),
                (value) {
                  return value.copyWith(
                    type: value.type.mergeWith(
                      DartType.fromValue(
                        attribute.value,
                      ),
                    ),
                  );
                },
                ifAbsent: () {
                  return DartField(
                    name: camelCaseNamer(
                      attribute.localName,
                      attribute.namespaceUri,
                    ),
                    annotations: [
                      XmlAttributeDartAnnotation.fromXmlEventAttribute(
                        attribute,
                      ),
                    ],
                    type: DartType.fromValue(
                      attribute.value,
                    ),
                  );
                },
              );
            }

            classes.update(
              pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              (value) {
                return DartClass(
                  name: pascalCaseNamer(
                    event.localName,
                    event.namespaceUri,
                  ),
                  annotations: [
                    XmlRootElementDartAnnotation.fromXmlStartElementEvent(
                      event,
                    ),
                    const XmlSerializableDartAnnotation(),
                  ],
                  fields: fields,
                );
              },
              ifAbsent: () {
                return DartClass(
                  name: pascalCaseNamer(
                    event.localName,
                    event.namespaceUri,
                  ),
                  annotations: [
                    XmlRootElementDartAnnotation.fromXmlStartElementEvent(
                      event,
                    ),
                    const XmlSerializableDartAnnotation(),
                  ],
                  fields: fields,
                );
              },
            );

            final parent = event.parent;
            if (parent != null) {
              classes[pascalCaseNamer(
                parent.name,
                parent.namespaceUri,
              )]
                  ?.fields[camelCaseNamer(
                event.localName,
                event.namespaceUri,
              )] = DartField(
                name: camelCaseNamer(
                  event.localName,
                  event.namespaceUri,
                ),
                annotations: [
                  XmlElementDartAnnotation.fromXmlStartElementEvent(
                    event,
                  ),
                ],
                type: DartType(
                  name: pascalCaseNamer(
                    event.localName,
                    event.namespaceUri,
                  ),
                  nullabilitySuffix: NullabilitySuffix.none,
                ),
              );
            }
          } else if (event is XmlCDATAEvent) {
            final parent = event.parent;
            if (parent != null && event.value.isNotEmpty) {
              classes[pascalCaseNamer(
                parent.name,
                parent.namespaceUri,
              )]
                  ?.fields['cdata'] = DartField(
                name: 'cdata',
                annotations: [
                  const XmlCDATADartAnnotation(),
                ],
                type: DartType.fromValue(
                  event.value,
                ),
              );
            }
          } else if (event is XmlTextEvent) {
            final parent = event.parent;
            if (parent != null && event.value.isNotEmpty) {
              classes[pascalCaseNamer(
                parent.name,
                parent.namespaceUri,
              )]
                  ?.fields['text'] = DartField(
                name: 'text',
                annotations: [
                  const XmlTextDartAnnotation(),
                ],
                type: DartType.fromValue(
                  event.value,
                ),
              );
            }
          }
        }
      }
    }
  }

  for (final class_ in classes.values) {
    final file = File(
      join(
        output ?? Directory.current.path,
        '${snakeCaseNamer(class_.name)}.dart',
      ),
    );

    final sink = file.openWrite();

    final writer = XmlToDartStringWriter(sink);

    writer.writeXmlImportDirective();
    writer.writeXmlAnnotationImportDirective();

    writer.writePartDirective(class_);

    writer.writeDartClass(class_);

    await sink.close();
  }
}

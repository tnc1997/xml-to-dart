import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:xml/xml.dart';
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

  final classes = <String, DartClass>{};

  await for (final entity in input.list()) {
    if (entity is File && extension(entity.path) == '.xml') {
      final document = XmlDocument.parse(
        await File(entity.path).readAsString(),
      );

      final elements = [document.rootElement];

      while (elements.isNotEmpty) {
        final element = elements.removeAt(0);

        final other = const XmlToDartDartClassFactory().create(element);

        classes.update(
          element.localName.pascalCase,
          (value) {
            return const XmlToDartDartClassReducer().combine(value, other);
          },
          ifAbsent: () {
            return other;
          },
        );

        for (final element in element.childElements) {
          elements.add(element);
        }
      }
    }
  }

  for (final class_ in classes.values) {
    final file = File(
      join(
        results.option('output') ?? Directory.current.path,
        '${class_.name.snakeCase}.dart',
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

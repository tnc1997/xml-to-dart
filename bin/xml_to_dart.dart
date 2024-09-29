import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

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

  final classes = <String, Set<String>>{};

  await for (final entity in input.list()) {
    if (entity is File && extension(entity.path) == '.xml') {
      final file = File(entity.path);
      await for (final events in file.openRead().transform(transformer)) {
        for (final event in events) {
          if (event is XmlStartElementEvent) {
            classes[event.name.pascalCase] = {};
          }
        }
      }
    }
  }

  print(classes);
}

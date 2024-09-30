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

  final classes = <DartClass>{};

  await for (final entity in input.list()) {
    if (entity is File && extension(entity.path) == '.xml') {
      final file = File(entity.path);
      await for (final events in file.openRead().transform(transformer)) {
        for (final event in events) {
          if (event is XmlStartElementEvent) {
            final fields = <DartField>{};

            for (final attribute in event.attributes) {
              fields.add(
                DartField(
                  name: const CamelCaseNamer().name(
                    attribute.localName,
                    attribute.namespacePrefix,
                  ),
                  namespace: attribute.namespaceUri,
                  type: const Typer().type(
                    attribute.value,
                  ),
                ),
              );
            }

            classes.add(
              DartClass(
                name: const PascalCaseNamer().name(
                  event.localName,
                  event.namespacePrefix,
                ),
                namespace: event.namespaceUri,
                fields: fields,
              ),
            );
          }
        }
      }
    }
  }

  print(classes);
}

class DartClass {
  final String name;
  final String? namespace;
  final Set<DartField> fields;

  const DartClass({
    required this.name,
    this.namespace,
    required this.fields,
  });

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartClass &&
            runtimeType == other.runtimeType &&
            name == other.name;
  }

  @override
  String toString() {
    return name;
  }
}

class DartField {
  final String name;
  final String? namespace;
  final String type;

  const DartField({
    required this.name,
    this.namespace,
    required this.type,
  });

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartClass &&
            runtimeType == other.runtimeType &&
            name == other.name;
  }

  @override
  String toString() {
    return name;
  }
}

abstract class Namer {
  const Namer();

  String name(
    String local, [
    String? prefix,
  ]);
}

class CamelCaseNamer implements Namer {
  const CamelCaseNamer();

  @override
  String name(
    String local, [
    String? prefix,
  ]) {
    if (prefix != null) {
      return '${prefix.camelCase}${local.pascalCase}';
    }

    return local.camelCase;
  }
}

class PascalCaseNamer implements Namer {
  const PascalCaseNamer();

  @override
  String name(
    String local, [
    String? prefix,
  ]) {
    if (prefix != null) {
      return '${prefix.pascalCase}${local.pascalCase}';
    }

    return local.pascalCase;
  }
}

class SnakeCaseNamer implements Namer {
  const SnakeCaseNamer();

  @override
  String name(
    String local, [
    String? prefix,
  ]) {
    if (prefix != null) {
      return '${prefix.snakeCase}_${local.snakeCase}';
    }

    return local.snakeCase;
  }
}

class Typer {
  const Typer();

  String type(
    String value,
  ) {
    if (int.tryParse(value) != null) {
      return 'int';
    }

    if (double.tryParse(value) != null) {
      return 'double';
    }

    if (DateTime.tryParse(value) != null) {
      return 'DateTime';
    }

    if (Uri.tryParse(value) != null) {
      return 'Uri';
    }

    if (value == 'true' || value == 'false') {
      return 'bool';
    }

    return 'String';
  }
}

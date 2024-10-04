import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

const classNamer = PascalCaseNamer();
const fieldNamer = CamelCaseNamer();
const fileNamer = SnakeCaseNamer();

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
                  name: attribute.localName,
                  namespace: attribute.namespaceUri,
                  type: const Typer().type(
                    attribute.value,
                  ),
                ),
              );
            }

            classes.add(
              DartClass(
                name: event.localName,
                namespace: event.namespaceUri,
                fields: fields,
              ),
            );
          }
        }
      }
    }
  }

  for (final class_ in classes) {
    final name = class_.name;
    final namespace = class_.namespace;
    final fields = class_.fields;

    final buffer = StringBuffer();

    buffer.writeln(
      'import \'package:xml/xml.dart\';',
    );

    buffer.writeln(
      'import \'package:xml_annotation/xml_annotation.dart\' as annotation;',
    );

    buffer.writeln(
      'part \'${fileNamer.name(name, namespace)}.g.dart\';',
    );

    buffer.write(
      '@annotation.XmlRootElement(name: \'$name\'',
    );

    if (namespace != null) {
      buffer.write(
        ', namespace: \'$namespace\'',
      );
    }

    buffer.writeln(
      ')',
    );

    buffer.writeln(
      '@annotation.XmlSerializable()',
    );

    buffer.writeln(
      'class ${classNamer.name(name, namespace)} {',
    );

    if (fields.isNotEmpty) {
      for (final field in fields) {
        final name = field.name;
        final namespace = field.namespace;
        final type = field.type;

        buffer.write(
          '@annotation.XmlAttribute(name: \'$name\'',
        );

        if (namespace != null) {
          buffer.write(
            ', namespace: \'$namespace\'',
          );
        }

        buffer.writeln(
          ')',
        );

        buffer.writeln(
          '$type ${fieldNamer.name(name, namespace)};',
        );
      }

      buffer.writeln(
        '${classNamer.name(name, namespace)}({',
      );

      for (final field in fields) {
        final name = field.name;
        final namespace = field.namespace;

        buffer.writeln(
          'this.${fieldNamer.name(name, namespace)}',
        );
      }

      buffer.writeln(
        '});',
      );
    }

    buffer.writeln(
      'factory ${classNamer.name(name, namespace)}.fromXmlElement(XmlElement element) => _\$${classNamer.name(name, namespace)}FromXmlElement(element);',
    );

    buffer.writeln(
      'void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${classNamer.name(name, namespace)}BuildXmlChildren(this, builder, namespaces: namespaces);',
    );

    buffer.writeln(
      'void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${classNamer.name(name, namespace)}BuildXmlElement(this, builder, namespaces: namespaces);',
    );

    buffer.writeln(
      'List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) => _\$${classNamer.name(name, namespace)}ToXmlAttributes(this, namespaces: namespaces);',
    );

    buffer.writeln(
      'List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) => _\$${classNamer.name(name, namespace)}ToXmlChildren(this, namespaces: namespaces);',
    );

    buffer.writeln(
      'XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) => _\$${classNamer.name(name, namespace)}ToXmlElement(this, namespaces: namespaces);',
    );

    buffer.writeln(
      '}',
    );

    print(buffer.toString());
  }
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
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartClass &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
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
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartField &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
  }

  @override
  String toString() {
    return name;
  }
}

abstract class Namer {
  const Namer();

  String name(
    String name, [
    String? namespace,
  ]);
}

class CamelCaseNamer implements Namer {
  const CamelCaseNamer();

  @override
  String name(
    String name, [
    String? namespace,
  ]) {
    return name.camelCase;
  }
}

class PascalCaseNamer implements Namer {
  const PascalCaseNamer();

  @override
  String name(
    String name, [
    String? namespace,
  ]) {
    return name.pascalCase;
  }
}

class SnakeCaseNamer implements Namer {
  const SnakeCaseNamer();

  @override
  String name(
    String name, [
    String? namespace,
  ]) {
    return name.snakeCase;
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

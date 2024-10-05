import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

typedef DartClassNamer = String Function(DartClass dartClass);

String dartClassNamer(DartClass dartClass) {
  return dartClass.name.pascalCase;
}

typedef DartFieldNamer = String Function(DartField dartField);

String dartFieldNamer(DartField dartField) {
  if (dartField is XmlAttributeDartField) {
    return dartField.name.camelCase;
  } else if (dartField is XmlCDATADartField) {
    return 'cdata';
  } else if (dartField is XmlElementDartField) {
    return dartField.name.camelCase;
  } else if (dartField is XmlTextDartField) {
    return 'text';
  } else {
    throw ArgumentError.value(dartField, 'dartField');
  }
}

typedef DartTyper = DartType Function(String value);

DartType dartTyper(String value) {
  if (int.tryParse(value) != null) {
    return const IntDartType();
  } else if (double.tryParse(value) != null) {
    return const DoubleDartType();
  } else if (DateTime.tryParse(value) != null) {
    return const DateTimeDartType();
  } else if (value == 'true' || value == 'false') {
    return const BoolDartType();
  } else {
    return const StringDartType();
  }
}

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
          }
        }
      }
    }
  }

  for (final dartClass in dartClasses) {
    final name = dartClass.name;
    final namespace = dartClass.namespace;
    final dartFields = dartClass.dartFields;

    final buffer = StringBuffer();

    buffer.writeln(
      'import \'package:xml/xml.dart\';',
    );

    buffer.writeln(
      'import \'package:xml_annotation/xml_annotation.dart\' as annotation;',
    );

    buffer.writeln(
      'part \'${name.snakeCase}.g.dart\';',
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
      'class ${dartClassNamer(dartClass)} {',
    );

    if (dartFields.isNotEmpty) {
      for (final dartField in dartFields) {
        final dartType = dartField.dartType;

        if (dartField is XmlAttributeDartField) {
          final name = dartField.name;
          final namespace = dartField.namespace;

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
        } else if (dartField is XmlElementDartField) {
          final name = dartField.name;
          final namespace = dartField.namespace;

          buffer.write(
            '@annotation.XmlElement(name: \'$name\'',
          );

          if (namespace != null) {
            buffer.write(
              ', namespace: \'$namespace\'',
            );
          }

          buffer.writeln(
            ')',
          );
        }

        buffer.writeln(
          '$dartType ${dartFieldNamer(dartField)};',
        );
      }

      buffer.writeln(
        '${dartClassNamer(dartClass)}({',
      );

      for (final dartField in dartFields) {
        buffer.writeln(
          'this.${dartFieldNamer(dartField)},',
        );
      }

      buffer.writeln(
        '});',
      );
    }

    buffer.writeln(
      'factory ${dartClassNamer(dartClass)}.fromXmlElement(XmlElement element) => _\$${dartClassNamer(dartClass)}FromXmlElement(element);',
    );

    buffer.writeln(
      'void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${dartClassNamer(dartClass)}BuildXmlChildren(this, builder, namespaces: namespaces);',
    );

    buffer.writeln(
      'void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${dartClassNamer(dartClass)}BuildXmlElement(this, builder, namespaces: namespaces);',
    );

    buffer.writeln(
      'List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) => _\$${dartClassNamer(dartClass)}ToXmlAttributes(this, namespaces: namespaces);',
    );

    buffer.writeln(
      'List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) => _\$${dartClassNamer(dartClass)}ToXmlChildren(this, namespaces: namespaces);',
    );

    buffer.writeln(
      'XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) => _\$${dartClassNamer(dartClass)}ToXmlElement(this, namespaces: namespaces);',
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
  final Set<DartField> dartFields;

  const DartClass({
    required this.name,
    this.namespace,
    required this.dartFields,
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

abstract class DartField {
  final DartType dartType;

  const DartField({
    required this.dartType,
  });
}

class XmlAttributeDartField extends DartField {
  final String name;
  final String? namespace;

  const XmlAttributeDartField({
    required this.name,
    this.namespace,
    required DartType dartType,
  }) : super(
          dartType: dartType,
        );

  @override
  int get hashCode {
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is XmlAttributeDartField &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
  }

  @override
  String toString() {
    return name;
  }
}

class XmlCDATADartField extends DartField {
  const XmlCDATADartField({
    required DartType dartType,
  }) : super(
          dartType: dartType,
        );
}

class XmlElementDartField extends DartField {
  final String name;
  final String? namespace;

  const XmlElementDartField({
    required this.name,
    this.namespace,
    required DartType dartType,
  }) : super(
          dartType: dartType,
        );

  @override
  int get hashCode {
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is XmlElementDartField &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
  }

  @override
  String toString() {
    return name;
  }
}

class XmlTextDartField extends DartField {
  const XmlTextDartField({
    required DartType dartType,
  }) : super(
          dartType: dartType,
        );
}

class DartType {
  final String name;
  final NullabilitySuffix nullabilitySuffix;

  const DartType({
    required this.name,
    this.nullabilitySuffix = NullabilitySuffix.none,
  });

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartType &&
            runtimeType == other.runtimeType &&
            name == other.name;
  }

  DartType copyWith({
    NullabilitySuffix? nullabilitySuffix,
  }) {
    return DartType(
      name: name,
      nullabilitySuffix: nullabilitySuffix ?? this.nullabilitySuffix,
    );
  }

  @override
  String toString() {
    return name;
  }
}

class BoolDartType extends DartType {
  const BoolDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'bool',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class DateTimeDartType extends DartType {
  const DateTimeDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'DateTime',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class DoubleDartType extends DartType {
  const DoubleDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'double',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class IntDartType extends DartType {
  const IntDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'int',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class StringDartType extends DartType {
  const StringDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'String',
          nullabilitySuffix: nullabilitySuffix,
        );
}

/// Suffix indicating the nullability of a type.
///
/// This enum describes whether a `?` would be used at the end of the canonical representation of a type. It's subtly different the notions of "nullable" and "non-nullable" defined by the spec. For example, the type `Null` is nullable, even though it lacks a trailing `?`.
enum NullabilitySuffix {
  /// An indication that the canonical representation of the type under consideration ends with `?`. Types having this nullability suffix should be interpreted as being unioned with the Null type.
  question,

  /// An indication that the canonical representation of the type under consideration does not end with `?`.
  none,
}

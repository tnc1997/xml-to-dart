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

class XmlToDartStringWriter {
  final StringSink _sink;
  final DartClassNamer _dartClassNamer;
  final DartFieldNamer _dartFieldNamer;

  const XmlToDartStringWriter(
    this._sink, {
    required DartClassNamer dartClassNamer,
    required DartFieldNamer dartFieldNamer,
  })  : _dartClassNamer = dartClassNamer,
        _dartFieldNamer = dartFieldNamer;

  void writeBuildXmlChildrenMethod(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${_dartClassNamer(dartClass)}BuildXmlChildren(this, builder, namespaces: namespaces);',
    );
  }

  void writeBuildXmlElementMethod(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${_dartClassNamer(dartClass)}BuildXmlElement(this, builder, namespaces: namespaces);',
    );
  }

  void writeDartClass(
    DartClass dartClass,
  ) {
    writeXmlRootElementAnnotation(dartClass);
    writeXmlSerializableAnnotation(dartClass);

    _sink.writeln(
      'class ${_dartClassNamer(dartClass)} {',
    );

    for (final dartField in dartClass.dartFields) {
      writeDartField(dartField);
    }

    writeGenerativeConstructor(dartClass);

    writeFromXmlElementFactoryConstructor(dartClass);

    writeBuildXmlChildrenMethod(dartClass);
    writeBuildXmlElementMethod(dartClass);

    writeToXmlAttributesMethod(dartClass);
    writeToXmlChildrenMethod(dartClass);
    writeToXmlElementMethod(dartClass);

    _sink.writeln(
      '}',
    );
  }

  void writeDartField(
    DartField dartField,
  ) {
    if (dartField is XmlAttributeDartField) {
      writeXmlAttributeAnnotation(dartField);
    } else if (dartField is XmlCDATADartField) {
      writeXmlCDATAAnnotation(dartField);
    } else if (dartField is XmlElementDartField) {
      writeXmlElementAnnotation(dartField);
    } else if (dartField is XmlTextDartField) {
      writeXmlTextAnnotation(dartField);
    } else {
      throw ArgumentError.value(dartField, 'dartField');
    }

    _sink.write(
      dartField.dartType.name,
    );

    if (dartField.dartType.nullabilitySuffix == NullabilitySuffix.question) {
      _sink.write(
        '?',
      );
    }

    _sink.writeln(
      ' ${_dartFieldNamer(dartField)};',
    );
  }

  void writeFromXmlElementFactoryConstructor(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'factory ${_dartClassNamer(dartClass)}.fromXmlElement(XmlElement element) => _\$${_dartClassNamer(dartClass)}FromXmlElement(element);',
    );
  }

  void writeGenerativeConstructor(
    DartClass dartClass,
  ) {
    _sink.write(
      '${_dartClassNamer(dartClass)}(',
    );

    if (dartClass.dartFields.isNotEmpty) {
      _sink.writeln(
        '{',
      );

      for (final dartField in dartClass.dartFields) {
        if (dartField.dartType.nullabilitySuffix == NullabilitySuffix.none) {
          _sink.write(
            'required ',
          );
        }

        _sink.writeln(
          'this.${_dartFieldNamer(dartField)},',
        );
      }

      _sink.write(
        '}',
      );
    }

    _sink.writeln(
      ');',
    );
  }

  void writePartDirective(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'part \'${dartClass.name.snakeCase}.g.dart\';',
    );
  }

  void writeToXmlAttributesMethod(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) => _\$${_dartClassNamer(dartClass)}ToXmlAttributes(this, namespaces: namespaces);',
    );
  }

  void writeToXmlChildrenMethod(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) => _\$${_dartClassNamer(dartClass)}ToXmlChildren(this, namespaces: namespaces);',
    );
  }

  void writeToXmlElementMethod(
    DartClass dartClass,
  ) {
    _sink.writeln(
      'XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) => _\$${_dartClassNamer(dartClass)}ToXmlElement(this, namespaces: namespaces);',
    );
  }

  void writeXmlAnnotationImportDirective({
    String? prefix = 'annotation',
  }) {
    _sink.write(
      'import \'package:xml_annotation/xml_annotation.dart\'',
    );

    if (prefix != null) {
      _sink.write(
        ' as $prefix',
      );
    }

    _sink.writeln(
      ';',
    );
  }

  void writeXmlAttributeAnnotation(
    XmlAttributeDartField dartField, {
    String? prefix = 'annotation',
  }) {
    final name = dartField.name;
    final namespace = dartField.namespace;

    _sink.write(
      '@',
    );

    if (prefix != null) {
      _sink.write(
        '$prefix.',
      );
    }

    _sink.write(
      'XmlAttribute(name: \'$name\'',
    );

    if (namespace != null) {
      _sink.write(
        ', namespace: \'$namespace\'',
      );
    }

    _sink.writeln(
      ')',
    );
  }

  void writeXmlCDATAAnnotation(
    XmlCDATADartField dartField, {
    String? prefix = 'annotation',
  }) {
    _sink.write(
      '@',
    );

    if (prefix != null) {
      _sink.write(
        '$prefix.',
      );
    }

    _sink.writeln(
      'XmlCDATA()',
    );
  }

  void writeXmlElementAnnotation(
    XmlElementDartField dartField, {
    String? prefix = 'annotation',
  }) {
    final name = dartField.name;
    final namespace = dartField.namespace;

    _sink.write(
      '@',
    );

    if (prefix != null) {
      _sink.write(
        '$prefix.',
      );
    }

    _sink.write(
      'XmlElement(name: \'$name\'',
    );

    if (namespace != null) {
      _sink.write(
        ', namespace: \'$namespace\'',
      );
    }

    _sink.writeln(
      ')',
    );
  }

  void writeXmlRootElementAnnotation(
    DartClass dartClass, {
    String? prefix = 'annotation',
  }) {
    final name = dartClass.name;
    final namespace = dartClass.namespace;

    _sink.write(
      '@',
    );

    if (prefix != null) {
      _sink.write(
        '$prefix.',
      );
    }

    _sink.write(
      'XmlRootElement(name: \'$name\'',
    );

    if (namespace != null) {
      _sink.write(
        ', namespace: \'$namespace\'',
      );
    }

    _sink.writeln(
      ')',
    );
  }

  void writeXmlSerializableAnnotation(
    DartClass dartClass, {
    String? prefix = 'annotation',
  }) {
    _sink.write(
      '@',
    );

    if (prefix != null) {
      _sink.write(
        '$prefix.',
      );
    }

    _sink.writeln(
      'XmlSerializable()',
    );
  }

  void writeXmlTextAnnotation(
    XmlTextDartField dartField, {
    String? prefix = 'annotation',
  }) {
    _sink.write(
      '@',
    );

    if (prefix != null) {
      _sink.write(
        '$prefix.',
      );
    }

    _sink.writeln(
      'XmlText()',
    );
  }

  void writeXmlImportDirective() {
    _sink.writeln(
      'import \'package:xml/xml.dart\';',
    );
  }
}

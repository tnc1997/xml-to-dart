import 'package:recase/recase.dart';

import 'dart_class.dart';
import 'dart_class_namer.dart';
import 'dart_field.dart';
import 'dart_field_namer.dart';
import 'dart_type.dart';

class XmlToDartStringWriter {
  final StringSink _sink;
  final DartClassNamer _dartClassNamer;
  final DartFieldNamer _dartFieldNamer;

  const XmlToDartStringWriter(
      this._sink, {
        DartClassNamer dartClassNamer = dartClassNamer,
        DartFieldNamer dartFieldNamer = dartFieldNamer,
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

import 'package:recase/recase.dart';

import 'dart_annotation.dart';
import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_type.dart';

class XmlToDartStringWriter {
  final StringSink _sink;

  const XmlToDartStringWriter(this._sink);

  void writeBuildXmlChildrenMethod(
    String name,
  ) {
    _sink.writeln(
      'void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${name.pascalCase}BuildXmlChildren(this, builder, namespaces: namespaces);',
    );
  }

  void writeBuildXmlElementMethod(
    String name,
  ) {
    _sink.writeln(
      'void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${name.pascalCase}BuildXmlElement(this, builder, namespaces: namespaces);',
    );
  }

  void writeDartAnnotation(
    DartAnnotation annotation,
  ) {
    if (annotation is XmlAttributeDartAnnotation) {
      writeXmlAttributeDartAnnotation(annotation);
    } else if (annotation is XmlCDATADartAnnotation) {
      writeXmlCDATADartAnnotation(annotation);
    } else if (annotation is XmlElementDartAnnotation) {
      writeXmlElementDartAnnotation(annotation);
    } else if (annotation is XmlRootElementDartAnnotation) {
      writeXmlRootElementDartAnnotation(annotation);
    } else if (annotation is XmlSerializableDartAnnotation) {
      writeXmlSerializableDartAnnotation(annotation);
    } else if (annotation is XmlTextDartAnnotation) {
      writeXmlTextDartAnnotation(annotation);
    } else {
      throw ArgumentError.value(annotation, 'annotation');
    }
  }

  void writeDartClass(
    String name,
    DartClass class_,
  ) {
    for (final annotation in class_.annotations) {
      writeDartAnnotation(annotation);
    }

    _sink.writeln(
      'class $name {',
    );

    for (final entry in class_.fields.entries) {
      writeDartField(entry.key, entry.value);
    }

    writeGenerativeConstructor(name, class_.fields);

    writeFromXmlElementFactoryConstructor(name);

    writeBuildXmlChildrenMethod(name);
    writeBuildXmlElementMethod(name);

    writeToXmlAttributesMethod(name);
    writeToXmlChildrenMethod(name);
    writeToXmlElementMethod(name);

    _sink.writeln(
      '}',
    );
  }

  void writeDartField(
    String name,
    DartField field,
  ) {
    if (field is XmlAttributeDartField) {
      final name = field.name;
      final namespace = field.namespace;

      _sink.write(
        '@annotation.XmlAttribute(name: \'$name\'',
      );

      if (namespace != null) {
        _sink.write(
          ', namespace: \'$namespace\'',
        );
      }

      _sink.writeln(
        ')',
      );
    } else if (field is XmlCDATADartField) {
      _sink.writeln(
        '@annotation.XmlCDATA()',
      );
    } else if (field is XmlElementDartField) {
      final name = field.name;
      final namespace = field.namespace;

      _sink.write(
        '@annotation.XmlElement(name: \'$name\'',
      );

      if (namespace != null) {
        _sink.write(
          ', namespace: \'$namespace\'',
        );
      }

      _sink.writeln(
        ')',
      );
    } else if (field is XmlTextDartField) {
      _sink.writeln(
        '@annotation.XmlText()',
      );
    } else {
      throw ArgumentError.value(field, 'field');
    }

    _sink.write(
      field.type.name,
    );

    if (field.type.nullabilitySuffix == NullabilitySuffix.question) {
      _sink.write(
        '?',
      );
    }

    _sink.writeln(
      ' ${name.camelCase};',
    );
  }

  void writeFromXmlElementFactoryConstructor(
    String name,
  ) {
    _sink.writeln(
      'factory ${name.pascalCase}.fromXmlElement(XmlElement element) => _\$${name.pascalCase}FromXmlElement(element);',
    );
  }

  void writeGenerativeConstructor(
    String name,
    Map<String, DartField> fields,
  ) {
    _sink.write(
      '${name.pascalCase}(',
    );

    if (fields.isNotEmpty) {
      _sink.writeln(
        '{',
      );

      for (final entry in fields.entries) {
        if (entry.value.type.nullabilitySuffix == NullabilitySuffix.none) {
          _sink.write(
            'required ',
          );
        }

        _sink.writeln(
          'this.${entry.key.camelCase},',
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
    String name,
  ) {
    _sink.writeln(
      'part \'${name.snakeCase}.g.dart\';',
    );
  }

  void writeToXmlAttributesMethod(
    String name,
  ) {
    _sink.writeln(
      'List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) => _\$${name.pascalCase}ToXmlAttributes(this, namespaces: namespaces);',
    );
  }

  void writeToXmlChildrenMethod(
    String name,
  ) {
    _sink.writeln(
      'List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) => _\$${name.pascalCase}ToXmlChildren(this, namespaces: namespaces);',
    );
  }

  void writeToXmlElementMethod(
    String name,
  ) {
    _sink.writeln(
      'XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) => _\$${name.pascalCase}ToXmlElement(this, namespaces: namespaces);',
    );
  }

  void writeXmlAnnotationImportDirective() {
    _sink.writeln(
      'import \'package:xml_annotation/xml_annotation.dart\' as annotation;',
    );
  }

  void writeXmlAttributeDartAnnotation(
    XmlAttributeDartAnnotation annotation,
  ) {
    final name = annotation.name;
    final namespace = annotation.namespace;

    _sink.write(
      '@annotation.XmlAttribute(name: \'$name\'',
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

  void writeXmlCDATADartAnnotation(
    XmlCDATADartAnnotation annotation,
  ) {
    _sink.writeln(
      '@annotation.XmlCDATA()',
    );
  }

  void writeXmlElementDartAnnotation(
    XmlElementDartAnnotation annotation,
  ) {
    final name = annotation.name;
    final namespace = annotation.namespace;

    _sink.write(
      '@annotation.XmlElement(name: \'$name\'',
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

  void writeXmlRootElementDartAnnotation(
    XmlRootElementDartAnnotation annotation,
  ) {
    final name = annotation.name;
    final namespace = annotation.namespace;

    _sink.write(
      '@annotation.XmlRootElement(name: \'$name\'',
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

  void writeXmlSerializableDartAnnotation(
    XmlSerializableDartAnnotation annotation,
  ) {
    _sink.writeln(
      '@annotation.XmlSerializable()',
    );
  }

  void writeXmlTextDartAnnotation(
    XmlTextDartAnnotation annotation,
  ) {
    _sink.writeln(
      '@annotation.XmlText()',
    );
  }

  void writeXmlImportDirective() {
    _sink.writeln(
      'import \'package:xml/xml.dart\';',
    );
  }
}

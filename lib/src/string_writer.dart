import 'dart_annotation.dart';
import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_type.dart';
import 'namer.dart';

class XmlToDartStringWriter {
  final StringSink _sink;

  const XmlToDartStringWriter(this._sink);

  void writeBuildXmlChildrenMethod(
    DartClass class_,
  ) {
    _sink.writeln(
      'void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${class_.name}BuildXmlChildren(this, builder, namespaces: namespaces);',
    );
  }

  void writeBuildXmlElementMethod(
    DartClass class_,
  ) {
    _sink.writeln(
      'void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) => _\$${class_.name}BuildXmlElement(this, builder, namespaces: namespaces);',
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
    DartClass class_,
  ) {
    for (final annotation in class_.annotations) {
      writeDartAnnotation(annotation);
    }

    _sink.writeln(
      'class ${class_.name} {',
    );

    for (final field in class_.fields.values) {
      writeDartField(field);
    }

    writeGenerativeConstructor(class_);

    writeFromXmlElementFactoryConstructor(class_);

    writeBuildXmlChildrenMethod(class_);
    writeBuildXmlElementMethod(class_);

    writeToXmlAttributesMethod(class_);
    writeToXmlChildrenMethod(class_);
    writeToXmlElementMethod(class_);

    _sink.writeln(
      '}',
    );
  }

  void writeDartField(
    DartField field,
  ) {
    for (final annotation in field.annotations) {
      writeDartAnnotation(annotation);
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
      ' ${field.name};',
    );
  }

  void writeFromXmlElementFactoryConstructor(
    DartClass class_,
  ) {
    _sink.writeln(
      'factory ${class_.name}.fromXmlElement(XmlElement element) => _\$${class_.name}FromXmlElement(element);',
    );
  }

  void writeGenerativeConstructor(
    DartClass class_,
  ) {
    _sink.write(
      '${class_.name}(',
    );

    if (class_.fields.isNotEmpty) {
      _sink.writeln(
        '{',
      );

      for (final field in class_.fields.values) {
        if (field.type.nullabilitySuffix == NullabilitySuffix.none) {
          _sink.write(
            'required ',
          );
        }

        _sink.writeln(
          'this.${field.name},',
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
    DartClass class_,
  ) {
    _sink.writeln(
      'part \'${snakeCaseNamer(class_.name)}.g.dart\';',
    );
  }

  void writeToXmlAttributesMethod(
    DartClass class_,
  ) {
    _sink.writeln(
      'List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) => _\$${class_.name}ToXmlAttributes(this, namespaces: namespaces);',
    );
  }

  void writeToXmlChildrenMethod(
    DartClass class_,
  ) {
    _sink.writeln(
      'List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) => _\$${class_.name}ToXmlChildren(this, namespaces: namespaces);',
    );
  }

  void writeToXmlElementMethod(
    DartClass class_,
  ) {
    _sink.writeln(
      'XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) => _\$${class_.name}ToXmlElement(this, namespaces: namespaces);',
    );
  }

  void writeXmlAnnotationImportDirective() {
    _sink.write(
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

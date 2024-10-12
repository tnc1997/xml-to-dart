import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_type.dart';

class DartField {
  DartType type;

  DartField({
    required this.type,
  });
}

class XmlAttributeDartField extends DartField {
  final String name;
  final String? namespace;

  XmlAttributeDartField({
    required DartType type,
    required this.name,
    this.namespace,
  }) : super(type: type);

  factory XmlAttributeDartField.fromXmlAttribute(
    XmlAttribute attribute,
  ) {
    return XmlAttributeDartField(
      type: DartType.fromValue(
        attribute.value.trim(),
      ),
      name: attribute.localName,
      namespace: attribute.namespaceUri,
    );
  }
}

class XmlCDATADartField extends DartField {
  XmlCDATADartField({
    required DartType type,
  }) : super(type: type);

  factory XmlCDATADartField.fromXmlCDATA(
    XmlCDATA cdata,
  ) {
    return XmlCDATADartField(
      type: DartType.fromValue(
        cdata.value.trim(),
      ),
    );
  }
}

class XmlElementDartField extends DartField {
  final String name;
  final String? namespace;
  final bool? isSelfClosing;
  final bool? includeIfNull;

  XmlElementDartField({
    required DartType type,
    required this.name,
    this.namespace,
    this.isSelfClosing,
    this.includeIfNull,
  }) : super(type: type);

  factory XmlElementDartField.fromXmlElement(
    XmlElement element,
  ) {
    return XmlElementDartField(
      type: DartType(
        name: element.localName.pascalCase,
        nullabilitySuffix: NullabilitySuffix.none,
      ),
      name: element.localName,
      namespace: element.namespaceUri,
    );
  }
}

class XmlTextDartField extends DartField {
  XmlTextDartField({
    required DartType type,
  }) : super(type: type);

  factory XmlTextDartField.fromXmlText(
    XmlText text,
  ) {
    return XmlTextDartField(
      type: DartType.fromValue(
        text.value.trim(),
      ),
    );
  }
}

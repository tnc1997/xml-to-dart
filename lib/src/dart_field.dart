import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_type.dart';

class DartField {
  final DartType type;

  const DartField({
    required this.type,
  });

  DartField mergeWith(
    DartField other,
  ) {
    return DartField(
      type: type.mergeWith(
        other.type,
      ),
    );
  }
}

class XmlAttributeDartField extends DartField {
  final String name;
  final String? namespace;

  const XmlAttributeDartField({
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

  @override
  XmlAttributeDartField mergeWith(
    DartField other,
  ) {
    return XmlAttributeDartField(
      type: type.mergeWith(
        other.type,
      ),
      name: name,
      namespace: namespace,
    );
  }
}

class XmlCDATADartField extends DartField {
  const XmlCDATADartField({
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

  @override
  XmlCDATADartField mergeWith(
    DartField other,
  ) {
    return XmlCDATADartField(
      type: type.mergeWith(
        other.type,
      ),
    );
  }
}

class XmlElementDartField extends DartField {
  final String name;
  final String? namespace;
  final bool? isSelfClosing;
  final bool? includeIfNull;

  const XmlElementDartField({
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

  @override
  XmlElementDartField mergeWith(
    DartField other,
  ) {
    return XmlElementDartField(
      type: type.mergeWith(
        other.type,
      ),
      name: name,
      namespace: namespace,
      isSelfClosing: isSelfClosing,
      includeIfNull: includeIfNull,
    );
  }
}

class XmlTextDartField extends DartField {
  const XmlTextDartField({
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

  @override
  XmlTextDartField mergeWith(
    DartField other,
  ) {
    return XmlTextDartField(
      type: type.mergeWith(
        other.type,
      ),
    );
  }
}

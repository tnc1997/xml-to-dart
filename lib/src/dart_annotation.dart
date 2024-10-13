import 'package:xml/xml.dart';

abstract class DartAnnotation {
  const DartAnnotation();
}

class XmlAttributeDartAnnotation extends DartAnnotation {
  final String? name;
  final String? namespace;

  const XmlAttributeDartAnnotation({
    this.name,
    this.namespace,
  });

  factory XmlAttributeDartAnnotation.fromXmlAttribute(
    XmlAttribute attribute,
  ) {
    return XmlAttributeDartAnnotation(
      name: attribute.localName,
      namespace: attribute.namespaceUri,
    );
  }
}

class XmlCDATADartAnnotation extends DartAnnotation {
  const XmlCDATADartAnnotation();
}

class XmlElementDartAnnotation extends DartAnnotation {
  final String? name;
  final String? namespace;
  final bool? isSelfClosing;
  final bool? includeIfNull;

  const XmlElementDartAnnotation({
    this.name,
    this.namespace,
    this.isSelfClosing,
    this.includeIfNull,
  });

  factory XmlElementDartAnnotation.fromXmlElement(
    XmlElement element,
  ) {
    return XmlElementDartAnnotation(
      name: element.localName,
      namespace: element.namespaceUri,
      isSelfClosing: element.isSelfClosing,
    );
  }
}

class XmlRootElementDartAnnotation extends DartAnnotation {
  final String? name;
  final String? namespace;
  final bool? isSelfClosing;

  const XmlRootElementDartAnnotation({
    this.name,
    this.namespace,
    this.isSelfClosing,
  });

  factory XmlRootElementDartAnnotation.fromXmlElement(
    XmlElement element,
  ) {
    return XmlRootElementDartAnnotation(
      name: element.localName,
      namespace: element.namespaceUri,
      isSelfClosing: element.isSelfClosing,
    );
  }
}

class XmlSerializableDartAnnotation extends DartAnnotation {
  const XmlSerializableDartAnnotation();
}

class XmlTextDartAnnotation extends DartAnnotation {
  const XmlTextDartAnnotation();
}

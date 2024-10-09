import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

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

  factory XmlAttributeDartAnnotation.fromXmlEventAttribute(
    XmlEventAttribute attribute,
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

  factory XmlElementDartAnnotation.fromXmlStartElementEvent(
    XmlStartElementEvent event,
  ) {
    return XmlElementDartAnnotation(
      name: event.localName,
      namespace: event.namespaceUri,
      isSelfClosing: event.isSelfClosing,
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

  factory XmlRootElementDartAnnotation.fromXmlStartElementEvent(
    XmlStartElementEvent event,
  ) {
    return XmlRootElementDartAnnotation(
      name: event.localName,
      namespace: event.namespaceUri,
      isSelfClosing: event.isSelfClosing,
    );
  }
}

class XmlSerializableDartAnnotation extends DartAnnotation {
  const XmlSerializableDartAnnotation();
}

class XmlTextDartAnnotation extends DartAnnotation {
  const XmlTextDartAnnotation();
}

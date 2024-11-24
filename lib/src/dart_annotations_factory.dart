import 'package:xml/xml.dart';

import 'dart_annotation.dart';

abstract class DartAnnotationsFactory {
  List<DartAnnotation> create(
    XmlNode node,
  );
}

class XmlToDartDartClassDartAnnotationsFactory
    implements DartAnnotationsFactory {
  const XmlToDartDartClassDartAnnotationsFactory();

  @override
  List<DartAnnotation> create(
    XmlNode node,
  ) {
    if (node is XmlElement) {
      return [
        XmlRootElementDartAnnotation(
          name: node.localName,
          namespace: node.namespaceUri,
          isSelfClosing: node.isSelfClosing,
        ),
        const XmlSerializableDartAnnotation(),
      ];
    } else {
      throw ArgumentError.value(node, 'node');
    }
  }
}

class XmlToDartDartFieldDartAnnotationsFactory
    implements DartAnnotationsFactory {
  const XmlToDartDartFieldDartAnnotationsFactory();

  @override
  List<DartAnnotation> create(
    XmlNode node,
  ) {
    if (node is XmlAttribute) {
      return [
        XmlAttributeDartAnnotation(
          name: node.localName,
          namespace: node.namespaceUri,
        ),
      ];
    } else if (node is XmlCDATA) {
      return [
        const XmlCDATADartAnnotation(),
      ];
    } else if (node is XmlElement) {
      return [
        XmlElementDartAnnotation(
          name: node.localName,
          namespace: node.namespaceUri,
          isSelfClosing: node.isSelfClosing,
        ),
      ];
    } else if (node is XmlText) {
      return [
        const XmlTextDartAnnotation(),
      ];
    } else {
      throw ArgumentError.value(node, 'node');
    }
  }
}

import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';
import 'dart_type_factory.dart';

class DartFieldFactory {
  final DartTypeFactory typeFactory;

  const DartFieldFactory({
    this.typeFactory = const DartTypeFactory(),
  });

  DartField create(
    XmlNode node,
  ) {
    if (node is XmlAttribute) {
      return DartField(
        name: node.localName.camelCase,
        annotations: [
          XmlAttributeDartAnnotation.fromXmlAttribute(node),
        ],
        type: typeFactory.create(node),
      );
    } else if (node is XmlCDATA) {
      return DartField(
        name: 'cdata',
        annotations: [
          const XmlCDATADartAnnotation(),
        ],
        type: typeFactory.create(node),
      );
    } else if (node is XmlElement) {
      return DartField(
        name: node.localName.camelCase,
        annotations: [
          XmlElementDartAnnotation.fromXmlElement(node),
        ],
        type: typeFactory.create(node),
      );
    } else if (node is XmlText) {
      return DartField(
        name: 'text',
        annotations: [
          const XmlTextDartAnnotation(),
        ],
        type: typeFactory.create(node),
      );
    } else {
      throw ArgumentError.value(node, 'node');
    }
  }
}

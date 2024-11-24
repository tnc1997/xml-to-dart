import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_annotations_factory.dart';
import 'dart_field.dart';
import 'dart_type_factory.dart';

class DartFieldFactory {
  final DartTypeFactory typeFactory;
  final DartAnnotationsFactory annotationsFactory;

  const DartFieldFactory({
    this.typeFactory = const DartTypeFactory(),
    this.annotationsFactory = const DartFieldDartAnnotationsFactory(),
  });

  DartField create(
    XmlNode node,
  ) {
    if (node is XmlAttribute) {
      return DartField(
        name: node.localName.camelCase,
        type: typeFactory.create(node),
        annotations: annotationsFactory.create(node),
      );
    } else if (node is XmlCDATA) {
      return DartField(
        name: 'cdata',
        type: typeFactory.create(node),
        annotations: annotationsFactory.create(node),
      );
    } else if (node is XmlElement) {
      return DartField(
        name: node.localName.camelCase,
        type: typeFactory.create(node),
        annotations: annotationsFactory.create(node),
      );
    } else if (node is XmlText) {
      return DartField(
        name: 'text',
        type: typeFactory.create(node),
        annotations: annotationsFactory.create(node),
      );
    } else {
      throw ArgumentError.value(node, 'node');
    }
  }
}

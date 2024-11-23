import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_type.dart';

class DartTypeFactory {
  const DartTypeFactory();

  DartType create(
    XmlNode node,
  ) {
    if (node is XmlElement) {
      return DartType(
        name: node.localName.pascalCase,
      );
    }

    final String value;

    if (node is XmlAttribute) {
      value = node.value;
    } else if (node is XmlCDATA) {
      value = node.value;
    } else if (node is XmlText) {
      value = node.value;
    } else {
      throw ArgumentError.value(node, 'node');
    }

    if (int.tryParse(value) != null) {
      return const DartType(
        name: 'int',
      );
    } else if (double.tryParse(value) != null) {
      return const DartType(
        name: 'double',
      );
    } else if (DateTime.tryParse(value) != null) {
      return const DartType(
        name: 'DateTime',
      );
    } else if (value == 'true' || value == 'false') {
      return const DartType(
        name: 'bool',
      );
    } else {
      return const DartType(
        name: 'String',
      );
    }
  }
}

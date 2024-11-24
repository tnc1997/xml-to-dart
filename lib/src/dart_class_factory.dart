import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_annotation.dart';
import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_field_factory.dart';
import 'dart_field_reducer.dart';

class DartClassFactory {
  final DartFieldFactory fieldFactory;
  final DartFieldReducer fieldReducer;

  const DartClassFactory({
    this.fieldFactory = const DartFieldFactory(),
    this.fieldReducer = const DartFieldReducer(),
  });

  DartClass create(
    XmlNode node,
  ) {
    if (node is! XmlElement) {
      throw ArgumentError.value(node, 'node');
    }

    final fields = <String, DartField>{};

    for (final attribute in node.attributes) {
      final other = fieldFactory.create(attribute);

      fields.update(
        other.name,
        (value) {
          return fieldReducer.combine(value, other);
        },
        ifAbsent: () {
          return other;
        },
      );
    }

    final cdata = StringBuffer();
    final text = StringBuffer();

    for (final child in node.children) {
      if (child is XmlElement) {
        final other = fieldFactory.create(child);

        fields.update(
          other.name,
          (value) {
            return fieldReducer.combine(value, other);
          },
          ifAbsent: () {
            return other;
          },
        );
      } else if (child is XmlCDATA) {
        cdata.write(child.value.trim());
      } else if (child is XmlText) {
        text.write(child.value.trim());
      }
    }

    if (cdata.isNotEmpty) {
      fields['cdata'] = fieldFactory.create(XmlCDATA('$cdata'));
    }

    if (text.isNotEmpty) {
      fields['text'] = fieldFactory.create(XmlText('$text'));
    }

    return DartClass(
      name: node.localName.pascalCase,
      annotations: [
        XmlRootElementDartAnnotation.fromXmlElement(node),
        const XmlSerializableDartAnnotation(),
      ],
      fields: fields,
    );
  }
}

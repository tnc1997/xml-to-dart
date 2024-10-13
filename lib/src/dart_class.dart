import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';
import 'dart_type.dart';

class DartClass {
  final List<DartAnnotation> annotations;
  final Map<String, DartField> fields;

  const DartClass({
    required this.annotations,
    required this.fields,
  });

  factory DartClass.fromXmlElement(
    XmlElement element,
  ) {
    final fields = <String, DartField>{};

    for (final attribute in element.attributes) {
      fields[attribute.localName.camelCase] =
          DartField.fromXmlAttribute(attribute);
    }

    final cdata = StringBuffer();
    final text = StringBuffer();

    for (final child in element.children) {
      if (child is XmlElement) {
        fields[child.localName.camelCase] = DartField.fromXmlElement(child);
      } else if (child is XmlCDATA) {
        cdata.write(child.value.trim());
      } else if (child is XmlText) {
        text.write(child.value.trim());
      }
    }

    if (cdata.isNotEmpty) {
      fields['cdata'] = DartField(
        annotations: [const XmlCDATADartAnnotation()],
        type: DartType.fromValue(cdata.toString()),
      );
    }

    if (text.isNotEmpty) {
      fields['text'] = DartField(
        annotations: [const XmlTextDartAnnotation()],
        type: DartType.fromValue(text.toString()),
      );
    }

    return DartClass(
      annotations: [
        XmlRootElementDartAnnotation.fromXmlElement(element),
        const XmlSerializableDartAnnotation(),
      ],
      fields: fields,
    );
  }
}

class DartClassMerger {
  final DartFieldMerger _dartFieldMerger;

  const DartClassMerger({
    DartFieldMerger dartFieldMerger = const DartFieldMerger(),
  }) : _dartFieldMerger = dartFieldMerger;

  DartClass merge(
    DartClass a,
    DartClass b,
  ) {
    final fields = <String, DartField>{};
    for (final entry in a.fields.entries) {
      final other = b.fields[entry.key];
      if (other != null) {
        fields[entry.key] = _dartFieldMerger.merge(entry.value, other);
      } else {
        fields[entry.key] = entry.value;
      }
    }

    return DartClass(
      annotations: [...a.annotations],
      fields: fields,
    );
  }
}

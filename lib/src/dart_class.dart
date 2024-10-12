import 'package:recase/recase.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

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

  factory DartClass.fromXmlStartElementEvent(
    XmlStartElementEvent event,
  ) {
    return DartClass(
      annotations: [
        XmlRootElementDartAnnotation.fromXmlStartElementEvent(
          event,
        ),
        const XmlSerializableDartAnnotation(),
      ],
      fields: {
        for (final attribute in event.attributes)
          attribute.localName.camelCase: DartField.fromXmlEventAttribute(
            attribute,
          ),
      },
    );
  }

  DartClass copyWith({
    String? name,
    List<DartAnnotation>? annotations,
    Map<String, DartField>? fields,
  }) {
    return DartClass(
      annotations: annotations ?? this.annotations,
      fields: fields ?? this.fields,
    );
  }

  DartClass mergeWith(
    DartClass other,
  ) {
    for (final entry in other.fields.entries) {
      fields.update(
        entry.key,
        (value) {
          return value.mergeWith(entry.value);
        },
        ifAbsent: () {
          return entry.value;
        },
      );
    }

    return DartClass(
      annotations: annotations,
      fields: fields,
    );
  }
}

import 'package:recase/recase.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';
import 'dart_type.dart';

class DartClass {
  final String name;
  final List<DartAnnotation> annotations;
  final List<DartField> fields;

  const DartClass({
    required this.name,
    required this.annotations,
    required this.fields,
  });

  factory DartClass.fromXmlElement(
    XmlElement element,
  ) {
    final fields = <DartField>[];

    for (final attribute in element.attributes) {
      fields.add(DartField.fromXmlAttribute(attribute));
    }

    final cdata = StringBuffer();
    final text = StringBuffer();

    for (final child in element.children) {
      if (child is XmlElement) {
        fields.add(DartField.fromXmlElement(child));
      } else if (child is XmlCDATA) {
        cdata.write(child.value.trim());
      } else if (child is XmlText) {
        text.write(child.value.trim());
      }
    }

    if (cdata.isNotEmpty) {
      fields.add(
        DartField(
          name: 'cdata',
          annotations: [const XmlCDATADartAnnotation()],
          type: DartType.fromValue(cdata.toString()),
        ),
      );
    }

    if (text.isNotEmpty) {
      fields.add(
        DartField(
          name: 'text',
          annotations: [const XmlTextDartAnnotation()],
          type: DartType.fromValue(text.toString()),
        ),
      );
    }

    return DartClass(
      name: element.localName.pascalCase,
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
      name: event.localName.pascalCase,
      annotations: [
        XmlRootElementDartAnnotation.fromXmlStartElementEvent(
          event,
        ),
        const XmlSerializableDartAnnotation(),
      ],
      fields: [
        for (final attribute in event.attributes)
          DartField.fromXmlEventAttribute(
            attribute,
          ),
      ],
    );
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is DartClass && name == other.name;
  }

  DartClass copyWith({
    String? name,
    List<DartAnnotation>? annotations,
    List<DartField>? fields,
  }) {
    return DartClass(
      name: name ?? this.name,
      annotations: annotations ?? this.annotations,
      fields: fields ?? this.fields,
    );
  }

  DartClass mergeWith(
    DartClass other,
  ) {
    final fields = this.fields;

    for (final other in other.fields) {
      final index = fields.indexWhere(
        (field) {
          return field == other;
        },
      );

      if (index >= 0) {
        fields[index] = fields[index].mergeWith(other);
      } else {
        fields.add(other);
      }
    }

    return DartClass(
      name: name,
      annotations: annotations,
      fields: fields,
    );
  }

  @override
  String toString() {
    return name;
  }
}

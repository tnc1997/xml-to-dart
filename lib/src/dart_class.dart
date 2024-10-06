import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';

class DartClass {
  final String name;
  final List<DartAnnotation> annotations;
  final Map<String, DartField> fields;

  const DartClass({
    required this.name,
    required this.annotations,
    required this.fields,
  });

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
      fields: {
        for (final attribute in event.attributes)
          attribute.localName.camelCase: DartField.fromXmlEventAttribute(
            attribute,
          ),
      },
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
    Map<String, DartField>? fields,
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

    for (final other in other.fields.values) {
      fields.update(
        other.name,
        (field) {
          return field.mergeWith(other);
        },
        ifAbsent: () {
          return other;
        },
      );
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

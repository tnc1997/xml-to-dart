import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_type.dart';

class DartField {
  final String name;
  final List<DartAnnotation> annotations;
  final DartType type;

  const DartField({
    required this.name,
    required this.annotations,
    required this.type,
  });

  factory DartField.fromXmlCDATAEvent(
    XmlCDATAEvent event,
  ) {
    return DartField(
      name: 'cdata',
      annotations: [
        const XmlCDATADartAnnotation(),
      ],
      type: DartType.fromValue(
        event.value,
      ),
    );
  }

  factory DartField.fromXmlEventAttribute(
    XmlEventAttribute attribute,
  ) {
    return DartField(
      name: attribute.localName.camelCase,
      annotations: [
        XmlAttributeDartAnnotation.fromXmlEventAttribute(
          attribute,
        ),
      ],
      type: DartType.fromValue(
        attribute.value,
      ),
    );
  }

  factory DartField.fromXmlStartElementEvent(
    XmlStartElementEvent event,
  ) {
    return DartField(
      name: event.localName.camelCase,
      annotations: [
        XmlElementDartAnnotation.fromXmlStartElementEvent(
          event,
        ),
      ],
      type: DartType(
        name: event.localName.pascalCase,
        nullabilitySuffix: NullabilitySuffix.none,
      ),
    );
  }

  factory DartField.fromXmlTextEvent(
    XmlTextEvent event,
  ) {
    return DartField(
      name: 'text',
      annotations: [
        const XmlTextDartAnnotation(),
      ],
      type: DartType.fromValue(
        event.value,
      ),
    );
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is DartField && name == other.name;
  }

  DartField copyWith({
    String? name,
    List<DartAnnotation>? annotations,
    DartType? type,
  }) {
    return DartField(
      name: name ?? this.name,
      annotations: annotations ?? this.annotations,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return name;
  }
}

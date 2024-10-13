import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_annotation.dart';
import 'dart_type.dart';

class DartField {
  final List<DartAnnotation> annotations;
  final DartType type;

  const DartField({
    required this.annotations,
    required this.type,
  });

  factory DartField.fromXmlAttribute(
    XmlAttribute attribute,
  ) {
    return DartField(
      annotations: [
        XmlAttributeDartAnnotation.fromXmlAttribute(
          attribute,
        ),
      ],
      type: DartType.fromValue(
        attribute.value.trim(),
      ),
    );
  }

  factory DartField.fromXmlCDATA(
    XmlCDATA cdata,
  ) {
    return DartField(
      annotations: [
        const XmlCDATADartAnnotation(),
      ],
      type: DartType.fromValue(
        cdata.value.trim(),
      ),
    );
  }

  factory DartField.fromXmlElement(
    XmlElement element,
  ) {
    return DartField(
      annotations: [
        XmlElementDartAnnotation.fromXmlElement(
          element,
        ),
      ],
      type: DartType(
        name: element.localName.pascalCase,
        nullabilitySuffix: NullabilitySuffix.none,
      ),
    );
  }

  factory DartField.fromXmlText(
    XmlText text,
  ) {
    return DartField(
      annotations: [
        const XmlTextDartAnnotation(),
      ],
      type: DartType.fromValue(
        text.value.trim(),
      ),
    );
  }
}

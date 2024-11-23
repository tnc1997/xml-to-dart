import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';
import 'dart_field_factory.dart';
import 'dart_type.dart';
import 'dart_type_reducer.dart';
import 'nullability_suffix.dart';

class DartClass {
  final String name;
  final List<DartAnnotation> annotations;
  final Map<String, DartField> fields;

  const DartClass({
    required this.name,
    required this.annotations,
    required this.fields,
  });

  factory DartClass.fromXmlElement(
    XmlElement element,
  ) {
    final fields = <String, DartField>{};

    for (final attribute in element.attributes) {
      final other = const DartFieldFactory().create(attribute);

      fields.update(
        other.name,
        (value) {
          if (value.type.name == 'List' && other.type.name == 'List') {
            return DartField(
              name: value.name,
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeReducer().combine(
                    value.type.typeArguments.single,
                    other.type.typeArguments.single,
                  ),
                ],
              ),
            );
          } else if (value.type.name == 'List') {
            return DartField(
              name: value.name,
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeReducer().combine(
                    value.type.typeArguments.single,
                    other.type,
                  ),
                ],
              ),
            );
          } else if (other.type.name == 'List') {
            return DartField(
              name: value.name,
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeReducer().combine(
                    value.type,
                    other.type.typeArguments.single,
                  ),
                ],
              ),
            );
          } else {
            return DartField(
              name: value.name,
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeReducer().combine(
                    value.type,
                    other.type,
                  ),
                ],
              ),
            );
          }
        },
        ifAbsent: () {
          return other;
        },
      );
    }

    final cdata = StringBuffer();
    final text = StringBuffer();

    for (final child in element.children) {
      if (child is XmlElement) {
        final other = const DartFieldFactory().create(child);

        fields.update(
          other.name,
          (value) {
            if (value.type.name == 'List' && other.type.name == 'List') {
              return DartField(
                name: value.name,
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeReducer().combine(
                      value.type.typeArguments.single,
                      other.type.typeArguments.single,
                    ),
                  ],
                ),
              );
            } else if (value.type.name == 'List') {
              return DartField(
                name: value.name,
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeReducer().combine(
                      value.type.typeArguments.single,
                      other.type,
                    ),
                  ],
                ),
              );
            } else if (other.type.name == 'List') {
              return DartField(
                name: value.name,
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeReducer().combine(
                      value.type,
                      other.type.typeArguments.single,
                    ),
                  ],
                ),
              );
            } else {
              return DartField(
                name: value.name,
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeReducer().combine(
                      value.type,
                      other.type,
                    ),
                  ],
                ),
              );
            }
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
      fields['cdata'] = const DartFieldFactory().create(XmlCDATA('$cdata'));
    }

    if (text.isNotEmpty) {
      fields['text'] = const DartFieldFactory().create(XmlText('$text'));
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
}

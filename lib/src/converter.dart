import 'dart:convert';

import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_type.dart';
import 'namer.dart';

class XmlToDartConverter extends Converter<List<XmlEvent>, List<DartClass>> {
  const XmlToDartConverter();

  @override
  List<DartClass> convert(
    List<XmlEvent> input,
  ) {
    final classes = <String, DartClass>{};

    for (final event in input) {
      if (event is XmlStartElementEvent) {
        final fields = <String, DartField>{};

        for (final attribute in event.attributes) {
          fields.update(
            camelCaseNamer(
              attribute.localName,
              attribute.namespaceUri,
            ),
            (value) {
              return value.copyWith(
                type: value.type.mergeWith(
                  DartType.fromValue(
                    attribute.value,
                  ),
                ),
              );
            },
            ifAbsent: () {
              return DartField(
                name: camelCaseNamer(
                  attribute.localName,
                  attribute.namespaceUri,
                ),
                annotations: [
                  XmlAttributeDartAnnotation.fromXmlEventAttribute(
                    attribute,
                  ),
                ],
                type: DartType.fromValue(
                  attribute.value,
                ),
              );
            },
          );
        }

        classes.update(
          pascalCaseNamer(
            event.localName,
            event.namespaceUri,
          ),
          (value) {
            return DartClass(
              name: pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              annotations: [
                XmlRootElementDartAnnotation.fromXmlStartElementEvent(
                  event,
                ),
                const XmlSerializableDartAnnotation(),
              ],
              fields: fields,
            );
          },
          ifAbsent: () {
            return DartClass(
              name: pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              annotations: [
                XmlRootElementDartAnnotation.fromXmlStartElementEvent(
                  event,
                ),
                const XmlSerializableDartAnnotation(),
              ],
              fields: fields,
            );
          },
        );

        final parent = event.parent;
        if (parent != null) {
          classes[pascalCaseNamer(
            parent.name,
            parent.namespaceUri,
          )]
              ?.fields[camelCaseNamer(
            event.localName,
            event.namespaceUri,
          )] = DartField(
            name: camelCaseNamer(
              event.localName,
              event.namespaceUri,
            ),
            annotations: [
              XmlElementDartAnnotation.fromXmlStartElementEvent(
                event,
              ),
            ],
            type: DartType(
              name: pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              nullabilitySuffix: NullabilitySuffix.none,
            ),
          );
        }
      } else if (event is XmlCDATAEvent) {
        final parent = event.parent;
        if (parent != null && event.value.isNotEmpty) {
          classes[pascalCaseNamer(
            parent.name,
            parent.namespaceUri,
          )]
              ?.fields['cdata'] = DartField(
            name: 'cdata',
            annotations: [
              const XmlCDATADartAnnotation(),
            ],
            type: DartType.fromValue(
              event.value,
            ),
          );
        }
      } else if (event is XmlTextEvent) {
        final parent = event.parent;
        if (parent != null && event.value.isNotEmpty) {
          classes[pascalCaseNamer(
            parent.name,
            parent.namespaceUri,
          )]
              ?.fields['text'] = DartField(
            name: 'text',
            annotations: [
              const XmlTextDartAnnotation(),
            ],
            type: DartType.fromValue(
              event.value,
            ),
          );
        }
      }
    }

    return [...classes.values];
  }

  @override
  Sink<List<XmlEvent>> startChunkedConversion(
    Sink<List<DartClass>> sink,
  ) {
    return _XmlToDartSink(sink);
  }
}

class _XmlToDartSink implements Sink<List<XmlEvent>> {
  final Sink<List<DartClass>> _sink;
  final Map<String, DartClass> _classes;

  _XmlToDartSink(this._sink) : _classes = {};

  @override
  void add(
    List<XmlEvent> event,
  ) {
    for (final event in event) {
      if (event is XmlStartElementEvent) {
        final fields = <String, DartField>{};

        for (final attribute in event.attributes) {
          fields.update(
            camelCaseNamer(
              attribute.localName,
              attribute.namespaceUri,
            ),
            (value) {
              return value.copyWith(
                type: value.type.mergeWith(
                  DartType.fromValue(
                    attribute.value,
                  ),
                ),
              );
            },
            ifAbsent: () {
              return DartField(
                name: camelCaseNamer(
                  attribute.localName,
                  attribute.namespaceUri,
                ),
                annotations: [
                  XmlAttributeDartAnnotation.fromXmlEventAttribute(
                    attribute,
                  ),
                ],
                type: DartType.fromValue(
                  attribute.value,
                ),
              );
            },
          );
        }

        _classes.update(
          pascalCaseNamer(
            event.localName,
            event.namespaceUri,
          ),
          (value) {
            return DartClass(
              name: pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              annotations: [
                XmlRootElementDartAnnotation.fromXmlStartElementEvent(
                  event,
                ),
                const XmlSerializableDartAnnotation(),
              ],
              fields: fields,
            );
          },
          ifAbsent: () {
            return DartClass(
              name: pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              annotations: [
                XmlRootElementDartAnnotation.fromXmlStartElementEvent(
                  event,
                ),
                const XmlSerializableDartAnnotation(),
              ],
              fields: fields,
            );
          },
        );

        final parent = event.parent;
        if (parent != null) {
          _classes[pascalCaseNamer(
            parent.name,
            parent.namespaceUri,
          )]
              ?.fields[camelCaseNamer(
            event.localName,
            event.namespaceUri,
          )] = DartField(
            name: camelCaseNamer(
              event.localName,
              event.namespaceUri,
            ),
            annotations: [
              XmlElementDartAnnotation.fromXmlStartElementEvent(
                event,
              ),
            ],
            type: DartType(
              name: pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
              nullabilitySuffix: NullabilitySuffix.none,
            ),
          );
        }
      } else if (event is XmlCDATAEvent) {
        final parent = event.parent;
        if (parent != null && event.value.isNotEmpty) {
          _classes[pascalCaseNamer(
            parent.name,
            parent.namespaceUri,
          )]
              ?.fields['cdata'] = DartField(
            name: 'cdata',
            annotations: [
              const XmlCDATADartAnnotation(),
            ],
            type: DartType.fromValue(
              event.value,
            ),
          );
        }
      } else if (event is XmlTextEvent) {
        final parent = event.parent;
        if (parent != null && event.value.isNotEmpty) {
          _classes[pascalCaseNamer(
            parent.name,
            parent.namespaceUri,
          )]
              ?.fields['text'] = DartField(
            name: 'text',
            annotations: [
              const XmlTextDartAnnotation(),
            ],
            type: DartType.fromValue(
              event.value,
            ),
          );
        }
      }
    }
  }

  @override
  void close() {
    _sink.add([..._classes.values]);
    _sink.close();
  }
}

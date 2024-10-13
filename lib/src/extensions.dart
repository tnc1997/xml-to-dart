import 'dart:async';

import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_type.dart';

extension ToDartClassListExtension on Stream<List<XmlEvent>> {
  Future<Map<String, DartClass>> toDartClassMap() async {
    final classes = <String, DartClass>{};

    final completer = Completer<Map<String, DartClass>>();

    final subscription = listen(
      (events) {
        for (final event in events) {
          final parent = classes[event.parent?.name.pascalCase];

          if (event is XmlStartElementEvent) {
            final other = DartClass.fromXmlStartElementEvent(event);

            classes.update(
              event.localName.pascalCase,
              (value) {
                return const DartClassMerger().merge(value, other);
              },
              ifAbsent: () {
                return other;
              },
            );

            if (parent != null) {
              final other = XmlElementDartField(
                type: DartType(
                  name: event.localName.pascalCase,
                  nullabilitySuffix: NullabilitySuffix.none,
                ),
                name: event.localName,
                namespace: event.namespaceUri,
                isSelfClosing: event.isSelfClosing,
              );

              parent.fields.update(
                event.localName.camelCase,
                (value) {
                  return value
                    ..type = const DartTypeMerger().merge(
                      value.type,
                      other.type,
                    );
                },
                ifAbsent: () {
                  return other;
                },
              );
            }
          } else if (event is XmlCDATAEvent) {
            if (parent != null) {
              if (event.value.trim().isNotEmpty) {
                final other = XmlCDATADartField(
                  type: DartType.fromValue(
                    event.value.trim(),
                  ),
                );

                parent.fields.update(
                  'cdata',
                  (value) {
                    return value
                      ..type = const DartTypeMerger().merge(
                        value.type,
                        other.type,
                      );
                  },
                  ifAbsent: () {
                    return other;
                  },
                );
              }
            }
          } else if (event is XmlTextEvent) {
            if (parent != null) {
              if (event.value.trim().isNotEmpty) {
                final other = XmlTextDartField(
                  type: DartType.fromValue(
                    event.value.trim(),
                  ),
                );

                parent.fields.update(
                  'text',
                  (value) {
                    return value
                      ..type = const DartTypeMerger().merge(
                        value.type,
                        other.type,
                      );
                  },
                  ifAbsent: () {
                    return other;
                  },
                );
              }
            }
          }
        }
      },
      onError: (error, stackTrace) {
        completer.completeError(error, stackTrace);
      },
      onDone: () {
        completer.complete(classes);
      },
      cancelOnError: true,
    );

    try {
      return await completer.future;
    } finally {
      await subscription.cancel();
    }
  }
}

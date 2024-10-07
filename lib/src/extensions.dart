import 'dart:async';

import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

import 'dart_class.dart';
import 'dart_field.dart';

extension ToDartClassListExtension on Stream<List<XmlEvent>> {
  Future<List<DartClass>> toDartClassList() async {
    final classes = <DartClass>[];

    final completer = Completer<List<DartClass>>();

    final subscription = listen(
      (events) {
        for (final event in events) {
          final parent = classes.cast<DartClass?>().singleWhere(
            (class_) {
              return class_?.name == event.parent?.name.pascalCase;
            },
            orElse: () {
              return null;
            },
          );

          if (event is XmlStartElementEvent) {
            final other = DartClass.fromXmlStartElementEvent(event);

            final index = classes.indexWhere(
              (class_) {
                return class_ == other;
              },
            );

            if (index >= 0) {
              classes[index] = classes[index].mergeWith(other);
            } else {
              classes.add(other);
            }

            if (parent != null) {
              final other = DartField.fromXmlStartElementEvent(event);

              final index = parent.fields.indexWhere(
                (field) {
                  return field == other;
                },
              );

              if (index >= 0) {
                parent.fields[index] = parent.fields[index].mergeWith(other);
              } else {
                parent.fields.add(other);
              }
            }
          } else if (event is XmlCDATAEvent) {
            if (parent != null) {
              if (event.value.trim().isNotEmpty) {
                final other = DartField.fromXmlCDATAEvent(event);

                final index = parent.fields.indexWhere(
                  (field) {
                    return field == other;
                  },
                );

                if (index >= 0) {
                  parent.fields[index] = parent.fields[index].mergeWith(other);
                } else {
                  parent.fields.add(other);
                }
              }
            }
          } else if (event is XmlTextEvent) {
            if (parent != null) {
              if (event.value.trim().isNotEmpty) {
                final other = DartField.fromXmlTextEvent(event);

                final index = parent.fields.indexWhere(
                  (field) {
                    return field == other;
                  },
                );

                if (index >= 0) {
                  parent.fields[index] = parent.fields[index].mergeWith(other);
                } else {
                  parent.fields.add(other);
                }
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

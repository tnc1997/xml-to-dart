import 'package:test/test.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

void main() {
  group(
    'DartFieldReducer',
    () {
      group(
        'combine',
        () {
          test(
            'should return the combined field for a field with a type with a name of list and a type argument with a name of string and a field with a type with a name of list and a type argument with a name of string',
            () {
              // Arrange
              final a = DartField(
                name: 'value',
                type: DartType(
                  name: 'List',
                  typeArguments: [
                    DartType(
                      name: 'String',
                    ),
                  ],
                ),
              );

              final b = DartField(
                name: 'value',
                type: DartType(
                  name: 'List',
                  typeArguments: [
                    DartType(
                      name: 'String',
                    ),
                  ],
                ),
              );

              // Act
              final field = const DartFieldReducer().combine(a, b);

              // Assert
              expect(
                field.name,
                equals('value'),
              );

              expect(
                field.type.name,
                equals('List'),
              );

              expect(
                field.type.typeArguments.single.name,
                equals('String'),
              );
            },
          );

          test(
            'should return the combined field for a field with a type with a name of list and a type argument with a name of string and a field with a type with a name of string',
            () {
              // Arrange
              final a = DartField(
                name: 'value',
                type: DartType(
                  name: 'List',
                  typeArguments: [
                    DartType(
                      name: 'String',
                    ),
                  ],
                ),
              );

              final b = DartField(
                name: 'value',
                type: DartType(
                  name: 'String',
                ),
              );

              // Act
              final field = const DartFieldReducer().combine(a, b);

              // Assert
              expect(
                field.name,
                equals('value'),
              );

              expect(
                field.type.name,
                equals('List'),
              );

              expect(
                field.type.typeArguments.single.name,
                equals('String'),
              );
            },
          );

          test(
            'should return the combined field for a field with a type with a name of string and a field with a type with a name of string',
            () {
              // Arrange
              final a = DartField(
                name: 'value',
                type: DartType(
                  name: 'String',
                ),
              );

              final b = DartField(
                name: 'value',
                type: DartType(
                  name: 'String',
                ),
              );

              // Act
              final field = const DartFieldReducer().combine(a, b);

              // Assert
              expect(
                field.name,
                equals('value'),
              );

              expect(
                field.type.name,
                equals('List'),
              );

              expect(
                field.type.typeArguments.single.name,
                equals('String'),
              );
            },
          );

          test(
            'should return the combined field for a field with a type with a name of string and a field with a type with a name of list and a type argument with a name of string',
            () {
              // Arrange
              final a = DartField(
                name: 'value',
                type: DartType(
                  name: 'String',
                ),
              );

              final b = DartField(
                name: 'value',
                type: DartType(
                  name: 'List',
                  typeArguments: [
                    DartType(
                      name: 'String',
                    ),
                  ],
                ),
              );

              // Act
              final field = const DartFieldReducer().combine(a, b);

              // Assert
              expect(
                field.name,
                equals('value'),
              );

              expect(
                field.type.name,
                equals('List'),
              );

              expect(
                field.type.typeArguments.single.name,
                equals('String'),
              );
            },
          );
        },
      );
    },
  );
}

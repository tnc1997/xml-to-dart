import 'package:test/test.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

void main() {
  group(
    'DartTypeReducer',
    () {
      group(
        'combine',
        () {
          test(
            'should return the combined type for a type with a name of list and a nullability suffix of none a type argument with a name of int and a nullability suffix of none and a type with a name of list and a nullability suffix of none and a type argument with a name of double and a nullability suffix of none',
            () {
              // Arrange
              final a = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'int',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              final b = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'double',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.name,
                equals('List'),
              );

              expect(
                type.typeArguments.single.name,
                equals('String'),
              );
            },
          );

          test(
            'should return the combined type for a type with a name of list and a nullability suffix of none a type argument with a name of int and a nullability suffix of none and a type with a name of list and a nullability suffix of none and a type argument with a name of int and a nullability suffix of none',
            () {
              // Arrange
              final a = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'int',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              final b = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'int',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.name,
                equals('List'),
              );

              expect(
                type.typeArguments.single.name,
                equals('int'),
              );
            },
          );

          test(
            'should return the combined type for a type with a name of int and a nullability suffix of none and a type with a name of double and a nullability suffix of none',
            () {
              // Arrange
              final a = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              final b = DartType(
                name: 'double',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.name,
                equals('String'),
              );

              expect(
                type.nullabilitySuffix,
                equals(NullabilitySuffix.none),
              );
            },
          );

          test(
            'should return the combined type for a type with a name of int and a nullability suffix of none and a type with a name of int and a nullability suffix of none',
            () {
              // Arrange
              final a = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              final b = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.name,
                equals('int'),
              );

              expect(
                type.nullabilitySuffix,
                equals(NullabilitySuffix.none),
              );
            },
          );

          test(
            'should return the combined type for a type with a name of int and a nullability suffix of none and a type with a name of int and a nullability suffix of question',
            () {
              // Arrange
              final a = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              final b = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.nullabilitySuffix,
                equals(NullabilitySuffix.question),
              );
            },
          );

          test(
            'should return the combined type for a type with a name of int and a nullability suffix of question and a type with a name of int and a nullability suffix of none',
            () {
              // Arrange
              final a = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [],
              );

              final b = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.nullabilitySuffix,
                equals(NullabilitySuffix.question),
              );
            },
          );

          test(
            'should return the combined type for a type with a name of int and a nullability suffix of question and a type with a name of int and a nullability suffix of question',
            () {
              // Arrange
              final a = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [],
              );

              final b = DartType(
                name: 'int',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [],
              );

              // Act
              final type = const DartTypeReducer().combine(a, b);

              // Assert
              expect(
                type.nullabilitySuffix,
                equals(NullabilitySuffix.question),
              );
            },
          );
        },
      );
    },
  );
}

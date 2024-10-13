import 'package:test/test.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

void main() {
  group(
    'DartType',
    () {
      group(
        'toString',
        () {
          test(
            'should return the string representation for a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'String',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('String'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('List<String>'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('List<String?>'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String, String>'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String?, String>'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String, String?>'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String?, String?>'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'String',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('String?'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('List<String>?'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('List<String?>?'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String, String>?'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String?, String>?'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String, String?>?'),
              );
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(
                string,
                equals('Map<String?, String?>?'),
              );
            },
          );
        },
      );
    },
  );

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

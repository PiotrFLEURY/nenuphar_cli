import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

class JsonSchemaGeneratorDelegate {
  const JsonSchemaGeneratorDelegate();

  Map<String, dynamic> generateSchema(Element element) {
    if (element.displayName == 'dynamic') {
      return {'type': 'dynamic'};
    }

    if (element is FieldElement) {
      final type = element.type;

      // Check if type is a primitive type
      if (type.isDartCoreString) {
        return {'type': 'string'};
      } else if (type.isDartCoreInt) {
        return {'type': 'integer', 'format': 'int64'};
      } else if (type.isDartCoreDouble) {
        return {'type': 'number'};
      } else if (type.isDartCoreBool) {
        return {'type': 'boolean'};
      }

      // Check if type is a List
      if (type.isDartCoreList) {
        // if Lits has type arguments (ex: List<String>)
        if (type is InterfaceType && type.typeArguments.isNotEmpty) {
          final listType = type.typeArguments[0];
          final listTypeSchema = generateSchema(listType.element!);
          return {
            'type': 'array',
            'items': listTypeSchema,
          };
        }
        return {
          'type': 'array',
          'items': {'type': 'dynamic'},
        };
      }

      // Check if type is a Map
      if (type.isDartCoreMap) {
        // if Map has type arguments (ex: Map<String, int>)
        if (type is InterfaceType && type.typeArguments.isNotEmpty) {
          final mapKeyType = type.typeArguments[0];
          final mapValueType = type.typeArguments[1];
          final mapKeyTypeSchema = generateSchema(mapKeyType.element!);
          final mapValueTypeSchema = generateSchema(mapValueType.element!);
          return {
            'type': 'object',
            'additionalProperties': {
              'key': mapKeyTypeSchema,
              'value': mapValueTypeSchema,
            },
          };
        }
        return {
          'type': 'object',
          'additionalProperties': {'type': 'dynamic'},
        };
      }
    }

    return generateSchemaFromClass(element as ClassElement);
  }

  Map<String, dynamic> generateSchemaFromClass(ClassElement element) {
    final type = element.thisType;
    // Check if type is a primitive type
    if (type.isDartCoreString) {
      return {'type': 'string'};
    } else if (type.isDartCoreInt) {
      return {'type': 'integer', 'format': 'int64'};
    } else if (type.isDartCoreDouble) {
      return {'type': 'number'};
    } else if (type.isDartCoreBool) {
      return {'type': 'boolean'};
    }

    final classFields = {
      for (var field in element.fields) field.name: generateSchema(field)
    };

    return {
      'type': 'object',
      'properties': classFields,
    };
  }
}

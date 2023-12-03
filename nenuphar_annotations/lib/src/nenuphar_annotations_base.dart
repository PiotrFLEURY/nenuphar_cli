///
/// Represents a class that should be documented as a JSON schema.
///
/// eg:
///   @JsonSchema()
///   class Person {
///     final String name;
///     final int age;
///     final List<Person> friends;
///     final Map<String, Person> family;
///
///     Person(this.name, this.age, this.friends, this.family);
///   }
///
/// The generated JSON schema will be:
///
///   {
///     "type": "object",
///     "properties": {
///     "name": {"type": "string"},
///     "age": {"type": "integer"},
///     "friends": {
///     "type": "array",
///     "items": {"\$ref": "#/definitions/Person"}
///   },
///
class JsonSchema {
  /// Creates a new instance of [JsonSchema].
  const JsonSchema();
}

///
/// A constant instance of [JsonSchema] for simplest syntax.
///
/// eg:
///   @jsonSchema
///   class Person {
///     // ...
///   }
///
/// @see [JsonSchema]
///
const jsonSchema = JsonSchema();

///
/// Represents the allowed HTTP methods for a route.
/// eg:
///  @Allow('GET', 'HEAD')
///
class Allow {
  const Allow(this.methods);

  final List<String> methods;
}

///
/// Represents the HTTP request headers for a route.
/// eg:
/// @Header(['User-Name'])
///
class Header {
  const Header(this.headers);

  final List<String> headers;
}

///
/// Represents the HTTP request query parameters for a route.
/// eg:
/// @Query(['completed'])
///
class Query {
  const Query(this.queryParams);

  final List<String> queryParams;
}

///
/// Represents the Security schemes.
/// eg:
/// @Security(['todos_basic_auth', 'todos_oauth'])
///
class Security {
  const Security(this.securitySchemes);

  final List<String> securitySchemes;
}

///
/// Represents the Security scopes.
/// eg:
/// @Scope(['read:todos', 'write:todos'])
///
class Scope {
  const Scope(this.scopes);

  final List<String> scopes;
}

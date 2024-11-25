import 'package:nenuphar_annotations/nenuphar_annotations.dart';

@jsonSchema // This annotation is required to generate the schema
class Person {
  final String name;
  final int age;
  final List<Person> friends;
  final Map<String, Person> family;

  Person(this.name, this.age, this.friends, this.family);
}

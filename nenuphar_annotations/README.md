# Nenuphar annotations

This package contains the annotations of the [nenuphar_cli](https://pub.dev/packages/nenuphar_cli)

## How to use

### 1. CLI

Activate the nenuphar_cli plugin

```bash
dart pub global activate nenuphar_cli
```

### 2. Dependencies

Add the dependencies to your pubspec.yaml

* [nenuphar_annotations](https://pub.dev/packages/nenuphar_annotations)
* [nenuphar_generator](https://pub.dev/packages/nenuphar_generator)
* [build_runner](https://pub.dev/packages/build_runner)

```bash
dart pub add nenuphar_annotations dev:nenuphar_generator dev:build_runner
```

### 3. Add annotations

Add the annotations to your code

**jsonSchema** : Add this annotation to the class you want to generate the schema

```dart
import 'package:nenuphar_annotations/nenuphar_annotations.dart';

@jsonSchema // <-- Add this annotation
class MyModel {
    final String name;
    final int age;
    
    MyModel(this.name, this.age);
    
}

```

### 4. Generate the code

Run the following command to generate the code

```bash
dart run build_runner build
```

### 5. Generates the openapi.yaml

Run the following command to generate the openapi.yaml

```bash
nenuphar init # Optional if already done before
nenuphar gen
```

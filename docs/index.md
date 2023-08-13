# Nenuphar Documentation

[Dart Frog](#dart-frog)
- [Create a new Dart Frog project](#create-a-new-dart-frog-project)

[Swagger OpenAPI](#swagger-openapi)
- [OpenAPI Specification](#openapi-specification)
- [Swagger UI](#swagger-ui)

[Nenuphar](#nenuphar)
- [Installation](#installation)
- [Initialize your project](#initialize-your-project)
- [Generate openapi definition file](#generate-openapi-definition-file)
- [Declare resources components](#resources-components)
  - [Declare a resource](#declare-a-resource)
- [Parameters](#parameters)
  - [Header](#header)
  - [Query](#query)
  - [Path](#path)
  - [Body](#body)
- [Start your Dart Frog server](#start-your-dart-frog-server)
- [Enjoy 🎉](#enjoy-)

# Dart Frog

<img src="https://raw.githubusercontent.com/PiotrFLEURY/nenuphar_cli/main/docs/pictures/dart_frog_logo.svg" width="100" height="100" />

[Dart Frog](https://dartfrog.vgv.dev/) is a minimalistic backend framework for Dart.

## Create a new Dart Frog project

To create a new Dart Frog backend project, run the following command:

```sh
dart pub global activate dart_frog_cli
dart_frog create <project name>
```

# Swagger OpenAPI

<img src="https://static1.smartbear.co/swagger/media/assets/images/swagger_logo.svg" width="300" height="100" style="background-color:white;padding:16;" />

Swagger is a set of open source tools built around the OpenAPI Specification that can help you design, build, document and consume REST APIs.

## OpenAPI Specification

The OpenAPI Specification (OAS) defines a standard, language-agnostic interface to RESTful APIs which allows both humans and computers to discover and understand the capabilities of the service without access to source code, documentation, or through network traffic inspection.

Please visit [https://swagger.io/specification/v3/](https://swagger.io/specification/v3/) for more information.

## Swagger UI

Swagger UI allows anyone — be it your development team or your end consumers — to visualize and interact with the API’s resources without having any of the implementation logic in place. It’s automatically generated from your OpenAPI (formerly known as Swagger) Specification, with the visual documentation making it easy for back end implementation and client side consumption.

<img src="https://static1.smartbear.co/swagger/media/images/tools/opensource/swagger_ui.png" height="400" />

Please visit [https://swagger.io/tools/swagger-ui/](https://swagger.io/tools/swagger-ui/) for more information.

# Nenuphar 

## Installation

```sh
dart pub global activate nenuphar_cli
```

## Initialize your project

First you need to initialize your project by running the following command in the root of your project:

```sh
nenuphar init
```

This will create new file `public/index.html`. This file will be served statically by your Dart Frog server to expose your `Swagger UI` documentation.

### Available options

| Option | Abbr | Description | Default value |
| --- | --- | --- | --- |
| --url | -u | Url to the openapi definition file | http://localhost:8080/public/openapi.json |
| --override | -o | Override existing file | false |

## Generate openapi definition file

Nenuphar scans your Dart Frog project to generate an OpenAPI definition file.
Each route will generate the CRUD operations documentation for the exposed resource.

> NOTICE:
> 
> nenuphar ignores the `/` route by default.

First create a Dart Frog route:

```sh
dart_frog new route "/todos"
```

Then generate the OpenAPI definition file

```sh
nenuphar gen
```

### Available options

| Option | Abbr | Description | Default value |
| --- | --- | --- | --- |
| --output | -o | Output file | public/openapi.json |

The openapi specification will be written in the `public/openapi.json` file.
This file is loaded by the `public/index.html` file to display the documentation.

> NOTICE: 
> 
> You need to run the nenuphar gen command each time you update your API.

## Resources components

To declare any resource component, you need to create a json file in the `components/` folder using the same name as the resource.

For example, if you want to declare a `Todo` resource for the `/todos` path, you need to create a `components/todos.json` file.

### Declare a resource

```json
{
  "type": "object",
  "properties": {
    "id": {
      "type": "integer",
      "format": "int64",
    },
    "name": {
      "type": "string",
    },
    "done": {
      "type": "boolean",
    }
  }
}
```

See [OpenAPI schema object specification](https://swagger.io/specification/#schema-object) for more information.

## Parameters

### Header

Nenuphar searches a specific documentation comment in your Dart Frog route to generate the header parameters.

Add the `@Header` tag to your documentation comment to generate the header parameter.

The name of the parameter is the value of the `@Header` tag.

```dart
/// @Header(Authorization)
Future<Response> onRequest(RequestContext context) async {
  // ...
}
```

### Query

Nenuphar searches a specific documentation comment in your Dart Frog route to generate the query parameters.

Add the `@Query` tag to your documentation comment to generate the header parameter.

The name of the parameter is the value of the `@Query` tag.

```dart
/// @Query(completed)
Future<Response> onRequest(RequestContext context) async {
  // ...
}
```

### Path

Path parameters are automatically detected by nenuphar using the Dart Frog [Dynamic routes system](https://dartfrog.vgv.dev/docs/basics/routes#dynamic-routes-)

### Body

Body parameters are generated using the [Resource components](#resources-components) declared in the `components/` folder.

## Start your Dart Frog server

You're now ready to start your Dart Frog server

```sh
dart_frog dev
```

Visit [http://localhost:8080/index.html](http://localhost:8080/index.html) to see your documentation.

```sh
open http://localhost:8080/index.html
```

## Enjoy 🎉

<img src="https://raw.githubusercontent.com/PiotrFLEURY/nenuphar_cli/main/docs/pictures/nenuphar_swagger.png" height="400" />

__Thanks for using Nenuphar!__
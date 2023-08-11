# Nenuphar Documentation

## Installation

### From pub.dev

```sh
dart pub global activate nenuphar_cli
```

## Initialize a new project

Run the following command in the root of your project:

```sh
nenuphar init
```

A new file `index.html` will be created in the `public` folder of your project.

## Generate openapi definition file

Run the following command in the root of your project:

```sh
# Example: nenuphar gen --output public/openapi.json
nenuphar gen --output <output file>
```

> NOTICE: 
> 
> You need to run the nenuphar gen command each time you update your API.

## Declare resources components

To declare any resource component, you need to create a json file in the `components/` folder using the same name as the resource.

For example, if you want to declare a `User` resource for the `users` path, you need to create a `components/user.json` file.

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
    }
  }
}
```

See [OpenAPI schema object specification](https://swagger.io/specification/#schema-object) for more information.

## Start your Dart Frog server

Run the following command in the root of your project:

```sh
dart_frog dev
```

Visit [http://localhost:8080/index.html](http://localhost:8080/index.html) to see your documentation.

## Enjoy 🎉

<img src="pictures/logo.png" width="100" height="100" />

__Thanks for using Nenuphar!__


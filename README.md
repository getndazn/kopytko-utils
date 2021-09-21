# Kopytko Utils

Kopytko Utils is a modern BrightScript utility library inspired by mechanisms and libraries of the JavaScript world.
As a part of Kopytko Roku Ecosystem it is a Kopytko Module, easy to import using
[Kopytko Packager](https://github.com/getndazn/kopytko-packager).

## Requirements

Kopytko Utils uses the Kopytko Packager's importing mechanism therefore it will work only with apps using the Packager too.
However, there are some atomic, independent functions (e.g. getProperty, getType, ternary) that could be used without it.

## Installation

Using npm: `npm i @kopytko/utils`

Your Kopytko Packager-configured app will automatically add Utils code into the package.

## Main features

- lodash library inspired Array, Math and Object utils
- JS-based Promise object and related functions
- JS-based interval and timeout functions
- JS's `apply`-based `functionCall` function to run any function in a specific context
- Basic ReactiveX-inspired implementation of observables
- SceneGraph's Node utils
- Animator - an easier to use facade over SceneGraph's animation mechanisms
- facades of some BrightScript's Components and their mocks ready to use with [Kopytko Unit Testing Framework](https://github.com/getndazn/kopytko-unit-testing-framework)
- other utilities, e.g. isFalsy, padStart, uuid functions

### Docs

Every public function is documented using JSDoc syntax in the [source code](/src/components)


### Mocking Kopytko Utils' entities

To make easier mock [BrightScript Components wrappers](src/components/rokuComponents), their
[mock files](src/components/rokuComponents/_mocks) have been created. We recommend getting rid of these files when
building the app for the production environment.


## Developing Kopytko Utils

### Running Unit Tests
```shell
npm test -- --rokuIP=<rokuIP> --rokuDevPassword=<rokuDevPassword>
```
example: `npm test -- --rokuIP=192.168.3.2 --rokuDevPassword=rokudev`

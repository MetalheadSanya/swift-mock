# ``SwiftMock``

A package to simplify writing tests by automating the process of creating mock objects.

## Overview

This package provides a Mock macro that can be applied to a protocol to generate a new type. This type will have a name similar to the protocol name with the Mock suffix.

To work with an object of Mock type, the global ``when(_:)-2f4dp`` method is used. For each protocol method, 2 methods will be generated. One method will be similar to the protocol method, the second method will have a prefix in the form of the `$` symbol. When you call the ``when(_:)-2f4dp`` method you should use the method with a prefix.

The ``when(_:)-2f4dp`` method returns a ``MethodInvocationBuilder`` that allows you add the stub to Mock object for its methods. In most cases, you should call the builder's ``MethodInvocationBuilder/thenReturn(_:)-3grzk`` method and determine what value stub should return. If the method can throw errors, then you can use the ``ThrowsMethodInvocationBuilder/thenThrow(_:)`` method to test error handling.

The ``verify(_:times:)`` function is used to verify the call of your mocks. This method takes a mock as its first argument. A return value is a specialized structure that allows you to check that a method was called with certain arguments.

## Topics

### Installation

- <doc:Swift-Package-Manager>

### Usage

- <doc:Introduction>
- <doc:Stubbing>
- <doc:Argument-Matchers>
- <doc:Verifying>

### Basic

- ``when(_:)-2f4dp``
- ``when(_:)-1qrnt``
- ``when(_:)-1l8q0``
- ``when(_:)-35bf6``
- ``verify(_:times:)``

### Argument Mathers

- ``any()``
- ``eq(_:)``
- ``isNil()``
- ``isNotNil()``
- ``lessThan(_:)``
- ``moreThen(_:)``
- ``zip(_:_:)``
- ``&&(_:_:)-4du0s``
- ``||(_:_:)-6azss``
- ``zip(_:_:)``

### Times Matchers

- ``times(_:)``
- ``never()``
- ``atLeast(_:)``
- ``atLeastOnce()``
- ``atMost(_:)``
- ``&&(_:_:)-7m7ci``
- ``||(_:_:)-6kcwv``

### Internal Types for stubbing methods

- ``MethodInvocation``
- ``MethodInvocationBuilder``
- ``MethodSignature``

### Internal Types for stubbing async methods

- ``AsyncMethodInvocation``
- ``AsyncMethodInvocationBuilder``
- ``AsyncMethodSignature``

### Internal Types for stubbing throws methods

- ``ThrowsMethodInvocation``
- ``ThrowsMethodInvocationBuilder``
- ``ThrowsMethodSignature``

### Internal Types for stubbing async throws methods

- ``AsyncThrowsMethodInvocation``
- ``AsyncThrowsMethodInvocationBuilder``
- ``AsyncThrowsMethodSignature``

### Internal Types for verifying

- ``MethodCall``
- ``Verifiable``

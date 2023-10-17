# Greedy Algorithm

Greedy algorithm of verification ``InOrder``.

### Understanding 'greedy' algorithm

In ``SwiftMock`` verification ``inOrder(_:)`` mode is greedy. Example:

```swift
mock.foo()
mock.foo()
mock.bar()
```

```swift
// greedy algorithm (``SwiftMock`` way):
inOrder.verify(mock, times: times(2)).foo() // pass - I'm greedy - called 2 times, must be times(2)
inOrder.verify(mock, times: times(1)).bar() // pass

// non-greedy algorithm allows this:
inOrder.verify(mock, times: times(1)).foo(; // pass - I'm not greedy, one instance is enough
inOrder.verify(mock, times: times(1)).bar() // pass
```
Non-greedy algorithm seems more intuitive: when you read the verification if feels right: one instance of `foo()` was called before one instance `bar()`. However non-greedy algorithm is not consistent with standard verification in ``SwiftMock`` where `times(x)` is rigid. Also non-greedy may lead to:
* may lead contradicting assertion statements that pass (e.g. same verifications but with different `times(x)` pass)
* may lead inability to verify the exact number of invocations occasionally
* may lead to bugs

Hence our design choice was to go for 'greedy' algorithm when verifying in order.

### Theoretical example where non-greedy algorithm leads to bugs

```swift
// production code:
service.saveEntity()
service.commit()

// test:        
inOrder.verify(service, times: times(1)).saveEntity() // this has to happen *once*
inOrder.verify(service, times: times(1)).commit()
```

Later on the bug is introduced:

```swift
// production code:
service.saveEntity()
service.saveEntity() // <<-- dev introduces bug: saving the entity twice leads to memory corruption
service.commit()

// non-greedy algorithm does not detect the bug and the *test passes*
inOrder.verify(service, times: times(1)).saveEntity() // <<-- passes in non-greedy mode
inOrder.verify(service).commit()

// greedy algorithm *detects the bug*
inOrder.verify(service, times: times(1)).saveEntity() // <<-- fails in greedy mode
inOrder.verify(service).commit()
```

> Note: This example is theoretical. We didn't find a real use case in production code that would asses what is better: greedy or non-greedy algorithm. This seems to be a truly edge case. Decent, KISSy, refactored code should be easy to test without acrobatics.

### More complex examples

Using ``atLeast(_:)`` mode in order.

```swift
mock.add("A")
mock.add("A")
mock.add("B")
mock.add("A")
```

Explanation of *greedy* algorithm:

```swift
// fails:
inOrder.verify(mock, times: atLeast(2)).add(eq("A"))
inOrder.verify(mock, times: atLeast(1)).add(eq("B"))

// passes:
inOrder.verify(mock, times: times(2)).add(eq("A"))
inOrder.verify(mock, times: atLeast(1)).add(rq("B"))

// atLeast(x) may not fit the greedy paradigm but again...
// the API should be consistent
```

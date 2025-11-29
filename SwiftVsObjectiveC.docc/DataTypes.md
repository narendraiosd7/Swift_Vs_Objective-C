# Data Types

Comparing data type systems between Swift and Objective-C.

## Overview

Swift provides a unified type system where everything is an object, while Objective-C distinguishes between primitive types and object types. This difference has significant implications for safety, performance, and code clarity.

## Type System Philosophy

### Swift: Unified Type System
- All types are first-class objects
- Value types (structs) and reference types (classes)
- Strong type safety with compile-time checking

### Objective-C: Dual Type System
- Primitive types: `int`, `float`, `double`, `BOOL`
- Object types: `NSString`, `NSNumber`, `NSArray`
- Runtime type checking

## Basic Type Comparisons

| Swift | Objective-C | Description |
|-------|-------------|-------------|
| `Int` | `int` / `NSInteger` | Integer numbers |
| `Float` | `float` / `CGFloat` | Floating-point numbers |
| `Double` | `double` | Double-precision floats |
| `Bool` | `BOOL` | Boolean values |
| `String` | `NSString` | Text strings |

## Boolean Values

### Swift
```swift
let isSwiftBetter: Bool = true
let isComplete: Bool = false
```

### Objective-C
```objective-c
BOOL isSwiftBetter = YES;
BOOL isComplete = NO;
```

**Key Difference**: Swift uses `true`/`false`, while Objective-C uses `YES`/`NO`.

## String Handling

### Swift: Native String Type
```swift
let name = "Swift"  // Type inferred as String
let message = "Hello, \(name)!"  // String interpolation
```

### Objective-C: NSString Objects
```objective-c
NSString *name = @"Objective-C";
NSString *message = [NSString stringWithFormat:@"Hello, %@!", name];
```

## Number Types

### Swift: Value Types
```swift
let age: Int = 25
let temperature: Double = 98.6
let progress: Float = 0.75
```

### Objective-C: Primitives vs Objects
```objective-c
// Primitives
int age = 25;
double temperature = 98.6;
float progress = 0.75f;

// Object wrappers (for collections)
NSNumber *ageObject = @25;
NSNumber *tempObject = @98.6;
```

## Type Safety Benefits

Swift's type system prevents common errors:

1. **No Implicit Conversions**: Must explicitly convert between types
2. **Null Safety**: Optionals prevent null pointer exceptions
3. **Compile-Time Checking**: Catches type mismatches early
4. **Value Semantics**: Structs provide predictable copying behavior

## Performance Implications

- **Swift**: Value types can be stack-allocated for better performance
- **Objective-C**: Object creation requires heap allocation
- **Swift**: Compiler optimizations eliminate boxing/unboxing overhead
- **Objective-C**: Runtime boxing/unboxing for collections

## Migration Tips

When converting Objective-C types to Swift:

1. Replace `NSString *` with `String`
2. Use `Int`, `Double`, `Float` instead of primitives
3. Embrace Swift's type inference
4. Consider value types (structs) for data containers
5. Use optionals (`String?`) for nullable values

The unified type system in Swift eliminates the complexity of managing both primitive and object types, leading to cleaner, safer code.
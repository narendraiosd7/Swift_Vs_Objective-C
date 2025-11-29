# Variables and Constants

Understanding variable declaration and mutability in Swift vs Objective-C.

## Overview

Swift makes the distinction between mutable and immutable data explicit through the `let` and `var` keywords. This design choice promotes safer coding practices by making the developer's intent clear and preventing accidental modifications.

## Declaration Syntax

### Swift: Explicit Mutability
```swift
let constantValue = "Cannot change this"  // Immutable
var mutableValue = "Can change this"      // Mutable

// Type annotation (optional due to inference)
let explicitConstant: String = "Typed constant"
var explicitVariable: Int = 42
```

### Objective-C: All References Mutable
```objective-c
// All pointer variables are mutable references
NSString *constant = @"Can actually reassign this";
NSString *variable = @"Same mutability as above";

// To make content immutable, you need different approach
NSString *immutableString = @"Content can't change";
NSMutableString *mutableString = [NSMutableString stringWithString:@"Content can change"];
```

## Mutability Philosophy

### Swift Approach
- **Reference Mutability**: `let` vs `var` controls whether you can reassign the variable
- **Value Mutability**: Depends on the type (`String` vs custom mutable types)
- **Clear Intent**: Code readers immediately understand what can change

### Objective-C Approach
- **Reference Mutability**: All pointers are reassignable by default
- **Value Mutability**: Controlled by class hierarchy (`NSString` vs `NSMutableString`)
- **Runtime Distinction**: Mutability often determined at runtime

## Type Inference

### Swift: Powerful Type Inference
```swift
let inferredString = "Hello"        // String
let inferredInt = 42                // Int
let inferredDouble = 3.14           // Double
let inferredArray = [1, 2, 3]       // [Int]
let inferredDict = ["key": "value"] // [String: String]
```

### Objective-C: Explicit Types Required
```objective-c
NSString *string = @"Hello";
NSInteger integer = 42;
double doubleValue = 3.14;
NSArray *array = @[@1, @2, @3];
NSDictionary *dict = @{@"key": @"value"};
```

## String Interpolation

### Swift: Built-in Interpolation
```swift
let name = "Alice"
let age = 30
let message = "Hello, \(name)! You are \(age) years old."
```

### Objective-C: Format Strings
```objective-c
NSString *name = @"Alice";
NSInteger age = 30;
NSString *message = [NSString stringWithFormat:@"Hello, %@! You are %ld years old.", name, (long)age];
```

## Compilation Benefits

Swift's approach provides several advantages:

1. **Compile-Time Safety**: Immutable variables prevent accidental modification
2. **Performance Optimization**: Compiler can optimize based on mutability
3. **Code Documentation**: Intent is clear from declaration
4. **Reduced Bugs**: Fewer runtime errors from unexpected mutations

## Common Patterns

### Swift Constants for Configuration
```swift
let apiBaseURL = "https://api.example.com"
let maxRetryCount = 3
let timeout: TimeInterval = 30.0

// These values cannot be accidentally changed
```

### Swift Variables for State
```swift
var currentUser: User?
var isLoading = false
var errorMessage: String?

// These values are expected to change during execution
```

## Memory Implications

- **Swift `let`**: May enable copy-on-write optimizations
- **Swift `var`**: Standard reference counting applies
- **Objective-C**: All object references use same memory management

## Best Practices

### Swift Recommendations
1. **Prefer `let` by default**: Use `var` only when mutation is needed
2. **Make intent clear**: Use descriptive variable names
3. **Leverage inference**: Let compiler infer types when obvious
4. **Group declarations**: Organize related constants and variables

### Migration from Objective-C
1. **Identify immutable data**: Convert to `let` declarations
2. **Use type inference**: Remove obvious type annotations
3. **Adopt string interpolation**: Replace format strings with interpolation
4. **Review mutability needs**: Question whether variables really need to change

The explicit mutability system in Swift leads to safer, more predictable code by making the developer's intentions clear both to the compiler and to other developers reading the code.
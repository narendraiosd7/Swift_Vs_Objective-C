# Basic Syntax Differences

Understanding the fundamental syntax differences between Swift and Objective-C.

## Overview

The most noticeable difference when comparing Swift and Objective-C is the syntax. Swift was designed to be more readable and concise, while Objective-C follows C-style conventions with additional Objective-C messaging syntax.

## Hello World Comparison

### Swift Approach
```swift
let greeting = "Hello from Swift!"
print(greeting)
```

### Objective-C Approach
```objective-c
NSString *greeting = @"Hello from Objective-C!";
NSLog(@"%@", greeting);
```

## Key Syntax Differences

### Semicolons
- **Swift**: Optional semicolons (rarely used)
- **Objective-C**: Required semicolons at end of statements

### String Literals
- **Swift**: Direct string literals: `"Hello"`
- **Objective-C**: Prefixed with @: `@"Hello"`

### Variable Declaration
- **Swift**: `let` for constants, `var` for variables
- **Objective-C**: Type followed by variable name

### Type Inference
- **Swift**: Compiler infers types when possible
- **Objective-C**: Explicit type declarations required

## Readability Benefits

Swift's syntax improvements include:

1. **Less Boilerplate**: Fewer required symbols and keywords
2. **Clear Intent**: `let` vs `var` shows mutability intent
3. **Natural Language**: Method calls read like English sentences
4. **Type Safety**: Compiler catches more errors at build time

## Migration Considerations

When moving from Objective-C to Swift:

- Remove unnecessary semicolons
- Replace `NSString *` with `String`
- Use `let` for immutable values
- Take advantage of type inference
- Embrace Swift's more natural method naming conventions

The syntax differences reflect Swift's goal of being both powerful and approachable, making code easier to write, read, and maintain.
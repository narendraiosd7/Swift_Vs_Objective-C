# Functions and Methods

Comparing function and method syntax, capabilities, and patterns between Swift and Objective-C.

## Overview

Swift treats functions as first-class citizens, offering cleaner syntax, default parameters, and functional programming capabilities. While Objective-C methods are powerful, Swift functions provide more flexibility and expressiveness.

## Basic Function Syntax

### Swift: Clean and Readable
```swift
// Simple function
func greet(name: String) -> String {
    return "Hello, \(name)!"
}

// Function with multiple parameters
func calculateArea(width: Double, height: Double) -> Double {
    return width * height
}

// Function with default parameters
func greet(name: String = "World", enthusiastic: Bool = false) -> String {
    let greeting = "Hello, \(name)"
    return enthusiastic ? greeting + "!" : greeting
}

// Calling functions
let message1 = greet(name: "Alice")
let message2 = greet()                    // Uses defaults
let message3 = greet(enthusiastic: true)  // Partial defaults
let area = calculateArea(width: 10, height: 20)
```

### Objective-C: Verbose Method Declarations
```objective-c
// Method declaration in header (.h)
- (NSString *)greetWithName:(NSString *)name;
- (double)calculateAreaWithWidth:(double)width height:(double)height;

// Method implementation (.m)
- (NSString *)greetWithName:(NSString *)name {
    return [NSString stringWithFormat:@"Hello, %@!", name];
}

- (double)calculateAreaWithWidth:(double)width height:(double)height {
    return width * height;
}

// Calling methods
NSString *message = [self greetWithName:@"Alice"];
double area = [self calculateAreaWithWidth:10 height:20];

// No default parameters - need separate methods
- (NSString *)greet {
    return [self greetWithName:@"World"];
}
```

## Parameter Labels

### Swift: Flexible Parameter Naming
```swift
// External and internal parameter names
func move(from startPoint: CGPoint, to endPoint: CGPoint) -> Double {
    let dx = endPoint.x - startPoint.x
    let dy = endPoint.y - startPoint.y
    return sqrt(dx * dx + dy * dy)
}

// Calling with clear intent
let distance = move(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 3, y: 4))

// Omitting external names with underscore
func calculate(_ a: Int, _ b: Int) -> Int {
    return a + b
}

let sum = calculate(5, 10)  // No external labels
```

### Objective-C: Descriptive Method Names
```objective-c
// Self-documenting method names
- (double)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint {
    double dx = endPoint.x - startPoint.x;
    double dy = endPoint.y - startPoint.y;
    return sqrt(dx * dx + dy * dy);
}

// Calling methods reads like English
double distance = [self moveFromPoint:CGPointMake(0, 0) 
                              toPoint:CGPointMake(3, 4)];
```

## Return Values and Multiple Returns

### Swift: Tuples and Multiple Returns
```swift
// Multiple return values using tuples
func parseFullName(_ fullName: String) -> (firstName: String, lastName: String) {
    let components = fullName.split(separator: " ")
    let first = String(components.first ?? "")
    let last = String(components.last ?? "")
    return (firstName: first, lastName: last)
}

// Using tuple return
let name = parseFullName("John Smith")
print("First: \(name.firstName), Last: \(name.lastName)")

// Destructuring
let (first, last) = parseFullName("Jane Doe")

// Optional returns
func findUser(id: Int) -> User? {
    // Return User or nil
    return users.first { $0.id == id }
}
```

### Objective-C: Single Returns or Out Parameters
```objective-c
// Single return value
- (NSString *)firstNameFromFullName:(NSString *)fullName {
    NSArray *components = [fullName componentsSeparatedByString:@" "];
    return [components firstObject];
}

// Multiple values via out parameters
- (BOOL)parseFullName:(NSString *)fullName 
            firstName:(NSString **)firstName 
             lastName:(NSString **)lastName {
    NSArray *components = [fullName componentsSeparatedByString:@" "];
    if ([components count] >= 2) {
        *firstName = components[0];
        *lastName = [components lastObject];
        return YES;
    }
    return NO;
}

// Using out parameters
NSString *first, *last;
BOOL success = [self parseFullName:@"John Smith" 
                         firstName:&first 
                          lastName:&last];
```

## Function Types and First-Class Functions

### Swift: Functions as Values
```swift
// Function types
typealias MathOperation = (Int, Int) -> Int

// Functions as variables
let add: MathOperation = { (a, b) in return a + b }
let multiply: MathOperation = { $0 * $1 }  // Shorthand

// Functions as parameters
func performOperation(_ a: Int, _ b: Int, operation: MathOperation) -> Int {
    return operation(a, b)
}

let result1 = performOperation(5, 3, operation: add)      // 8
let result2 = performOperation(5, 3, operation: multiply) // 15

// Functions as return values
func getOperation(type: String) -> MathOperation {
    switch type {
    case "add":
        return { $0 + $1 }
    case "multiply":
        return { $0 * $1 }
    default:
        return { _, _ in 0 }
    }
}

let operation = getOperation(type: "add")
let result = operation(10, 5)  // 15
```

### Objective-C: Blocks (Limited Function Support)
```objective-c
// Block type definitions
typedef NSInteger (^MathOperation)(NSInteger a, NSInteger b);

// Blocks as variables
MathOperation add = ^NSInteger(NSInteger a, NSInteger b) {
    return a + b;
};

// Shorter syntax
MathOperation multiply = ^(NSInteger a, NSInteger b) {
    return a * b;
};

// Methods accepting blocks
- (NSInteger)performOperationWithA:(NSInteger)a 
                                 b:(NSInteger)b 
                         operation:(MathOperation)operation {
    return operation(a, b);
}

NSInteger result = [self performOperationWithA:5 b:3 operation:add];
```

## Default Parameters and Overloading

### Swift: Default Parameters
```swift
// Single function with defaults
func connectToServer(host: String = "localhost", 
                    port: Int = 8080, 
                    timeout: TimeInterval = 30.0,
                    secure: Bool = false) {
    print("Connecting to \(host):\(port)")
}

// Multiple calling styles
connectToServer()                           // All defaults
connectToServer(host: "example.com")        // Custom host
connectToServer(port: 443, secure: true)    // Custom port and security
```

### Objective-C: Method Overloading
```objective-c
// Multiple methods for different parameter combinations
- (void)connectToServer {
    [self connectToServerWithHost:@"localhost"];
}

- (void)connectToServerWithHost:(NSString *)host {
    [self connectToServerWithHost:host port:8080];
}

- (void)connectToServerWithHost:(NSString *)host port:(NSInteger)port {
    [self connectToServerWithHost:host port:port timeout:30.0];
}

- (void)connectToServerWithHost:(NSString *)host 
                           port:(NSInteger)port 
                        timeout:(NSTimeInterval)timeout {
    NSLog(@"Connecting to %@:%ld", host, (long)port);
}
```

## Variadic Parameters

### Swift: Type-Safe Variadic Functions
```swift
// Variadic parameters
func sum(_ numbers: Int...) -> Int {
    return numbers.reduce(0, +)
}

func printItems(_ items: String...) {
    for item in items {
        print("- \(item)")
    }
}

// Usage
let total = sum(1, 2, 3, 4, 5)      // 15
printItems("Apple", "Banana", "Cherry")
```

### Objective-C: Manual Variadic Handling
```objective-c
// Variadic methods (more complex)
- (NSInteger)sumNumbers:(NSNumber *)firstNumber, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, firstNumber);
    
    NSInteger total = [firstNumber integerValue];
    NSNumber *number;
    
    while ((number = va_arg(args, NSNumber *))) {
        total += [number integerValue];
    }
    
    va_end(args);
    return total;
}

// Usage (must be nil-terminated)
NSInteger total = [self sumNumbers:@1, @2, @3, @4, @5, nil];
```

## Method Chaining and Fluent APIs

### Swift: Natural Method Chaining
```swift
class StringBuilder {
    private var content = ""
    
    @discardableResult
    func append(_ text: String) -> StringBuilder {
        content += text
        return self
    }
    
    @discardableResult
    func appendLine(_ text: String = "") -> StringBuilder {
        content += text + "\n"
        return self
    }
    
    func build() -> String {
        return content
    }
}

// Fluent API usage
let result = StringBuilder()
    .append("Hello ")
    .append("World")
    .appendLine("!")
    .append("How are you?")
    .build()
```

### Objective-C: Manual Fluent APIs
```objective-c
@interface StringBuilder : NSObject
- (instancetype)append:(NSString *)text;
- (instancetype)appendLine:(NSString *)text;
- (NSString *)build;
@end

@implementation StringBuilder {
    NSMutableString *_content;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _content = [NSMutableString string];
    }
    return self;
}

- (instancetype)append:(NSString *)text {
    [_content appendString:text];
    return self;
}

- (instancetype)appendLine:(NSString *)text {
    [_content appendString:text];
    [_content appendString:@"\n"];
    return self;
}

- (NSString *)build {
    return [_content copy];
}
@end

// Usage
NSString *result = [[[[[StringBuilder alloc] init]
                      append:@"Hello "]
                     append:@"World"]
                    appendLine:@"!"]
                   build];
```

## Key Advantages

### Swift Function Benefits
1. **First-Class Functions**: Can be stored, passed, and returned
2. **Default Parameters**: Reduce method overloading
3. **Tuple Returns**: Multiple values without out parameters
4. **Parameter Labels**: Clear, self-documenting calls
5. **Type Inference**: Less verbose type annotations
6. **Functional Programming**: Higher-order functions support

### When to Use Each Approach
- **Swift Functions**: For new code, functional programming, and utility functions
- **Objective-C Methods**: For existing codebases and when interoperating with C libraries

The function system in Swift provides significant improvements in expressiveness, safety, and functionality while maintaining the clarity and self-documentation that makes Objective-C method calls readable.
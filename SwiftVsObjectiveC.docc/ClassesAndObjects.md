# Classes and Objects

Comparing object-oriented programming approaches in Swift and Objective-C.

## Overview

Both Swift and Objective-C support object-oriented programming, but Swift provides a cleaner syntax and additional safety features. Swift also introduces value types (structs) as an alternative to reference types (classes) for many use cases.

## Class Definition Syntax

### Swift: Single File Approach
```swift
class Person {
    let name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func introduce() -> String {
        return "Hi, I'm \(name) and I'm \(age) years old"
    }
    
    func haveBirthday() {
        age += 1
    }
}
```

### Objective-C: Header and Implementation Files
```objective-c
// Person.h (Header file)
@interface Person : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age;
- (NSString *)introduce;
- (void)haveBirthday;
@end

// Person.m (Implementation file)
@implementation Person

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age {
    self = [super init];
    if (self) {
        _name = name;
        _age = age;
    }
    return self;
}

- (NSString *)introduce {
    return [NSString stringWithFormat:@"Hi, I'm %@ and I'm %ld years old", 
            self.name, (long)self.age];
}

- (void)haveBirthday {
    self.age++;
}

@end
```

## Object Creation and Usage

### Swift
```swift
let person = Person(name: "Alice", age: 30)
print(person.introduce())
person.haveBirthday()
```

### Objective-C
```objective-c
Person *person = [[Person alloc] initWithName:@"Alice" age:30];
NSLog(@"%@", [person introduce]);
[person haveBirthday];
```

## Property Declaration

### Swift Properties
```swift
class BankAccount {
    let accountNumber: String           // Immutable property
    var balance: Double                 // Mutable property
    private var pin: String             // Private property
    
    // Computed property
    var formattedBalance: String {
        return String(format: "$.2f", balance)
    }
    
    // Property with observers
    var status: String = "Active" {
        didSet {
            print("Account status changed to: \(status)")
        }
    }
}
```

### Objective-C Properties
```objective-c
@interface BankAccount : NSObject
@property (nonatomic, strong, readonly) NSString *accountNumber;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong, readonly) NSString *formattedBalance;
@end

@implementation BankAccount {
    NSString *_pin;  // Private instance variable
}

- (NSString *)formattedBalance {
    return [NSString stringWithFormat:@"$%.2f", self.balance];
}

- (void)setStatus:(NSString *)status {
    _status = status;
    NSLog(@"Account status changed to: %@", status);
}
@end
```

## Initialization

### Swift Initializers
```swift
class Vehicle {
    let make: String
    let model: String
    var year: Int
    
    // Designated initializer
    init(make: String, model: String, year: Int) {
        self.make = make
        self.model = model
        self.year = year
    }
    
    // Convenience initializer
    convenience init(make: String, model: String) {
        self.init(make: make, model: model, year: 2023)
    }
}
```

### Objective-C Initializers
```objective-c
@implementation Vehicle

- (instancetype)initWithMake:(NSString *)make 
                       model:(NSString *)model 
                        year:(NSInteger)year {
    self = [super init];
    if (self) {
        _make = make;
        _model = model;
        _year = year;
    }
    return self;
}

- (instancetype)initWithMake:(NSString *)make model:(NSString *)model {
    return [self initWithMake:make model:model year:2023];
}

@end
```

## Key Differences

### File Organization
- **Swift**: Everything in one file - properties, methods, initializers
- **Objective-C**: Split between header (.h) and implementation (.m) files

### Property Syntax
- **Swift**: Simple, clean property declarations with explicit mutability
- **Objective-C**: Property attributes specify behavior (strong, weak, readonly, etc.)

### Initialization Safety
- **Swift**: Compiler ensures all properties are initialized
- **Objective-C**: Manual initialization patterns with potential for errors

### Method Naming
- **Swift**: Natural, function-like syntax
- **Objective-C**: Descriptive method names with parameter labels

### Access Control
- **Swift**: `private`, `fileprivate`, `internal`, `public`, `open`
- **Objective-C**: Public (header) vs private (implementation) dichotomy

## Swift Structs Alternative

Swift also offers structs as value types:

```swift
struct Point {
    var x: Double
    var y: Double
    
    func distanceFromOrigin() -> Double {
        return (x * x + y * y).squareRoot()
    }
    
    mutating func moveBy(deltaX: Double, deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var point = Point(x: 3.0, y: 4.0)
point.moveBy(deltaX: 1.0, deltaY: 1.0)  // Value semantics
```

## When to Use Each

### Choose Swift Classes When:
- You need reference semantics (shared instances)
- You're using inheritance
- You need deinitialization (`deinit`)
- Working with Objective-C interoperability

### Choose Swift Structs When:
- You want value semantics (copying behavior)
- Creating simple data containers
- You don't need inheritance
- Performance is critical for small data types

The object-oriented features in Swift provide the same power as Objective-C with improved safety, cleaner syntax, and additional options like value types for better performance and predictability.
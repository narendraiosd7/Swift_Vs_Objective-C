# Inheritance

Comparing inheritance patterns and capabilities between Swift and Objective-C.

## Overview

Both Swift and Objective-C support single inheritance from a base class, but Swift provides additional safety features like the `override` keyword, better initialization patterns, and more explicit control over inheritance behavior.

## Basic Inheritance

### Swift: Clean and Safe
```swift
// Base class
class Animal {
    let species: String
    var age: Int
    
    init(species: String, age: Int = 0) {
        self.species = species
        self.age = age
    }
    
    func makeSound() -> String {
        return "Some generic animal sound"
    }
    
    func describe() -> String {
        return "A \(age)-year-old \(species)"
    }
}

// Inherited class
class Dog: Animal {
    let breed: String
    
    init(breed: String, age: Int = 0) {
        self.breed = breed
        super.init(species: "Dog", age: age)
    }
    
    // Override with explicit keyword
    override func makeSound() -> String {
        return "Woof! Woof!"
    }
    
    // Add new functionality
    func wagTail() -> String {
        return "\(breed) is wagging its tail!"
    }
}

// Usage
let myDog = Dog(breed: "Golden Retriever", age: 3)
print(myDog.describe())      // "A 3-year-old Dog"
print(myDog.makeSound())     // "Woof! Woof!"
print(myDog.wagTail())       // "Golden Retriever is wagging its tail!"
```

### Objective-C: Manual Override Management
```objective-c
// Animal.h
@interface Animal : NSObject
@property (nonatomic, strong, readonly) NSString *species;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithSpecies:(NSString *)species age:(NSInteger)age;
- (NSString *)makeSound;
- (NSString *)describe;
@end

// Animal.m
@implementation Animal

- (instancetype)initWithSpecies:(NSString *)species age:(NSInteger)age {
    self = [super init];
    if (self) {
        _species = species;
        _age = age;
    }
    return self;
}

- (NSString *)makeSound {
    return @"Some generic animal sound";
}

- (NSString *)describe {
    return [NSString stringWithFormat:@"A %ld-year-old %@", 
            (long)self.age, self.species];
}

@end

// Dog.h
@interface Dog : Animal
@property (nonatomic, strong, readonly) NSString *breed;
- (instancetype)initWithBreed:(NSString *)breed age:(NSInteger)age;
- (NSString *)wagTail;
@end

// Dog.m
@implementation Dog

- (instancetype)initWithBreed:(NSString *)breed age:(NSInteger)age {
    self = [super initWithSpecies:@"Dog" age:age];
    if (self) {
        _breed = breed;
    }
    return self;
}

- (NSString *)makeSound {  // Override (no explicit keyword)
    return @"Woof! Woof!";
}

- (NSString *)wagTail {
    return [NSString stringWithFormat:@"%@ is wagging its tail!", self.breed];
}

@end
```

## Method Overriding Safety

### Swift: Compile-Time Override Checking
```swift
class Vehicle {
    let wheels: Int
    
    init(wheels: Int) {
        self.wheels = wheels
    }
    
    func start() -> String {
        return "Vehicle starting..."
    }
    
    final func getWheelCount() -> Int {  // Cannot be overridden
        return wheels
    }
}

class Car: Vehicle {
    let brand: String
    
    init(brand: String) {
        self.brand = brand
        super.init(wheels: 4)
    }
    
    override func start() -> String {     // Must use 'override'
        return "\(brand) engine starting..."
    }
    
    // This would cause compile error:
    // override func getWheelCount() -> Int { return 4 }  // Error: final method
    
    // This would cause compile error:
    // func start() -> String { return "..." }  // Error: missing 'override'
}
```

### Objective-C: Runtime Override Discovery
```objective-c
@interface Vehicle : NSObject
@property (nonatomic, assign, readonly) NSInteger wheels;
- (instancetype)initWithWheels:(NSInteger)wheels;
- (NSString *)start;
@end

@implementation Vehicle
- (instancetype)initWithWheels:(NSInteger)wheels {
    self = [super init];
    if (self) {
        _wheels = wheels;
    }
    return self;
}

- (NSString *)start {
    return @"Vehicle starting...";
}
@end

@interface Car : Vehicle
@property (nonatomic, strong, readonly) NSString *brand;
- (instancetype)initWithBrand:(NSString *)brand;
@end

@implementation Car
- (instancetype)initWithBrand:(NSString *)brand {
    self = [super initWithWheels:4];
    if (self) {
        _brand = brand;
    }
    return self;
}

- (NSString *)start {  // Override (no compile-time checking)
    return [NSString stringWithFormat:@"%@ engine starting...", self.brand];
}
@end
```

## Abstract Classes and Methods

### Swift: Protocol-Oriented Approach
```swift
// Swift doesn't have abstract classes, but uses protocols
protocol Drawable {
    func draw() -> String
    var area: Double { get }
}

class Shape: Drawable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    // Must implement protocol requirements
    func draw() -> String {
        fatalError("Subclasses must override draw()")
    }
    
    var area: Double {
        fatalError("Subclasses must override area")
    }
}

class Circle: Shape {
    let radius: Double
    
    init(radius: Double) {
        self.radius = radius
        super.init(name: "Circle")
    }
    
    override func draw() -> String {
        return "Drawing a circle with radius \(radius)"
    }
    
    override var area: Double {
        return Double.pi * radius * radius
    }
}
```

### Objective-C: Manual Abstract Implementation
```objective-c
// Base "abstract" class
@interface Shape : NSObject
@property (nonatomic, strong, readonly) NSString *name;
- (instancetype)initWithName:(NSString *)name;
- (NSString *)draw;        // "Abstract" method
- (double)area;           // "Abstract" property
@end

@implementation Shape
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (NSString *)draw {
    [NSException raise:@"AbstractMethodException" 
                format:@"Subclasses must override draw method"];
    return nil;
}

- (double)area {
    [NSException raise:@"AbstractMethodException" 
                format:@"Subclasses must override area property"];
    return 0.0;
}
@end

@interface Circle : Shape
@property (nonatomic, assign, readonly) double radius;
- (instancetype)initWithRadius:(double)radius;
@end

@implementation Circle
- (instancetype)initWithRadius:(double)radius {
    self = [super initWithName:@"Circle"];
    if (self) {
        _radius = radius;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing a circle with radius %.2f", self.radius];
}

- (double)area {
    return M_PI * self.radius * self.radius;
}
@end
```

## Super Method Calls

### Swift: Clean Super Calls
```swift
class Employee {
    let name: String
    var salary: Double
    
    init(name: String, salary: Double) {
        self.name = name
        self.salary = salary
    }
    
    func work() -> String {
        return "\(name) is working"
    }
    
    func getDetails() -> String {
        return "Employee: \(name), Salary: $\(salary)"
    }
}

class Manager: Employee {
    let teamSize: Int
    
    init(name: String, salary: Double, teamSize: Int) {
        self.teamSize = teamSize
        super.init(name: name, salary: salary)
    }
    
    override func work() -> String {
        let baseWork = super.work()
        return "\(baseWork) and managing \(teamSize) people"
    }
    
    override func getDetails() -> String {
        let baseDetails = super.getDetails()
        return "\(baseDetails), Team Size: \(teamSize)"
    }
}

let manager = Manager(name: "Alice", salary: 80000, teamSize: 5)
print(manager.work())       // "Alice is working and managing 5 people"
print(manager.getDetails()) // "Employee: Alice, Salary: $80000.0, Team Size: 5"
```

### Objective-C: Similar Super Pattern
```objective-c
@interface Employee : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign) double salary;
- (instancetype)initWithName:(NSString *)name salary:(double)salary;
- (NSString *)work;
- (NSString *)getDetails;
@end

@implementation Employee
- (instancetype)initWithName:(NSString *)name salary:(double)salary {
    self = [super init];
    if (self) {
        _name = name;
        _salary = salary;
    }
    return self;
}

- (NSString *)work {
    return [NSString stringWithFormat:@"%@ is working", self.name];
}

- (NSString *)getDetails {
    return [NSString stringWithFormat:@"Employee: %@, Salary: $%.0f", 
            self.name, self.salary];
}
@end

@interface Manager : Employee
@property (nonatomic, assign, readonly) NSInteger teamSize;
- (instancetype)initWithName:(NSString *)name 
                      salary:(double)salary 
                    teamSize:(NSInteger)teamSize;
@end

@implementation Manager
- (instancetype)initWithName:(NSString *)name 
                      salary:(double)salary 
                    teamSize:(NSInteger)teamSize {
    self = [super initWithName:name salary:salary];
    if (self) {
        _teamSize = teamSize;
    }
    return self;
}

- (NSString *)work {
    NSString *baseWork = [super work];
    return [NSString stringWithFormat:@"%@ and managing %ld people", 
            baseWork, (long)self.teamSize];
}

- (NSString *)getDetails {
    NSString *baseDetails = [super getDetails];
    return [NSString stringWithFormat:@"%@, Team Size: %ld", 
            baseDetails, (long)self.teamSize];
}
@end
```

## Preventing Inheritance

### Swift: Final Classes and Methods
```swift
final class Utility {  // Cannot be subclassed
    static func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }
}

class Config {
    var setting: String = "default"
    
    final func validate() -> Bool {  // Cannot be overridden
        return !setting.isEmpty
    }
    
    func process() -> String {  // Can be overridden
        return "Processing \(setting)"
    }
}

// This would cause compile error:
// class ExtendedUtility: Utility { }  // Error: final class

// class ExtendedConfig: Config {
//     override func validate() -> Bool { return true }  // Error: final method
// }
```

### Objective-C: Limited Prevention
```objective-c
// No built-in final keyword, but can discourage inheritance
@interface Utility : NSObject
+ (NSString *)formatCurrency:(double)amount;
@end

// Document as "not intended for subclassing"
// Runtime checking possible but not common
```

## Key Inheritance Differences

| Feature | Swift | Objective-C |
|---------|-------|-------------|
| **Override Safety** | `override` keyword required | No compile-time checking |
| **Final Methods** | `final` keyword prevents override | No built-in mechanism |
| **Abstract Classes** | Use protocols instead | Manual exception throwing |
| **Initialization** | Strict initialization rules | Manual super calls |
| **Type Safety** | Strong compile-time checking | Runtime type checking |

## Best Practices

### Swift Inheritance Guidelines
1. **Use `override` keyword**: Always explicit about method overriding
2. **Consider `final`**: Prevent unnecessary inheritance 
3. **Favor composition**: Use protocols and composition over inheritance
4. **Initialize carefully**: Follow Swift's initialization rules
5. **Call super**: Remember to call super methods when extending behavior

### Migration Considerations
- Add `override` keywords when converting Objective-C subclasses
- Consider using protocols instead of abstract base classes
- Use `final` to prevent unwanted inheritance
- Take advantage of Swift's compile-time override checking

Swift's inheritance system maintains the power of Objective-C inheritance while adding important safety features that prevent common errors and make code more maintainable.
# Protocols

Comparing protocol and interface patterns between Swift and Objective-C.

## Overview

Protocols define contracts that classes, structs, and enums can adopt. Swift's protocol system is more powerful than Objective-C's, offering protocol extensions, associated types, and better integration with value types.

## Basic Protocol Definition

### Swift: Flexible Protocol System
```swift
// Basic protocol
protocol Drawable {
    func draw() -> String
    var area: Double { get }
    var color: String { get set }
}

// Protocol with optional methods (using extensions)
protocol Configurable {
    func configure()
}

extension Configurable {
    func configure() {
        // Default implementation
        print("Using default configuration")
    }
}

// Implementing protocols
class Circle: Drawable, Configurable {
    var radius: Double
    var color: String
    
    init(radius: Double, color: String) {
        self.radius = radius
        self.color = color
    }
    
    func draw() -> String {
        return "Drawing a \(color) circle with area \(area)"
    }
    
    var area: Double {
        return Double.pi * radius * radius
    }
    
    // configure() inherited from extension
}

// Structs can also adopt protocols
struct Rectangle: Drawable {
    var width: Double
    var height: Double
    var color: String
    
    func draw() -> String {
        return "Drawing a \(color) rectangle"
    }
    
    var area: Double {
        return width * height
    }
}
```

### Objective-C: Class-Based Protocol System
```objective-c
// Protocol definition
@protocol Drawable <NSObject>
@required
- (NSString *)draw;
- (double)area;

@optional
- (void)configure;
@end

@protocol Configurable <NSObject>
@optional
- (void)configure;
@end

// Class adopting protocols
@interface Circle : NSObject <Drawable, Configurable>
@property (nonatomic, assign) double radius;
@property (nonatomic, strong) NSString *color;
- (instancetype)initWithRadius:(double)radius color:(NSString *)color;
@end

@implementation Circle

- (instancetype)initWithRadius:(double)radius color:(NSString *)color {
    self = [super init];
    if (self) {
        _radius = radius;
        _color = color;
    }
    return self;
}

- (NSString *)draw {
    return [NSString stringWithFormat:@"Drawing a %@ circle with area %.2f", 
            self.color, [self area]];
}

- (double)area {
    return M_PI * self.radius * self.radius;
}

- (void)configure {
    NSLog(@"Configuring circle");
}

@end
```

## Protocol Extensions (Swift Exclusive)

### Swift: Default Implementations and Extensions
```swift
protocol Identifiable {
    var id: String { get }
}

protocol Trackable: Identifiable {
    var lastModified: Date { get set }
    func track(event: String)
}

// Protocol extension with default implementations
extension Trackable {
    func track(event: String) {
        print("[\(Date())] \(id): \(event)")
        lastModified = Date()
    }
    
    func getTrackingInfo() -> String {
        return "ID: \(id), Last Modified: \(lastModified)"
    }
}

// Usage - automatic implementation
struct Document: Trackable {
    let id: String
    var lastModified: Date = Date()
    let content: String
}

let doc = Document(id: "DOC001", content: "Important document")
doc.track(event: "Document created")  // Uses default implementation
print(doc.getTrackingInfo())          // Uses extension method
```

### Objective-C: Manual Implementation Required
```objective-c
@protocol Identifiable <NSObject>
@property (nonatomic, strong, readonly) NSString *identifier;
@end

@protocol Trackable <Identifiable>
@property (nonatomic, strong) NSDate *lastModified;
@required
- (void)trackEvent:(NSString *)event;
@optional
- (NSString *)getTrackingInfo;
@end

// Each class must implement all methods manually
@interface Document : NSObject <Trackable>
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong) NSDate *lastModified;
@property (nonatomic, strong, readonly) NSString *content;
@end

@implementation Document
- (void)trackEvent:(NSString *)event {
    NSLog(@"[%@] %@: %@", [NSDate date], self.identifier, event);
    self.lastModified = [NSDate date];
}

- (NSString *)getTrackingInfo {
    return [NSString stringWithFormat:@"ID: %@, Last Modified: %@", 
            self.identifier, self.lastModified];
}
@end
```

## Associated Types (Advanced Swift Feature)

### Swift: Generic Protocols
```swift
protocol Collection {
    associatedtype Element
    associatedtype Index
    
    subscript(position: Index) -> Element { get }
    var startIndex: Index { get }
    var endIndex: Index { get }
}

// Implementation with concrete types
struct IntArray: Collection {
    typealias Element = Int
    typealias Index = Int
    
    private var elements: [Int]
    
    init(_ elements: [Int]) {
        self.elements = elements
    }
    
    subscript(position: Int) -> Int {
        return elements[position]
    }
    
    var startIndex: Int { return 0 }
    var endIndex: Int { return elements.count }
}

// Generic function using protocol
func printFirst<C: Collection>(_ collection: C) where C.Element == Int {
    if collection.startIndex < collection.endIndex {
        let first = collection[collection.startIndex]
        print("First element: \(first)")
    }
}

let intArray = IntArray([1, 2, 3, 4, 5])
printFirst(intArray)  // "First element: 1"
```

### Objective-C: Limited Generic Support
```objective-c
// Objective-C protocols can't have associated types
// Must use id or specific types
@protocol Collection <NSObject>
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)startIndex;
- (NSUInteger)endIndex;
@end

// Implementation must handle type safety manually
@interface IntArray : NSObject <Collection>
- (instancetype)initWithInts:(NSArray<NSNumber *> *)ints;
@end

@implementation IntArray {
    NSArray<NSNumber *> *_elements;
}

- (instancetype)initWithInts:(NSArray<NSNumber *> *)ints {
    self = [super init];
    if (self) {
        _elements = [ints copy];
    }
    return self;
}

- (id)objectAtIndex:(NSUInteger)index {
    return _elements[index];
}

- (NSUInteger)startIndex { return 0; }
- (NSUInteger)endIndex { return [_elements count]; }

@end
```

## Protocol Inheritance

### Swift: Protocol Composition and Inheritance
```swift
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

// Protocol inheritance
protocol Person: Named, Aged {
    func greet() -> String
}

// Protocol composition
typealias NamedAndAged = Named & Aged

// Functions accepting protocol compositions
func describe(_ entity: Named & Aged) -> String {
    return "\(entity.name) is \(entity.age) years old"
}

struct Employee: Person {
    let name: String
    let age: Int
    let department: String
    
    func greet() -> String {
        return "Hello, I'm \(name) from \(department)"
    }
}

let emp = Employee(name: "Alice", age: 30, department: "Engineering")
print(describe(emp))  // "Alice is 30 years old"
print(emp.greet())    // "Hello, I'm Alice from Engineering"
```

### Objective-C: Protocol Inheritance
```objective-c
@protocol Named <NSObject>
@property (nonatomic, strong, readonly) NSString *name;
@end

@protocol Aged <NSObject>
@property (nonatomic, assign, readonly) NSInteger age;
@end

@protocol Person <Named, Aged>
- (NSString *)greet;
@end

// Function accepting multiple protocols
void describe(id<Named, Aged> entity) {
    NSLog(@"%@ is %ld years old", entity.name, (long)entity.age);
}

@interface Employee : NSObject <Person>
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger age;
@property (nonatomic, strong, readonly) NSString *department;
@end

@implementation Employee
- (NSString *)greet {
    return [NSString stringWithFormat:@"Hello, I'm %@ from %@", 
            self.name, self.department];
}
@end
```

## Protocol as Types

### Swift: First-Class Protocol Types
```swift
protocol Vehicle {
    var speed: Double { get set }
    func start()
    func stop()
}

class Car: Vehicle {
    var speed: Double = 0
    let brand: String
    
    init(brand: String) {
        self.brand = brand
    }
    
    func start() {
        print("\(brand) car engine started")
        speed = 30
    }
    
    func stop() {
        print("\(brand) car stopped")
        speed = 0
    }
}

class Bicycle: Vehicle {
    var speed: Double = 0
    
    func start() {
        print("Started pedaling bicycle")
        speed = 15
    }
    
    func stop() {
        print("Stopped bicycle")
        speed = 0
    }
}

// Array of protocol types
let vehicles: [Vehicle] = [
    Car(brand: "Toyota"),
    Bicycle(),
    Car(brand: "Honda")
]

// Polymorphic behavior
for vehicle in vehicles {
    vehicle.start()
    print("Current speed: \(vehicle.speed)")
    vehicle.stop()
}
```

### Objective-C: Protocol Types with id
```objective-c
@protocol Vehicle <NSObject>
@property (nonatomic, assign) double speed;
- (void)start;
- (void)stop;
@end

@interface Car : NSObject <Vehicle>
@property (nonatomic, strong, readonly) NSString *brand;
@property (nonatomic, assign) double speed;
@end

@interface Bicycle : NSObject <Vehicle>
@property (nonatomic, assign) double speed;
@end

// Array of protocol types
NSArray<id<Vehicle>> *vehicles = @[
    [[Car alloc] initWithBrand:@"Toyota"],
    [[Bicycle alloc] init],
    [[Car alloc] initWithBrand:@"Honda"]
];

// Polymorphic behavior
for (id<Vehicle> vehicle in vehicles) {
    [vehicle start];
    NSLog(@"Current speed: %.1f", vehicle.speed);
    [vehicle stop];
}
```

## Key Protocol Advantages

### Swift Benefits
1. **Protocol Extensions**: Default implementations reduce code duplication
2. **Value Type Support**: Structs and enums can adopt protocols
3. **Associated Types**: Generic protocol capabilities
4. **Protocol Composition**: Combine multiple protocols with &
5. **Better Type Safety**: Compiler enforces protocol conformance

### When to Use Protocols

#### Choose Protocols When:
- Defining shared behavior across different types
- Creating testable interfaces (dependency injection)
- Building modular, loosely coupled systems
- Need multiple "inheritance" (composition)

#### Protocol vs Inheritance:
- **Protocols**: "Can do" relationships (Flyable, Drawable)
- **Inheritance**: "Is a" relationships (Dog is Animal)

Swift's protocol system provides a powerful foundation for protocol-oriented programming, enabling flexible designs that work well with both value types and reference types while maintaining type safety and performance.
# Generics

Understanding generic programming capabilities in Swift compared to Objective-C's limited generic support.

## Overview

Generics enable you to write flexible, reusable code that works with any type while maintaining type safety. Swift has a powerful generic system, while Objective-C has limited lightweight generics primarily for collections.

## Basic Generics

### Swift: Full Generic System
```swift
// Generic function
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

// Usage with different types
var x = 10, y = 20
swapValues(&x, &y)  // Works with Int
print("x: \(x), y: \(y)")  // x: 20, y: 10

var name1 = "Alice", name2 = "Bob" 
swapValues(&name1, &name2)  // Works with String
print("name1: \(name1), name2: \(name2)")  // name1: Bob, name2: Alice

// Generic class
class Box<T> {
    private var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func get() -> T {
        return value
    }
    
    func set(_ newValue: T) {
        value = newValue
    }
}

let intBox = Box(42)
print("Int box: \(intBox.get())")

let stringBox = Box("Hello Generics!")
print("String box: \(stringBox.get())")
```

### Objective-C: Limited Collection Generics
```objective-c
// Lightweight generics (mainly for collections)
@interface Box<ObjectType> : NSObject
- (instancetype)initWithValue:(ObjectType)value;
- (ObjectType)getValue;
- (void)setValue:(ObjectType)value;
@end

@implementation Box {
    id _value;  // Still uses id internally
}

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)getValue {
    return _value;
}

- (void)setValue:(id)value {
    _value = value;
}

@end

// Usage (type checking is mostly compile-time help)
Box<NSString *> *stringBox = [[Box alloc] initWithValue:@"Hello"];
Box<NSNumber *> *numberBox = [[Box alloc] initWithValue:@42];

// No generic functions in Objective-C
// Must use separate functions or runtime type checking
```

## Type Constraints

### Swift: Powerful Constraint System
```swift
// Protocol constraint
protocol Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool
}

func findLargest<T: Comparable>(_ items: [T]) -> T? {
    guard let first = items.first else { return nil }
    
    return items.reduce(first) { current, item in
        return item > current ? item : current
    }
}

let numbers = [3, 1, 4, 1, 5, 9, 2, 6]
if let largest = findLargest(numbers) {
    print("Largest number: \(largest)")  // 9
}

let words = ["apple", "zebra", "banana", "cherry"]
if let largest = findLargest(words) {
    print("Largest word: \(largest)")  // zebra
}

// Multiple constraints
func process<T>(_ items: [T]) where T: Hashable & CustomStringConvertible {
    let uniqueItems = Set(items)
    for item in uniqueItems {
        print("Processing: \(item.description)")
    }
}
```

### Objective-C: Runtime Type Checking
```objective-c
// No type constraints - must check at runtime
- (id)findLargestInArray:(NSArray *)items {
    if ([items count] == 0) return nil;
    
    id largest = [items firstObject];
    for (id item in items) {
        // Runtime type checking required
        if ([item respondsToSelector:@selector(compare:)]) {
            if ([item compare:largest] == NSOrderedDescending) {
                largest = item;
            }
        }
    }
    return largest;
}

NSArray<NSNumber *> *numbers = @[@3, @1, @4, @1, @5, @9];
NSNumber *largest = [self findLargestInArray:numbers];
```

## Associated Types

### Swift: Protocol Associated Types
```swift
protocol Container {
    associatedtype Item
    
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    mutating func append(_ item: Item)
}

struct IntStack: Container {
    // Swift infers that Item = Int
    private var items: [Int] = []
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
    
    mutating func append(_ item: Int) {
        items.append(item)
    }
}

struct StringStack: Container {
    typealias Item = String  // Explicit type alias
    
    private var items: [String] = []
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> String {
        return items[i]
    }
    
    mutating func append(_ item: String) {
        items.append(item)
    }
}

// Generic function using associated types
func printContainer<C: Container>(_ container: C) where C.Item: CustomStringConvertible {
    for i in 0..<container.count {
        print("Item \(i): \(container[i])")
    }
}
```

### Objective-C: No Associated Types
```objective-c
// Must use inheritance or categories for similar functionality
@protocol Container <NSObject>
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)appendObject:(id)object;
@end

@interface IntStack : NSObject <Container>
@end

@implementation IntStack {
    NSMutableArray<NSNumber *> *_items;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)count {
    return [_items count];
}

- (id)objectAtIndex:(NSUInteger)index {
    return _items[index];
}

- (void)appendObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]]) {
        [_items addObject:object];
    }
}

@end
```

## Generic Structures and Enums

### Swift: Comprehensive Generic Support
```swift
// Generic enum
enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

// Generic struct
struct Pair<T, U> {
    let first: T
    let second: U
    
    func map<V, W>(_ transform: (T, U) -> (V, W)) -> Pair<V, W> {
        let (newFirst, newSecond) = transform(first, second)
        return Pair<V, W>(first: newFirst, second: newSecond)
    }
}

// Usage
let stringIntPair = Pair(first: "Hello", second: 42)
let doubleStringPair = stringIntPair.map { text, number in
    (Double(number), text.uppercased())
}

print(doubleStringPair)  // Pair<Double, String>(first: 42.0, second: "HELLO")

// Generic networking example
struct APIResponse<T: Codable> {
    let data: T
    let statusCode: Int
    let timestamp: Date
}

func fetchData<T: Codable>(_ type: T.Type) async -> Result<APIResponse<T>, Error> {
    // Implementation would make network request
    // and decode to specified type
    fatalError("Implementation needed")
}
```

### Objective-C: Limited Enum/Struct Support
```objective-c
// Objective-C enums cannot be generic
typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeSuccess,
    ResultTypeFailure
};

@interface Result : NSObject
@property (nonatomic, assign, readonly) ResultType type;
@property (nonatomic, strong, readonly) id value;
@property (nonatomic, strong, readonly) NSError *error;
+ (instancetype)successWithValue:(id)value;
+ (instancetype)failureWithError:(NSError *)error;
@end

// No generic structs - must use classes with type erasure
@interface Pair : NSObject
@property (nonatomic, strong, readonly) id first;
@property (nonatomic, strong, readonly) id second;
- (instancetype)initWithFirst:(id)first second:(id)second;
@end
```

## Where Clauses and Complex Constraints

### Swift: Advanced Generic Constraints
```swift
// Complex where clauses
func compareArrays<T, U>(_ array1: [T], _ array2: [U]) -> Bool 
where T: Equatable, U: Equatable, T == U {
    guard array1.count == array2.count else { return false }
    
    for i in 0..<array1.count {
        if array1[i] != array2[i] {
            return false
        }
    }
    return true
}

// Extension with generic constraints
extension Array where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
    
    func average() -> Double {
        let total = sum()
        return Double(String(describing: total)) ?? 0 / Double(count)
    }
}

let numbers = [1, 2, 3, 4, 5]
print("Sum: \(numbers.sum())")        // Sum: 15

let doubles = [1.5, 2.5, 3.5]
print("Sum: \(doubles.sum())")        // Sum: 7.5

// Protocol with Self requirements
protocol Copyable {
    func copy() -> Self
}

extension String: Copyable {
    func copy() -> String {
        return String(self)
    }
}
```

### Objective-C: No Where Clauses
```objective-c
// Must implement constraints manually at runtime
@interface NSArray (NumericOperations)
- (NSNumber *)sum;  // Only works if array contains NSNumber objects
- (NSNumber *)average;
@end

@implementation NSArray (NumericOperations)
- (NSNumber *)sum {
    double total = 0;
    for (id object in self) {
        if ([object isKindOfClass:[NSNumber class]]) {
            total += [(NSNumber *)object doubleValue];
        }
    }
    return @(total);
}

- (NSNumber *)average {
    NSNumber *sum = [self sum];
    return @([sum doubleValue] / [self count]);
}
@end
```

## Performance Benefits

### Swift Generic Optimization
```swift
// Swift generics are compiled to specialized versions
// No boxing/unboxing overhead for value types
struct Stack<Element> {
    private var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)  // No boxing for value types
    }
    
    mutating func pop() -> Element? {
        return items.popLast()
    }
}

// Compiler generates specialized versions:
// Stack<Int>, Stack<String>, etc.
var intStack = Stack<Int>()
intStack.push(42)  // No runtime overhead
```

### Objective-C Runtime Overhead
```objective-c
// Objective-C generics are mostly compile-time sugar
// Runtime still uses id and type casting
@interface Stack<ObjectType> : NSObject
- (void)push:(ObjectType)item;
- (ObjectType)pop;
@end

@implementation Stack {
    NSMutableArray *_items;  // Still stores id objects
}

- (void)push:(id)item {
    [_items addObject:item];  // Boxing required for primitives
}

- (id)pop {
    id item = [_items lastObject];
    [_items removeLastObject];
    return item;  // Runtime type checking
}
@end
```

## Key Generic Advantages

### Swift Benefits
1. **Type Safety**: Compile-time type checking prevents runtime errors
2. **Performance**: No boxing/unboxing for value types
3. **Code Reuse**: Write once, works with many types
4. **Expressiveness**: Complex type relationships possible
5. **Specialization**: Compiler generates optimized code for each type

### When to Use Generics
- **Collections and Data Structures**: Arrays, dictionaries, stacks, queues
- **Algorithms**: Sorting, searching, transforming data
- **Networking**: Generic response handling
- **Utility Functions**: Type-safe helper functions

Swift's generic system provides powerful tools for creating flexible, reusable, and type-safe code that performs well across different types while maintaining compile-time safety guarantees.
# Collections

Comparing array, dictionary, and set handling between Swift and Objective-C.

## Overview

Collections are fundamental to most applications, and Swift provides significant improvements over Objective-C in terms of type safety, syntax clarity, and performance. Swift collections are type-safe, have cleaner syntax, and offer better compile-time guarantees.

## Arrays

### Swift Arrays: Type-Safe and Clean
```swift
// Type-safe arrays
let fruits = ["Apple", "Banana", "Cherry"]        // [String]
var numbers = [1, 2, 3, 4, 5]                    // [Int]
var mixedArray: [Any] = ["Text", 42, true]       // Mixed types (rarely used)

// Array operations
numbers.append(6)
numbers += [7, 8, 9]
let first = numbers.first  // Optional(1)
let count = numbers.count  // 9

// Safe subscripting
if numbers.indices.contains(10) {
    let value = numbers[10]
} else {
    print("Index out of bounds")
}

// Functional operations
let doubled = numbers.map { $0 * 2 }
let evens = numbers.filter { $0 % 2 == 0 }
let sum = numbers.reduce(0, +)
```

### Objective-C Arrays: Runtime Type Checking
```objective-c
// Mixed type arrays (potential for runtime errors)
NSArray *fruits = @[@"Apple", @"Banana", @"Cherry"];
NSMutableArray *numbers = [@[@1, @2, @3, @4, @5] mutableCopy];

// Operations require more verbose syntax
[numbers addObject:@6];
[numbers addObjectsFromArray:@[@7, @8, @9]];
NSNumber *first = [numbers firstObject];  // Might be nil
NSUInteger count = [numbers count];

// Manual bounds checking needed
if (10 < [numbers count]) {
    NSNumber *value = numbers[10];
} else {
    NSLog(@"Index out of bounds");
}

// No built-in functional operations
NSMutableArray *doubled = [NSMutableArray array];
for (NSNumber *num in numbers) {
    [doubled addObject:@([num integerValue] * 2)];
}
```

## Dictionaries

### Swift Dictionaries: Type-Safe Key-Value Pairs
```swift
// Type-safe dictionaries
var userInfo = ["name": "Alice", "email": "alice@example.com"]  // [String: String]
var scores = ["Alice": 95, "Bob": 87, "Charlie": 92]            // [String: Int]

// Safe value access (returns optionals)
if let name = userInfo["name"] {
    print("User name: \(name)")
} else {
    print("Name not found")
}

// Updating values
userInfo["phone"] = "555-1234"
userInfo.updateValue("alice.smith@example.com", forKey: "email")

// Iteration
for (key, value) in scores {
    print("\(key): \(value)")
}

// Functional operations
let highScores = scores.filter { $0.value >= 90 }
let totalScore = scores.values.reduce(0, +)
```

### Objective-C Dictionaries: Runtime Flexibility
```objective-c
// Mixed type dictionaries
NSMutableDictionary *userInfo = [@{@"name": @"Alice", 
                                   @"email": @"alice@example.com"} mutableCopy];
NSDictionary *scores = @{@"Alice": @95, @"Bob": @87, @"Charlie": @92};

// Value access (no compile-time guarantee of type)
NSString *name = userInfo[@"name"];
if (name) {
    NSLog(@"User name: %@", name);
} else {
    NSLog(@"Name not found");
}

// Updating values
userInfo[@"phone"] = @"555-1234";
[userInfo setObject:@"alice.smith@example.com" forKey:@"email"];

// Iteration
for (NSString *key in scores) {
    NSNumber *value = scores[key];
    NSLog(@"%@: %@", key, value);
}
```

## Sets

### Swift Sets: Unique Value Collections
```swift
// Type-safe sets
var uniqueNumbers: Set<Int> = [1, 2, 3, 4, 5]
var colors: Set = ["Red", "Green", "Blue"]  // Type inferred as Set<String>

// Set operations
uniqueNumbers.insert(6)
uniqueNumbers.remove(3)
let containsFive = uniqueNumbers.contains(5)  // true

// Mathematical set operations
let setA: Set = [1, 2, 3, 4]
let setB: Set = [3, 4, 5, 6]

let union = setA.union(setB)              // [1, 2, 3, 4, 5, 6]
let intersection = setA.intersection(setB) // [3, 4]
let difference = setA.subtracting(setB)    // [1, 2]
```

### Objective-C Sets: NSSet and NSMutableSet
```objective-c
// Object sets
NSMutableSet *uniqueNumbers = [NSMutableSet setWithArray:@[@1, @2, @3, @4, @5]];
NSSet *colors = [NSSet setWithArray:@[@"Red", @"Green", @"Blue"]];

// Set operations
[uniqueNumbers addObject:@6];
[uniqueNumbers removeObject:@3];
BOOL containsFive = [uniqueNumbers containsObject:@5];

// Mathematical operations (more verbose)
NSSet *setA = [NSSet setWithArray:@[@1, @2, @3, @4]];
NSSet *setB = [NSSet setWithArray:@[@3, @4, @5, @6]];

NSMutableSet *union = [setA mutableCopy];
[union unionSet:setB];

NSMutableSet *intersection = [setA mutableCopy];
[intersection intersectSet:setB];
```

## Collection Iteration

### Swift: Clean and Functional
```swift
let items = ["first", "second", "third"]

// Simple iteration
for item in items {
    print(item)
}

// Index and value
for (index, item) in items.enumerated() {
    print("\(index): \(item)")
}

// Functional iteration
items.forEach { print($0) }

// Filtering and mapping
let longItems = items.filter { $0.count > 5 }
let uppercased = items.map { $0.uppercased() }
```

### Objective-C: More Verbose Options
```objective-c
NSArray *items = @[@"first", @"second", @"third"];

// Traditional for loop
for (NSInteger i = 0; i < [items count]; i++) {
    NSString *item = items[i];
    NSLog(@"%@", item);
}

// Fast enumeration
for (NSString *item in items) {
    NSLog(@"%@", item);
}

// Block-based enumeration
[items enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
    NSLog(@"%lu: %@", (unsigned long)idx, item);
}];
```

## Performance Characteristics

### Swift Advantages
- **Value Types**: Arrays and dictionaries are structs, enabling copy-on-write optimization
- **Type Specialization**: Compiler generates optimized code for specific types
- **Bridging**: Efficient bridging to Foundation when needed
- **Functional Operations**: Built-in map, filter, reduce are optimized

### Memory Management
```swift
// Swift: Automatic copy-on-write
var original = [1, 2, 3, 4, 5]
var copy = original        // Shares storage
copy.append(6)            // Now makes actual copy

// Objective-C: Manual copying decisions
NSArray *original = @[@1, @2, @3, @4, @5];
NSMutableArray *copy = [original mutableCopy];  // Always copies
```

## Type Safety Benefits

### Swift: Compile-Time Guarantees
```swift
let strings = ["A", "B", "C"]
let numbers = [1, 2, 3]

// This won't compile - type mismatch caught early
// let mixed = strings + numbers  // Error!

// Safe type conversion
let stringNumbers = numbers.map { String($0) }
let combined = strings + stringNumbers  // ["A", "B", "C", "1", "2", "3"]
```

### Objective-C: Runtime Discovery
```objective-c
NSArray *strings = @[@"A", @"B", @"C"];
NSArray *numbers = @[@1, @2, @3];

// This compiles but might cause runtime issues
NSMutableArray *mixed = [NSMutableArray array];
[mixed addObjectsFromArray:strings];
[mixed addObjectsFromArray:numbers];

// Type checking happens at runtime
for (id object in mixed) {
    if ([object isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)object;
        // Handle string
    } else if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)object;
        // Handle number
    }
}
```

## Migration Tips

When converting from Objective-C to Swift collections:

1. **Add Type Information**: Specify element types explicitly when needed
2. **Use Optional Binding**: Handle nil values from dictionary lookups safely
3. **Embrace Immutability**: Use `let` for collections that don't change
4. **Leverage Functional Operations**: Replace loops with map, filter, reduce
5. **Consider Value Semantics**: Understand copying behavior differences

## Best Practices

### Swift Collection Best Practices
1. **Default to Immutable**: Use `let` unless mutation is required
2. **Be Explicit About Types**: When working with mixed data
3. **Use Appropriate Collection**: Array for order, Set for uniqueness, Dictionary for lookup
4. **Functional Style**: Prefer map/filter/reduce over manual loops
5. **Safe Access**: Always handle optional returns from dictionary lookups

Swift's collection types provide the same functionality as Objective-C with significant improvements in safety, performance, and expressiveness. The type system prevents many runtime errors while the functional programming features enable more concise and readable code.
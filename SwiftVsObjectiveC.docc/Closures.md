# Closures

Comparing closures in Swift with blocks in Objective-C.

## Overview

Both Swift and Objective-C support closures (called "blocks" in Objective-C) for functional programming patterns. Swift provides cleaner syntax, better type inference, and more powerful capture semantics.

## Basic Syntax

### Swift: Clean Closure Syntax
```swift
// Simple closure
let greeting = { (name: String) -> String in
    return "Hello, \(name)!"
}

print(greeting("Alice"))  // Hello, Alice!

// Closure with type inference
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { number in
    return number * 2
}

// Even shorter with shorthand argument names
let tripled = numbers.map { $0 * 3 }

// Trailing closure syntax
let filtered = numbers.filter { $0 > 2 }
print(filtered)  // [3, 4, 5]
```

### Objective-C: Block Syntax
```objective-c
// Block type definition
NSString *(^greeting)(NSString *) = ^NSString *(NSString *name) {
    return [NSString stringWithFormat:@"Hello, %@!", name];
};

NSLog(@"%@", greeting(@"Alice"));  // Hello, Alice!

// Using blocks with NSArray
NSArray<NSNumber *> *numbers = @[@1, @2, @3, @4, @5];

NSArray<NSNumber *> *doubled = [numbers objectsAtIndexes:[numbers indexesOfObjectsPassingTest:^BOOL(NSNumber *number, NSUInteger idx, BOOL *stop) {
    // More complex syntax required
    return [number integerValue] > 2;
}]];

// Enumeration with blocks
[numbers enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
    NSLog(@"Number at index %lu: %@", (unsigned long)idx, number);
}];
```

## Function Parameters

### Swift: Flexible Closure Parameters
```swift
// Function taking closure as parameter
func processArray<T, U>(_ array: [T], transform: (T) -> U) -> [U] {
    return array.map(transform)
}

// Multiple ways to call
let strings = ["1", "2", "3", "4", "5"]

// Explicit closure syntax
let integers1 = processArray(strings, transform: { (str: String) -> Int in
    return Int(str) ?? 0
})

// Type inference
let integers2 = processArray(strings) { str in
    Int(str) ?? 0
}

// Shorthand arguments
let integers3 = processArray(strings) { Int($0) ?? 0 }

// Trailing closure (when closure is last parameter)
let integers4 = processArray(strings) { Int($0) ?? 0 }

print(integers4)  // [1, 2, 3, 4, 5]
```

### Objective-C: Block Type Definitions
```objective-c
// Block type definition
typedef NSNumber *(^TransformBlock)(NSString *input);

// Function taking block as parameter
- (NSArray<NSNumber *> *)processArray:(NSArray<NSString *> *)array 
                            transform:(TransformBlock)transform {
    NSMutableArray<NSNumber *> *result = [NSMutableArray array];
    for (NSString *str in array) {
        NSNumber *transformed = transform(str);
        [result addObject:transformed];
    }
    return [result copy];
}

// Usage (more verbose)
NSArray<NSString *> *strings = @[@"1", @"2", @"3", @"4", @"5"];
NSArray<NSNumber *> *integers = [self processArray:strings 
                                          transform:^NSNumber *(NSString *input) {
    return @([input integerValue]);
}];
```

## Capture Semantics

### Swift: Flexible Capture with Safety
```swift
func createCountingFunction() -> () -> Int {
    var counter = 0
    
    // Closure captures 'counter' by reference
    return {
        counter += 1
        return counter
    }
}

let count = createCountingFunction()
print(count())  // 1
print(count())  // 2
print(count())  // 3

// Explicit capture list for memory safety
class ViewController {
    var name = "ViewController"
    
    func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            print("Timer fired in \(self.name)")
        }
    }
    
    func setupTimerWithUnowned() {
        // Use unowned when you know self won't be deallocated
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] _ in
            print("Timer fired in \(self.name)")
        }
    }
}
```

### Objective-C: Manual Memory Management
```objective-c
// Capturing variables in blocks
typedef NSInteger (^CounterBlock)(void);

- (CounterBlock)createCountingFunction {
    __block NSInteger counter = 0;  // __block allows modification
    
    return ^NSInteger {
        counter++;
        return counter;
    };
}

CounterBlock count = [self createCountingFunction];
NSLog(@"%ld", (long)count());  // 1
NSLog(@"%ld", (long)count());  // 2

// Memory management with blocks
@interface ViewController : UIViewController
@property (nonatomic, strong) NSString *name;
- (void)setupTimer;
@end

@implementation ViewController

- (void)setupTimer {
    // Weak reference to prevent retain cycle
    __weak typeof(self) weakSelf = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                    repeats:YES
                                      block:^(NSTimer *timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSLog(@"Timer fired in %@", strongSelf.name);
        } else {
            [timer invalidate];
        }
    }];
}

@end
```

## Higher-Order Functions

### Swift: Rich Functional Programming
```swift
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// Map: Transform each element
let squared = numbers.map { $0 * $0 }
print(squared)  // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

// Filter: Select elements that match condition
let evens = numbers.filter { $0 % 2 == 0 }
print(evens)  // [2, 4, 6, 8, 10]

// Reduce: Combine elements into single value
let sum = numbers.reduce(0) { $0 + $1 }
let product = numbers.reduce(1, *)  // Operator function
print("Sum: \(sum), Product: \(product)")

// CompactMap: Transform and remove nils
let strings = ["1", "2", "abc", "4", "xyz"]
let validNumbers = strings.compactMap { Int($0) }
print(validNumbers)  // [1, 2, 4]

// Chaining operations
let result = numbers
    .filter { $0 % 2 == 0 }  // Get even numbers
    .map { $0 * $0 }         // Square them
    .reduce(0, +)            // Sum them up

print("Sum of squared evens: \(result)")  // 220

// Sort with closure
let words = ["apple", "Banana", "cherry", "Date"]
let sortedWords = words.sorted { $0.lowercased() < $1.lowercased() }
print(sortedWords)  // ["apple", "Banana", "cherry", "Date"]
```

### Objective-C: Limited Functional Support
```objective-c
NSArray<NSNumber *> *numbers = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];

// Map equivalent (manual implementation)
NSMutableArray<NSNumber *> *squared = [NSMutableArray array];
for (NSNumber *num in numbers) {
    [squared addObject:@([num integerValue] * [num integerValue])];
}

// Filter with predicates
NSPredicate *evenPredicate = [NSPredicate predicateWithBlock:^BOOL(NSNumber *number, NSDictionary *bindings) {
    return [number integerValue] % 2 == 0;
}];
NSArray<NSNumber *> *evens = [numbers filteredArrayUsingPredicate:evenPredicate];

// Reduce equivalent (manual implementation)
NSInteger sum = 0;
for (NSNumber *num in numbers) {
    sum += [num integerValue];
}

// Enumeration with blocks (closest to map)
NSMutableArray<NSNumber *> *doubled = [NSMutableArray array];
[numbers enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
    [doubled addObject:@([number integerValue] * 2)];
}];

// Sorting with comparator
NSArray<NSString *> *words = @[@"apple", @"Banana", @"cherry", @"Date"];
NSArray<NSString *> *sortedWords = [words sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
    return [[str1 lowercaseString] compare:[str2 lowercaseString]];
}];
```

## Async Closures

### Swift: Modern Async/Await with Closures
```swift
// Traditional callback pattern
func fetchData(completion: @escaping @Sendable (Result<String, Error>) -> Void) {
    DispatchQueue.global().async {
        // Simulate async work
        Thread.sleep(forTimeInterval: 1)
        
        DispatchQueue.main.async {
            completion(.success("Data loaded"))
        }
    }
}

// Modern async/await
func fetchDataAsync() async -> String {
    // Simulate async work
    try? await Task.sleep(for: .seconds(1))
    return "Data loaded"
}

// Usage
Task {
    let data = await fetchDataAsync()
    print(data)
}

// Continuation bridge between callback and async
func fetchDataWithContinuation() async -> String {
    return await withCheckedContinuation { continuation in
        fetchData { result in
            switch result {
            case .success(let data):
                continuation.resume(returning: data)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}
```

### Objective-C: Traditional Callback Pattern
```objective-c
// Callback with blocks
typedef void(^CompletionBlock)(NSString * _Nullable data, NSError * _Nullable error);

- (void)fetchDataWithCompletion:(CompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Simulate async work
        [NSThread sleepForTimeInterval:1.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(@"Data loaded", nil);
        });
    });
}

// Usage
[self fetchDataWithCompletion:^(NSString *data, NSError *error) {
    if (data) {
        NSLog(@"%@", data);
    } else {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}];
```

## Performance Considerations

### Swift: Optimized Closures
```swift
// Closures can be optimized by the compiler
func performanceTest() {
    let numbers = Array(1...1_000_000)
    
    // Compiler can optimize this closure
    let sum = numbers.reduce(0, +)
    
    // Even complex closures get optimized
    let processedSum = numbers
        .filter { $0 % 2 == 0 }
        .map { $0 * $0 }
        .reduce(0, +)
    
    print("Sum: \(sum), Processed: \(processedSum)")
}

// @noescape closures (now automatic) can be further optimized
func synchronousOperation<T, U>(_ value: T, transform: (T) -> U) -> U {
    return transform(value)  // Closure doesn't escape function
}
```

### Objective-C: Block Overhead
```objective-c
// Blocks have runtime overhead
- (void)performanceTest {
    NSArray<NSNumber *> *numbers = // ... large array
    
    // Block enumeration has more overhead than direct loops
    __block NSInteger sum = 0;
    [numbers enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        sum += [number integerValue];
    }];
    
    // Direct loop is often faster
    NSInteger directSum = 0;
    for (NSNumber *number in numbers) {
        directSum += [number integerValue];
    }
}
```

## Key Closure Advantages

### Swift Benefits
1. **Cleaner Syntax**: Less verbose than Objective-C blocks
2. **Type Inference**: Compiler figures out types automatically
3. **Trailing Closure**: Reads more naturally for single closure parameters
4. **Capture Lists**: Explicit memory management control
5. **Performance**: Better optimization opportunities

### Best Practices

#### Swift Closure Guidelines
1. **Use trailing closure syntax** when closure is the last parameter
2. **Prefer shorthand argument names** ($0, $1) for simple operations
3. **Use capture lists** to prevent retain cycles
4. **Choose appropriate capture semantics** (weak vs unowned)
5. **Consider async/await** over callback-based patterns

```swift
// Good: Clean, readable closure usage
let results = items
    .filter { $0.isActive }
    .map { $0.name.uppercased() }
    .sorted()

// Good: Proper memory management
networkManager.fetch { [weak self] result in
    guard let self = self else { return }
    self.handleResult(result)
}
```

Swift's closure system provides the same fundamental capabilities as Objective-C blocks while offering significantly cleaner syntax, better performance, and more powerful features for functional programming patterns.
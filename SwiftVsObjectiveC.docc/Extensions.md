# Extensions

Comparing extension capabilities between Swift and Objective-C categories.

## Overview

Extensions (Swift) and Categories (Objective-C) allow you to add functionality to existing types. Swift extensions are more powerful, supporting computed properties, protocol conformance, and better integration with the type system.

## Basic Extensions

### Swift: Powerful Extension System
```swift
extension String {
    func isPalindrome() -> Bool {
        let lowercased = self.lowercased()
        return lowercased == String(lowercased.reversed())
    }
    
    func wordCount() -> Int {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }.count
    }
    
    var isEmail: Bool {
        return self.contains("@") && self.contains(".")
    }
}

// Usage
let text = "A man a plan a canal Panama"
print(text.isPalindrome())  // false
print(text.wordCount())     // 7

let email = "user@example.com"
print(email.isEmail)        // true
```

### Objective-C: Category System
```objective-c
// NSString+Utilities.h
@interface NSString (Utilities)
- (BOOL)isPalindrome;
- (NSUInteger)wordCount;
- (BOOL)isEmail;
@end

// NSString+Utilities.m
@implementation NSString (Utilities)

- (BOOL)isPalindrome {
    NSString *lowercased = [self lowercaseString];
    NSString *reversed = // Implementation to reverse string
    return [lowercased isEqualToString:reversed];
}

- (NSUInteger)wordCount {
    NSArray *words = [self componentsSeparatedByCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *nonEmptyWords = [words filteredArrayUsingPredicate:
                             [NSPredicate predicateWithFormat:@"length > 0"]];
    return [nonEmptyWords count];
}

- (BOOL)isEmail {
    return [self containsString:@"@"] && [self containsString:@"."];
}

@end
```

## Computed Properties

### Swift: Extensions Can Add Properties
```swift
extension Int {
    var squared: Int {
        return self * self
    }
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return !isEven
    }
    
    var factorial: Int {
        guard self >= 0 else { return 0 }
        guard self > 1 else { return 1 }
        return (1...self).reduce(1, *)
    }
}

// Usage
let number = 5
print("\(number) squared: \(number.squared)")    // 5 squared: 25
print("\(number) is even: \(number.isEven)")     // 5 is even: false
print("\(number) factorial: \(number.factorial)") // 5 factorial: 120
```

### Objective-C: No Property Addition in Categories
```objective-c
// Categories cannot add stored properties
// Must use methods instead
@interface NSNumber (MathUtilities)
- (NSNumber *)squared;
- (BOOL)isEven;
- (BOOL)isOdd;
- (NSNumber *)factorial;
@end

@implementation NSNumber (MathUtilities)

- (NSNumber *)squared {
    double value = [self doubleValue];
    return @(value * value);
}

- (BOOL)isEven {
    return [self integerValue] % 2 == 0;
}

- (BOOL)isOdd {
    return ![self isEven];
}

- (NSNumber *)factorial {
    NSInteger value = [self integerValue];
    if (value < 0) return @0;
    if (value <= 1) return @1;
    
    NSInteger result = 1;
    for (NSInteger i = 2; i <= value; i++) {
        result *= i;
    }
    return @(result);
}

@end
```

## Protocol Conformance

### Swift: Adding Protocol Conformance via Extensions
```swift
protocol Describable {
    var description: String { get }
}

protocol Summable {
    static func + (lhs: Self, rhs: Self) -> Self
}

// Add protocol conformance to existing types
extension Array: Describable where Element: CustomStringConvertible {
    var description: String {
        let items = self.map { $0.description }.joined(separator: ", ")
        return "[\(items)]"
    }
}

extension Int: Summable {
    // + operator already exists, so conformance is automatic
}

extension String: Summable {
    // + operator already exists for concatenation
}

// Usage
let numbers = [1, 2, 3, 4, 5]
print(numbers.description)  // [1, 2, 3, 4, 5]

let result1: Int = 5 + 3      // Uses Summable
let result2: String = "Hello" + " World"  // Uses Summable
```

### Objective-C: Limited Protocol Addition
```objective-c
// Can add protocol conformance but implementation must be complete
@interface NSArray (Describable) <Describable>
@end

@implementation NSArray (Describable)
// Must implement all required protocol methods
- (NSString *)description {
    // Custom implementation
    return [self componentsJoinedByString:@", "];
}
@end
```

## Functional Programming Extensions

### Swift: Higher-Order Function Extensions
```swift
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<min($0 + size, self.count)])
        }
    }
    
    func unique<T: Hashable>() -> [Element] where Element == T {
        var seen = Set<T>()
        return filter { seen.insert($0).inserted }
    }
    
    func groupBy<Key: Hashable>(_ keySelector: (Element) -> Key) -> [Key: [Element]] {
        return Dictionary(grouping: self, by: keySelector)
    }
}

// Usage
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
let chunks = numbers.chunked(into: 3)
print(chunks)  // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

let duplicates = [1, 2, 2, 3, 3, 3, 4]
let unique = duplicates.unique()
print(unique)  // [1, 2, 3, 4]

struct Person {
    let name: String
    let department: String
}

let people = [
    Person(name: "Alice", department: "Engineering"),
    Person(name: "Bob", department: "Marketing"),
    Person(name: "Charlie", department: "Engineering")
]

let grouped = people.groupBy { $0.department }
print(grouped)  // ["Engineering": [Alice, Charlie], "Marketing": [Bob]]
```

### Objective-C: Manual Utility Methods
```objective-c
@interface NSArray (FunctionalUtilities)
- (NSArray *)chunkedIntoSize:(NSUInteger)size;
- (NSArray *)unique;
- (NSDictionary *)groupByKey:(NSString *(^)(id obj))keySelector;
@end

@implementation NSArray (FunctionalUtilities)

- (NSArray *)chunkedIntoSize:(NSUInteger)size {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < [self count]; i += size) {
        NSRange range = NSMakeRange(i, MIN(size, [self count] - i));
        NSArray *chunk = [self subarrayWithRange:range];
        [result addObject:chunk];
    }
    return [result copy];
}

- (NSArray *)unique {
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:self];
    return [orderedSet array];
}

- (NSDictionary *)groupByKey:(NSString *(^)(id obj))keySelector {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id obj in self) {
        NSString *key = keySelector(obj);
        NSMutableArray *group = result[key];
        if (!group) {
            group = [NSMutableArray array];
            result[key] = group;
        }
        [group addObject:obj];
    }
    return [result copy];
}

@end
```

## Generic Extensions

### Swift: Generic Extensions with Constraints
```swift
extension Optional {
    func orElse(_ defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
    
    func ifPresent(_ action: (Wrapped) -> Void) {
        if let value = self {
            action(value)
        }
    }
}

extension Collection where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
    
    func average() -> Double {
        guard !isEmpty else { return 0 }
        let total = sum()
        return Double(String(describing: total)) ?? 0 / Double(count)
    }
}

extension Sequence where Element: Equatable {
    func count(of element: Element) -> Int {
        return reduce(0) { count, current in
            count + (current == element ? 1 : 0)
        }
    }
}

// Usage
let optionalName: String? = nil
let name = optionalName.orElse("Anonymous")

let optionalAge: Int? = 25
optionalAge.ifPresent { age in
    print("Age is \(age)")
}

let numbers = [1, 2, 3, 4, 5]
print("Sum: \(numbers.sum())")        // Sum: 15
print("Average: \(numbers.average())") // Average: 3.0

let letters = ["a", "b", "a", "c", "a"]
print("Count of 'a': \(letters.count(of: "a"))")  // Count of 'a': 3
```

### Objective-C: No Generic Extensions
```objective-c
// Must create separate categories for each type
@interface NSArray (NumericUtilities)
- (NSNumber *)sum;  // Only works with NSNumber arrays
- (NSNumber *)average;
@end

@interface NSArray (ObjectUtilities)
- (NSUInteger)countOfObject:(id)object;  // Works with any object
@end
```

## Retroactive Modeling

### Swift: Adding Capabilities to Existing Types
```swift
// Make existing types conform to new protocols
protocol JSONSerializable {
    func toJSON() -> String
}

extension String: JSONSerializable {
    func toJSON() -> String {
        let escaped = self.replacingOccurrences(of: "\"", with: "\\\"")
        return "\"\(escaped)\""
    }
}

extension Int: JSONSerializable {
    func toJSON() -> String {
        return String(self)
    }
}

extension Array: JSONSerializable where Element: JSONSerializable {
    func toJSON() -> String {
        let items = self.map { $0.toJSON() }.joined(separator: ", ")
        return "[\(items)]"
    }
}

// Usage - existing types now have new capabilities
let text = "Hello World"
let number = 42
let numbers = [1, 2, 3]

print(text.toJSON())     // "Hello World"
print(number.toJSON())   // 42
print(numbers.toJSON())  // [1, 2, 3]
```

### Objective-C: Limited Retroactive Capabilities
```objective-c
// Can add methods but cannot easily add protocol conformance
// to existing classes retroactively in all cases
@protocol JSONSerializable <NSObject>
- (NSString *)toJSON;
@end

@interface NSString (JSONSerializable) <JSONSerializable>
@end

@implementation NSString (JSONSerializable)
- (NSString *)toJSON {
    NSString *escaped = [self stringByReplacingOccurrencesOfString:@"\"" 
                                                         withString:@"\\\""];
    return [NSString stringWithFormat:@"\"%@\"", escaped];
}
@end
```

## Key Extension Advantages

### Swift Extensions Benefits
1. **Computed Properties**: Add property-like syntax to existing types
2. **Protocol Conformance**: Make existing types adopt new protocols
3. **Generic Constraints**: Create extensions that work with specific type constraints
4. **Retroactive Modeling**: Add new capabilities to types you don't own
5. **Better Organization**: Group related functionality together

### Best Practices

#### Swift Extension Guidelines
1. **Group Related Functionality**: Use extensions to organize code by feature
2. **Protocol Conformance**: Use separate extensions for each protocol
3. **Conditional Conformance**: Add protocol conformance only when constraints are met
4. **Don't Override**: Avoid overriding existing methods in extensions

```swift
// Good: Organized by functionality
extension String {
    // MARK: - Validation
    var isEmail: Bool { /* implementation */ }
    var isPhoneNumber: Bool { /* implementation */ }
}

extension String {
    // MARK: - Formatting  
    func capitalized() -> String { /* implementation */ }
    func truncated(to length: Int) -> String { /* implementation */ }
}
```

Swift's extension system provides significantly more power and flexibility than Objective-C categories, enabling better code organization, retroactive modeling, and type-safe generic programming.
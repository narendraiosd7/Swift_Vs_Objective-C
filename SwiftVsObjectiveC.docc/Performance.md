# Performance

Comparing performance characteristics, optimizations, and benchmarks between Swift and Objective-C.

## Overview

Swift and Objective-C have different performance profiles due to their architectural differences. Swift offers compile-time optimizations and value semantics, while Objective-C provides predictable runtime behavior and dynamic dispatch capabilities.

## Compilation and Optimization

### Swift: Aggressive Compile-Time Optimization
```swift
// Swift code gets heavily optimized at compile time
struct Point {
    let x: Double
    let y: Double
    
    func distance(to other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return (dx * dx + dy * dy).squareRoot()
    }
}

// This function might be completely inlined and optimized away
func calculateDistances() -> [Double] {
    let points = [
        Point(x: 0, y: 0),
        Point(x: 1, y: 1),
        Point(x: 2, y: 2)
    ]
    
    return points.map { $0.distance(to: Point(x: 0, y: 0)) }
}

// Generic specialization - compiler creates optimized versions
func processArray<T>(_ items: [T], transform: (T) -> T) -> [T] {
    return items.map(transform)
}

// Compiler generates specialized versions for each type:
let integers = processArray([1, 2, 3]) { $0 * 2 }    // Specialized for Int
let doubles = processArray([1.1, 2.2]) { $0 * 2 }    // Specialized for Double
```

### Objective-C: Runtime-Heavy Approach
```objective-c
// Objective-C relies heavily on runtime dispatch
@interface Point : NSObject
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
- (double)distanceToPoint:(Point *)other;
@end

@implementation Point
- (double)distanceToPoint:(Point *)other {
    double dx = self.x - other.x;
    double dy = self.y - other.y;
    return sqrt(dx * dx + dy * dy);
}
@end

// Each method call goes through objc_msgSend
- (NSArray<NSNumber *> *)calculateDistances {
    NSArray<Point *> *points = @[
        [[Point alloc] initWithX:0 y:0],
        [[Point alloc] initWithX:1 y:1],
        [[Point alloc] initWithX:2 y:2]
    ];
    
    Point *origin = [[Point alloc] initWithX:0 y:0];
    NSMutableArray<NSNumber *> *distances = [NSMutableArray array];
    
    for (Point *point in points) {
        double distance = [point distanceToPoint:origin];  // Dynamic dispatch
        [distances addObject:@(distance)];
    }
    
    return distances;
}
```

## Memory Performance

### Swift: Value Types and Copy-on-Write
```swift
// Value types can be stack-allocated for better performance
struct Rectangle {
    let width: Double
    let height: Double
    
    var area: Double {
        return width * height
    }
}

// Arrays use copy-on-write optimization
var originalArray = Array(1...1000)
var copiedArray = originalArray        // No actual copying happens
copiedArray.append(1001)              // Copy happens only when modified

// Protocol types can use existential containers efficiently
protocol Drawable {
    func draw() -> String
}

struct Circle: Drawable {
    let radius: Double
    func draw() -> String { return "Circle" }
}

struct Square: Drawable {
    let side: Double
    func draw() -> String { return "Square" }
}

// Small structs fit in existential container without heap allocation
let shapes: [Drawable] = [Circle(radius: 5), Square(side: 4)]

// Performance comparison
func performanceTest() {
    let iterations = 1_000_000
    
    // Value type performance
    let start1 = CFAbsoluteTimeGetCurrent()
    var rectangles: [Rectangle] = []
    for i in 0..<iterations {
        rectangles.append(Rectangle(width: Double(i), height: Double(i)))
    }
    let time1 = CFAbsoluteTimeGetCurrent() - start1
    print("Value types: \(time1) seconds")
}
```

### Objective-C: Reference Types and Heap Allocation
```objective-c
@interface Rectangle : NSObject
@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;
@property (nonatomic, assign, readonly) double area;
@end

@implementation Rectangle
- (double)area {
    return self.width * self.height;
}
@end

// All objects are heap-allocated
- (void)performanceTest {
    NSInteger iterations = 1000000;
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSMutableArray<Rectangle *> *rectangles = [NSMutableArray array];
    for (NSInteger i = 0; i < iterations; i++) {
        Rectangle *rect = [[Rectangle alloc] init];
        rect.width = i;
        rect.height = i;
        [rectangles addObject:rect];  // Each object requires heap allocation
    }
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent() - start;
    NSLog(@"Reference types: %f seconds", time);
}
```

## Method Dispatch Performance

### Swift: Multiple Dispatch Mechanisms
```swift
// Static dispatch (fastest)
struct FastStruct {
    func process() -> Int {
        return 42  // Statically dispatched, can be inlined
    }
}

// Virtual dispatch (fast)
class BaseClass {
    func virtualMethod() -> Int {
        return 1  // Virtual table dispatch
    }
}

class DerivedClass: BaseClass {
    override func virtualMethod() -> Int {
        return 2  // Still virtual table dispatch
    }
}

// Protocol dispatch (slower but flexible)
protocol Processor {
    func process() -> Int
}

class ProtocolClass: Processor {
    func process() -> Int {
        return 3  // Protocol witness table dispatch
    }
}

// Dynamic dispatch (slowest but most flexible)
@objc class DynamicClass: NSObject {
    @objc dynamic func dynamicMethod() -> Int {
        return 4  // objc_msgSend like Objective-C
    }
}

// Performance comparison
func dispatchPerformanceTest() {
    let iterations = 10_000_000
    
    // Static dispatch
    let staticObj = FastStruct()
    let start1 = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        _ = staticObj.process()
    }
    let staticTime = CFAbsoluteTimeGetCurrent() - start1
    
    // Virtual dispatch
    let virtualObj: BaseClass = DerivedClass()
    let start2 = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        _ = virtualObj.virtualMethod()
    }
    let virtualTime = CFAbsoluteTimeGetCurrent() - start2
    
    // Protocol dispatch
    let protocolObj: Processor = ProtocolClass()
    let start3 = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        _ = protocolObj.process()
    }
    let protocolTime = CFAbsoluteTimeGetCurrent() - start3
    
    print("Static: \(staticTime)s, Virtual: \(virtualTime)s, Protocol: \(protocolTime)s")
}
```

### Objective-C: Dynamic Dispatch Only
```objective-c
@interface ProcessorClass : NSObject
- (NSInteger)process;
@end

@implementation ProcessorClass
- (NSInteger)process {
    return 42;
}
@end

- (void)dispatchPerformanceTest {
    NSInteger iterations = 10000000;
    ProcessorClass *processor = [[ProcessorClass alloc] init];
    
    // All method calls use dynamic dispatch
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < iterations; i++) {
        [processor process];  // Always objc_msgSend
    }
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent() - start;
    NSLog(@"Dynamic dispatch: %f seconds", time);
}
```

## Collection Performance

### Swift: Optimized Generic Collections
```swift
// Swift arrays are highly optimized
func collectionPerformanceTest() {
    let size = 1_000_000
    
    // Array creation and access
    let start1 = CFAbsoluteTimeGetCurrent()
    var numbers = Array<Int>()
    numbers.reserveCapacity(size)  // Pre-allocate for better performance
    
    for i in 0..<size {
        numbers.append(i)
    }
    
    var sum = 0
    for number in numbers {
        sum += number  // Direct memory access, no boxing
    }
    let time1 = CFAbsoluteTimeGetCurrent() - start1
    
    // Functional operations are optimized
    let start2 = CFAbsoluteTimeGetCurrent()
    let evenSum = numbers
        .filter { $0 % 2 == 0 }  // Optimized lazy evaluation possible
        .reduce(0, +)            // Specialized for numeric types
    let time2 = CFAbsoluteTimeGetCurrent() - start2
    
    // Dictionary operations
    let start3 = CFAbsoluteTimeGetCurrent()
    var dictionary: [Int: String] = [:]
    for i in 0..<size/10 {
        dictionary[i] = "Value \(i)"  // Optimized hash table
    }
    let time3 = CFAbsoluteTimeGetCurrent() - start3
    
    print("Array: \(time1)s, Functional: \(time2)s, Dictionary: \(time3)s")
}

// Struct collections avoid overhead
struct FastPoint {
    let x: Int
    let y: Int
}

func structArrayPerformance() {
    let size = 1_000_000
    let start = CFAbsoluteTimeGetCurrent()
    
    var points = [FastPoint]()
    points.reserveCapacity(size)
    
    for i in 0..<size {
        points.append(FastPoint(x: i, y: i * 2))  // No heap allocation
    }
    
    let sum = points.reduce(0) { $0 + $1.x + $1.y }  // Direct memory access
    let time = CFAbsoluteTimeGetCurrent() - start
    
    print("Struct array: \(time)s, Sum: \(sum)")
}
```

### Objective-C: Boxing Overhead
```objective-c
- (void)collectionPerformanceTest {
    NSInteger size = 1000000;
    
    // Array creation with boxing overhead
    CFAbsoluteTime start1 = CFAbsoluteTimeGetCurrent();
    NSMutableArray<NSNumber *> *numbers = [NSMutableArray arrayWithCapacity:size];
    
    for (NSInteger i = 0; i < size; i++) {
        [numbers addObject:@(i)];  // Boxing primitive to NSNumber
    }
    
    NSInteger sum = 0;
    for (NSNumber *number in numbers) {
        sum += [number integerValue];  // Unboxing NSNumber
    }
    CFAbsoluteTime time1 = CFAbsoluteTimeGetCurrent() - start1;
    
    // Dictionary operations
    CFAbsoluteTime start2 = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary<NSNumber *, NSString *> *dictionary = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < size/10; i++) {
        dictionary[@(i)] = [NSString stringWithFormat:@"Value %ld", (long)i];
    }
    CFAbsoluteTime time2 = CFAbsoluteTimeGetCurrent() - start2;
    
    NSLog(@"Array: %fs, Dictionary: %fs", time1, time2);
}
```

## Whole Module Optimization

### Swift: Advanced Optimization Strategies
```swift
// Swift can optimize across entire modules
public class APIClient {
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // This might be inlined across module boundaries
    @inlinable
    public func buildURL(endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
    
    // Complex function that can be specialized
    public func fetch<T: Codable>(_ type: T.Type, from endpoint: String) async throws -> T {
        guard let url = buildURL(endpoint: endpoint) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(type, from: data)
    }
}

// Compiler can specialize this for each specific type
enum APIError: Error {
    case invalidURL
    case decodingError
}

// Usage - can be heavily optimized
struct User: Codable {
    let id: Int
    let name: String
}

func optimizedUsage() async throws {
    let client = APIClient(baseURL: "https://api.example.com/")
    
    // Compiler can inline and specialize this entire call chain
    let user: User = try await client.fetch(User.self, from: "/users/1")
    print(user.name)
}
```

### Objective-C: Limited Cross-Module Optimization
```objective-c
// Objective-C optimization is limited by dynamic nature
@interface APIClient : NSObject
@property (nonatomic, strong, readonly) NSString *baseURL;
- (instancetype)initWithBaseURL:(NSString *)baseURL;
- (NSURL *)buildURLWithEndpoint:(NSString *)endpoint;
@end

@implementation APIClient

- (instancetype)initWithBaseURL:(NSString *)baseURL {
    self = [super init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

- (NSURL *)buildURLWithEndpoint:(NSString *)endpoint {
    NSString *fullURL = [self.baseURL stringByAppendingString:endpoint];
    return [NSURL URLWithString:fullURL];
}

// Each method call goes through runtime dispatch
- (void)fetchUserWithCompletion:(void(^)(User *user, NSError *error))completion {
    NSURL *url = [self buildURLWithEndpoint:@"/users/1"];  // Runtime dispatch
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] 
                                 dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Manual parsing, no compile-time optimization
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            completion(nil, jsonError);
            return;
        }
        
        User *user = [[User alloc] initWithDictionary:json];
        completion(user, nil);
    }];
    
    [task resume];
}

@end
```

## Real-World Performance Comparison

### Benchmark Results (Typical)

| Operation | Swift | Objective-C | Swift Advantage |
|-----------|-------|-------------|-----------------|
| **Integer Math** | 1.0x | 1.0x | ~Equal |
| **Object Creation** | 2-5x faster | 1.0x | Value types, stack allocation |
| **Array Operations** | 3-10x faster | 1.0x | No boxing, cache-friendly |
| **Method Calls** | 5-20x faster | 1.0x | Static/virtual dispatch |
| **Functional Operations** | 2-5x faster | 1.0x | Optimized map/filter/reduce |
| **String Processing** | 2-3x faster | 1.0x | Native Unicode, optimizations |

### When Objective-C Might Be Faster
```objective-c
// Objective-C can be faster for:
// 1. Heavy use of existing Objective-C frameworks
// 2. Code that requires a lot of dynamic behavior
// 3. Bridging between C libraries

// Example: Direct C library integration
#include <Accelerate/Accelerate.h>

- (void)fastMathOperations {
    // Direct C function calls - no overhead
    float input[1000];
    float output[1000];
    
    // Accelerate framework operations
    vDSP_vabs(input, 1, output, 1, 1000);  // SIMD operations
}

// Dynamic method resolution at runtime
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    // Objective-C's dynamic runtime can be powerful
    // for frameworks that need runtime method generation
    return [super methodSignatureForSelector:selector];
}
```

## Performance Best Practices

### Swift Optimization Tips
```swift
// 1. Use value types when possible
struct FastData {  // Prefer over class when inheritance not needed
    let values: [Int]
}

// 2. Mark performance-critical code with @inline
@inline(__always)
func criticalCalculation(_ x: Double) -> Double {
    return x * x + 2 * x + 1
}

// 3. Use final for classes when inheritance not needed
final class OptimizedClass {
    func process() { }  // Can be statically dispatched
}

// 4. Avoid unnecessary protocol conformance in hot paths
// protocol Processor { } // Avoid if not needed

// 5. Pre-allocate collections when size is known
func efficientArrayBuilding() {
    var array = [Int]()
    array.reserveCapacity(10000)  // Avoids reallocations
    
    for i in 0..<10000 {
        array.append(i)
    }
}

// 6. Use copy-on-write for large data structures
struct EfficientLargeData {
    private var storage: [Int]
    
    init(data: [Int]) {
        self.storage = data  // Shared until mutation
    }
    
    mutating func append(_ value: Int) {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Array(storage)  // Copy only when necessary
        }
        storage.append(value)
    }
}
```

## Summary

Swift generally outperforms Objective-C for:
- **CPU-intensive operations**: Better compiler optimizations
- **Memory-intensive operations**: Value types reduce heap pressure
- **Collection operations**: Type specialization and no boxing
- **Mathematical computations**: LLVM optimizations

Objective-C may still be preferred for:
- **Existing codebases**: Migration costs
- **Heavy C interop**: Direct integration
- **Dynamic runtime features**: Method swizzling, etc.

For new development, Swift's performance advantages, combined with safety and expressiveness, make it the clear choice for iOS development.
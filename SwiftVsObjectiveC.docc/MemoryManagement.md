# Memory Management

Understanding automatic reference counting and memory management differences between Swift and Objective-C.

## Overview

Both Swift and Objective-C use Automatic Reference Counting (ARC) for memory management, but Swift provides better safety features and clearer syntax for handling memory-related issues like retain cycles.

## Basic Memory Management

### Swift: Clean ARC with Clear Syntax
```swift
class Person {
    let name: String
    var pet: Pet?
    
    init(name: String) {
        self.name = name
        print("\(name) is created")
    }
    
    deinit {
        print("\(name) is being deallocated")
    }
}

class Pet {
    let name: String
    weak var owner: Person?  // Weak reference prevents retain cycle
    
    init(name: String) {
        self.name = name
        print("Pet \(name) is created")
    }
    
    deinit {
        print("Pet \(name) is being deallocated")
    }
}

// Usage - automatic cleanup
do {
    let john = Person(name: "John")
    let fluffy = Pet(name: "Fluffy")
    
    john.pet = fluffy
    fluffy.owner = john  // Weak reference - no retain cycle
    
    print("Relationships established")
} // Both objects deallocated here
```

### Objective-C: ARC with Manual Annotations
```objective-c
@interface Person : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) Pet *pet;
- (instancetype)initWithName:(NSString *)name;
@end

@interface Pet : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, weak) Person *owner;  // Weak to prevent cycle
- (instancetype)initWithName:(NSString *)name;
@end

@implementation Person
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        NSLog(@"%@ is created", name);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ is being deallocated", self.name);
}
@end

@implementation Pet
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        NSLog(@"Pet %@ is created", name);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Pet %@ is being deallocated", self.name);
}
@end
```

## Reference Types

### Swift: weak, unowned, and strong
```swift
class Course {
    let name: String
    var instructor: Instructor?
    weak var department: Department?  // Weak - department outlives course
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Course \(name) deallocated")
    }
}

class Instructor {
    let name: String
    unowned let university: University  // Unowned - university always outlives instructor
    var courses: [Course] = []
    
    init(name: String, university: University) {
        self.name = name
        self.university = university
    }
    
    deinit {
        print("Instructor \(name) deallocated")
    }
}

class University {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("University \(name) deallocated")
    }
}

class Department {
    let name: String
    var courses: [Course] = []
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Department \(name) deallocated")
    }
}
```

### Objective-C: strong, weak, unsafe_unretained
```objective-c
@interface Course : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) Instructor *instructor;
@property (nonatomic, weak) Department *department;
@end

@interface Instructor : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, unsafe_unretained, readonly) University *university;
@property (nonatomic, strong) NSMutableArray<Course *> *courses;
@end

@interface University : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@end

@interface Department : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) NSMutableArray<Course *> *courses;
@end
```

## Closure/Block Retain Cycles

### Swift: Capture Lists for Safety
```swift
class NetworkManager {
    var completion: ((String) -> Void)?
    
    func fetchData() {
        // Problem: Strong reference cycle
        self.completion = { data in
            self.processData(data)  // Captures self strongly
        }
        
        // Solution: Weak capture
        self.completion = { [weak self] data in
            self?.processData(data)  // Safe - weak reference
        }
        
        // Alternative: Unowned capture (when self is guaranteed to exist)
        self.completion = { [unowned self] data in
            self.processData(data)  // Crashes if self is deallocated
        }
    }
    
    private func processData(_ data: String) {
        print("Processing: \(data)")
    }
    
    deinit {
        print("NetworkManager deallocated")
    }
}

// Usage
var manager: NetworkManager? = NetworkManager()
manager?.fetchData()
manager = nil  // Will deallocate if no retain cycles
```

### Objective-C: __weak and __block
```objective-c
@interface NetworkManager : NSObject
@property (nonatomic, copy) void (^completion)(NSString *data);
- (void)fetchData;
@end

@implementation NetworkManager

- (void)fetchData {
    // Problem: Strong reference cycle
    self.completion = ^(NSString *data) {
        [self processData:data];  // Captures self strongly
    };
    
    // Solution: Weak reference
    __weak typeof(self) weakSelf = self;
    self.completion = ^(NSString *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf processData:data];
        }
    };
}

- (void)processData:(NSString *)data {
    NSLog(@"Processing: %@", data);
}

- (void)dealloc {
    NSLog(@"NetworkManager deallocated");
}

@end
```

## Value vs Reference Types

### Swift: Struct Value Semantics
```swift
struct Point {
    var x: Double
    var y: Double
}

class PointManager {
    var points: [Point] = []
    
    func addPoint(_ point: Point) {
        points.append(point)  // Point is copied, no memory management needed
    }
}

// Value types don't participate in ARC
var point1 = Point(x: 1.0, y: 2.0)
var point2 = point1  // Copied, not shared
point2.x = 5.0      // point1 unchanged

let manager = PointManager()
manager.addPoint(point1)  // point1 is copied into array
```

### Objective-C: All Objects are Reference Types
```objective-c
// In Objective-C, all objects are reference types
// Structs exist but are basic C structs without ARC
typedef struct {
    double x;
    double y;
} Point;  // Basic struct, no memory management

@interface PointManager : NSObject
@property (nonatomic, strong) NSMutableArray<NSValue *> *points;
- (void)addPoint:(Point)point;
@end

@implementation PointManager
- (void)addPoint:(Point)point {
    NSValue *pointValue = [NSValue valueWithBytes:&point objCType:@encode(Point)];
    [self.points addObject:pointValue];  // Must box into NSValue
}
@end
```

## Memory Management Best Practices

### Swift Guidelines
1. **Use weak references** for delegate patterns
2. **Use unowned** when you guarantee the referenced object outlives the referencing one
3. **Capture lists in closures** to prevent retain cycles
4. **Prefer value types** when you don't need reference semantics
5. **Use defer** for cleanup code

```swift
class APIClient {
    weak var delegate: APIClientDelegate?  // Delegate pattern
    
    func performRequest() {
        defer {
            // Cleanup code always runs
            print("Request completed")
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }  // Safe unwrap
            
            if let error = error {
                self.delegate?.client(self, didFailWith: error)
            } else if let data = data {
                self.delegate?.client(self, didReceive: data)
            }
        }
        
        task.resume()
    }
}

protocol APIClientDelegate: AnyObject {
    func client(_ client: APIClient, didReceive data: Data)
    func client(_ client: APIClient, didFailWith error: Error)
}
```

### Common Memory Pitfalls

#### Swift: Avoiding Retain Cycles
```swift
// Problem: Timer retain cycle
class TimerViewController {
    var timer: Timer?
    
    func startTimer() {
        // Problematic - timer retains target (self)
        timer = Timer.scheduledTimer(timeInterval: 1.0, 
                                   target: self, 
                                   selector: #selector(tick), 
                                   userInfo: nil, 
                                   repeats: true)
    }
    
    // Solution: Use weak references or proper cleanup
    func startTimerSafely() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    @objc func tick() {
        print("Tick")
    }
    
    deinit {
        timer?.invalidate()  // Always invalidate in deinit
    }
}
```

## Memory Management Summary

| Feature | Swift | Objective-C |
|---------|-------|-------------|
| **ARC** | Automatic, always on | Automatic in modern code |
| **Weak References** | `weak var` | `__weak` or `@property weak` |
| **Unowned References** | `unowned` | `unsafe_unretained` |
| **Closure Capture** | `[weak self]`, `[unowned self]` | `__weak`, `__strong` dance |
| **Value Types** | Structs don't use ARC | Limited to C structs |
| **Syntax** | Cleaner, more explicit | More verbose annotations |

Swift's memory management provides the same power as Objective-C's ARC system while offering cleaner syntax and better safety features for preventing common memory management errors.
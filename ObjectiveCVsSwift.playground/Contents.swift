import UIKit

/*
 OBJECTIVE-C vs SWIFT: Complete Comparison Guide
 ==============================================
 
 This playground covers all major differences between Objective-C and Swift
 from basic concepts to advanced features, explained in simple English.
*/

// MARK: - 1. BASIC SYNTAX DIFFERENCES

print("=== BASIC SYNTAX DIFFERENCES ===")

// Swift: Clean and simple syntax
let swiftGreeting = "Hello from Swift!"
print(swiftGreeting)

/*
 Objective-C equivalent:
 NSString *greeting = @"Hello from Objective-C!";
 NSLog(@"%@", greeting);
 
 Key Differences:
 - Swift: No semicolons needed, cleaner syntax
 - Swift: Type inference (no need to specify NSString)
 - Swift: print() instead of NSLog()
 - Objective-C: @ symbol needed for strings, semicolons required
*/

// MARK: - 2. VARIABLE DECLARATIONS

print("\n=== VARIABLE DECLARATIONS ===")

// Swift: Clear distinction between mutable and immutable
let constantValue = "Cannot change this"  // Immutable
var mutableValue = "Can change this"      // Mutable
mutableValue = "Changed!"

print("Constant: \(constantValue)")
print("Variable: \(mutableValue)")

/*
 Objective-C equivalent:
 NSString *constant = @"Cannot change this";  // Actually still mutable reference
 NSString *variable = @"Can change this";
 variable = @"Changed!";
 
 Key Differences:
 - Swift: 'let' vs 'var' clearly shows intent (immutable vs mutable)
 - Swift: Type inference - no need to specify types in many cases
 - Objective-C: All variables are mutable references by default
 - Swift: String interpolation with \() is cleaner than format strings
*/

// MARK: - 3. DATA TYPES

print("\n=== DATA TYPES ===")

// Swift: Clear, simple type system
let swiftInt: Int = 42
let swiftFloat: Float = 3.14
let swiftDouble: Double = 3.14159
let swiftBool: Bool = true
let swiftString: String = "Swift string"

print("Int: \(swiftInt), Float: \(swiftFloat), Bool: \(swiftBool)")

/*
 Objective-C equivalent:
 int objcInt = 42;
 float objcFloat = 3.14f;
 double objcDouble = 3.14159;
 BOOL objcBool = YES;  // or NO
 NSString *objcString = @"Objective-C string";
 
 Key Differences:
 - Swift: Unified type system (everything is an object)
 - Swift: Bool uses true/false, Objective-C uses YES/NO
 - Swift: No primitive vs object distinction
 - Objective-C: Has both primitives (int, float) and objects (NSString, NSNumber)
*/

// MARK: - 4. OPTIONALS (Swift's Safety Feature)

print("\n=== OPTIONALS ===")

// Swift: Built-in null safety with optionals
var optionalString: String? = "I might be nil"
var nilString: String? = nil

// Safe way to handle optionals
if let unwrapped = optionalString {
    print("Value exists: \(unwrapped)")
} else {
    print("Value is nil")
}

// Optional chaining (super safe!)
let length = optionalString?.count
print("String length: \(length ?? 0)")

/*
 Objective-C equivalent:
 NSString *string = @"I might be nil";
 NSString *nilString = nil;
 
 if (string != nil) {
     NSLog(@"Value exists: %@", string);
 } else {
     NSLog(@"Value is nil");
 }
 
 Key Differences:
 - Swift: Optionals prevent crashes by forcing you to handle nil cases
 - Swift: ? makes it clear when something can be nil
 - Swift: Optional binding (if let) is safer than manual nil checks
 - Objective-C: Everything can be nil, easy to forget checks and crash
 - Swift: Optional chaining (?.) prevents crashes when calling methods on nil
*/

// MARK: - 5. ARRAYS AND COLLECTIONS

print("\n=== ARRAYS AND COLLECTIONS ===")

// Swift: Type-safe collections
let swiftArray: [String] = ["Apple", "Banana", "Cherry"]
var mutableArray = ["One", "Two"]
mutableArray.append("Three")

// Dictionary (like a phone book - key finds value)
let swiftDict = ["name": "John", "age": "30", "city": "NYC"]

print("First fruit: \(swiftArray[0])")
print("Name: \(swiftDict["name"] ?? "Unknown")")

/*
 Objective-C equivalent:
 NSArray *array = @[@"Apple", @"Banana", @"Cherry"];
 NSMutableArray *mutableArray = [@[@"One", @"Two"] mutableCopy];
 [mutableArray addObject:@"Three"];
 
 NSDictionary *dict = @{@"name": @"John", @"age": @"30"};
 
 Key Differences:
 - Swift: Arrays know what type they contain [String] vs [Int]
 - Swift: Cleaner syntax for creating and accessing collections
 - Swift: Immutable by default (use 'let'), mutable with 'var'
 - Objective-C: Can mix any types in same array (dangerous!)
 - Swift: Direct access with [], Objective-C needs objectAtIndex:
*/

// MARK: - 6. FUNCTIONS AND METHODS

print("\n=== FUNCTIONS AND METHODS ===")

// Swift: Clear, readable function syntax
func greetPerson(name: String, age: Int) -> String {
    return "Hello \(name), you are \(age) years old!"
}

// Function with default values (makes life easier!)
func greetWithDefault(name: String = "Friend") -> String {
    return "Hello \(name)!"
}

let greeting1 = greetPerson(name: "Alice", age: 25)
let greeting2 = greetWithDefault()  // Uses default value
let greeting3 = greetWithDefault(name: "Bob")

print(greeting1)
print(greeting2)
print(greeting3)

/*
 Objective-C equivalent:
 - (NSString *)greetPersonWithName:(NSString *)name age:(NSInteger)age {
     return [NSString stringWithFormat:@"Hello %@, you are %ld years old!", name, (long)age];
 }
 
 // Calling the method:
 NSString *greeting = [self greetPersonWithName:@"Alice" age:25];
 
 Key Differences:
 - Swift: Functions are first-class citizens (can be stored in variables)
 - Swift: Clear parameter labels make code self-documenting
 - Swift: Return type comes after -> symbol
 - Swift: Default parameter values supported
 - Objective-C: Methods belong to classes, verbose syntax
 - Swift: Can have functions outside of classes
*/

// MARK: - 7. CLASSES AND OBJECTS

print("\n=== CLASSES AND OBJECTS ===")

// Swift: Clean class definition
class SwiftPerson {
    let name: String        // Property that can't change
    var age: Int           // Property that can change
    
    // Initializer (constructor) - sets up the object
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    // Method
    func introduce() -> String {
        return "Hi, I'm \(name) and I'm \(age) years old"
    }
    
    // Method that changes the object
    func haveBirthday() {
        age += 1
        print("\(name) is now \(age) years old!")
    }
}

let person = SwiftPerson(name: "Emma", age: 28)
print(person.introduce())
person.haveBirthday()

/*
 Objective-C equivalent (.h file):
 @interface Person : NSObject
 @property (nonatomic, strong, readonly) NSString *name;
 @property (nonatomic, assign) NSInteger age;
 - (instancetype)initWithName:(NSString *)name age:(NSInteger)age;
 - (NSString *)introduce;
 - (void)haveBirthday;
 @end
 
 Objective-C equivalent (.m file):
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
     return [NSString stringWithFormat:@"Hi, I'm %@ and I'm %ld years old", self.name, (long)self.age];
 }
 
 - (void)haveBirthday {
     self.age++;
 }
 @end
 
 Key Differences:
 - Swift: Everything in one file, cleaner syntax
 - Swift: Properties and methods in same place
 - Swift: Automatic property creation
 - Objective-C: Separate .h and .m files, more boilerplate code
 - Swift: 'let' properties are truly immutable
 - Swift: init methods are cleaner and safer
*/

// MARK: - 8. INHERITANCE

print("\n=== INHERITANCE ===")

// Swift: Clean inheritance syntax
class Animal {
    let species: String
    
    init(species: String) {
        self.species = species
    }
    
    func makeSound() -> String {
        return "Some animal sound"
    }
}

class Dog: Animal {
    let breed: String
    
    init(breed: String) {
        self.breed = breed
        super.init(species: "Canine")  // Call parent's init
    }
    
    // Override parent method
    override func makeSound() -> String {
        return "Woof! Woof!"
    }
    
    // Add new method
    func wagTail() -> String {
        return "Wagging tail happily!"
    }
}

let myDog = Dog(breed: "Golden Retriever")
print("Species: \(myDog.species)")
print("Breed: \(myDog.breed)")
print("Sound: \(myDog.makeSound())")
print(myDog.wagTail())

/*
 Objective-C equivalent:
 // Animal.h
 @interface Animal : NSObject
 @property (nonatomic, strong, readonly) NSString *species;
 - (instancetype)initWithSpecies:(NSString *)species;
 - (NSString *)makeSound;
 @end
 
 // Dog.h
 @interface Dog : Animal
 @property (nonatomic, strong, readonly) NSString *breed;
 - (instancetype)initWithBreed:(NSString *)breed;
 - (NSString *)wagTail;
 @end
 
 Key Differences:
 - Swift: 'override' keyword makes intent clear and prevents accidents
 - Swift: 'super' calls are cleaner
 - Swift: Single inheritance model (like Objective-C)
 - Swift: Better compile-time checking for method overrides
 - Both support single inheritance from one parent class
*/

// MARK: - 9. PROTOCOLS (Interfaces)

print("\n=== PROTOCOLS ===")

// Swift: Protocol is like a contract - "You must have these methods"
protocol Drawable {
    func draw() -> String
    var area: Double { get }  // Must provide area calculation
}

protocol Colorable {
    var color: String { get set }  // Must have color property
}

// Class can follow multiple protocols (like signing multiple contracts)
class Circle: Drawable, Colorable {
    let radius: Double
    var color: String
    
    init(radius: Double, color: String) {
        self.radius = radius
        self.color = color
    }
    
    func draw() -> String {
        return "Drawing a \(color) circle with radius \(radius)"
    }
    
    var area: Double {
        return Double.pi * radius * radius
    }
}

let circle = Circle(radius: 5.0, color: "Red")
print(circle.draw())
print("Area: \(circle.area)")

/*
 Objective-C equivalent:
 // Drawable.h
 @protocol Drawable <NSObject>
 - (NSString *)draw;
 - (double)area;
 @end
 
 // Circle.h
 @interface Circle : NSObject <Drawable>
 @property (nonatomic, assign) double radius;
 @property (nonatomic, strong) NSString *color;
 @end
 
 Key Differences:
 - Swift: Protocols can require properties and computed properties
 - Swift: Cleaner syntax for protocol conformance
 - Swift: Protocol extensions (can add default implementations)
 - Both: Can conform to multiple protocols
 - Swift: Better compile-time checking for protocol conformance
*/

// MARK: - 10. ENUMS (Better in Swift!)

print("\n=== ENUMS ===")

// Swift: Enums are super powerful!
enum WeatherType {
    case sunny
    case rainy(intensity: Double)  // Can have associated values!
    case cloudy
    case snowy(inches: Int)
    
    // Enums can have methods!
    func description() -> String {
        switch self {
        case .sunny:
            return "It's sunny and beautiful!"
        case .rainy(let intensity):
            return "It's raining with intensity \(intensity)"
        case .cloudy:
            return "It's cloudy today"
        case .snowy(let inches):
            return "It's snowing! \(inches) inches expected"
        }
    }
}

let today = WeatherType.rainy(intensity: 2.5)
print(today.description())

// Using switch with enums (compiler ensures you handle all cases!)
switch today {
case .sunny:
    print("Wear sunglasses!")
case .rainy(let intensity):
    if intensity > 2.0 {
        print("Bring an umbrella!")
    } else {
        print("Light drizzle, you'll be fine")
    }
case .cloudy:
    print("Might rain later")
case .snowy:
    print("Stay warm!")
}

/*
 Objective-C equivalent:
 typedef NS_ENUM(NSInteger, WeatherType) {
     WeatherTypeSunny,
     WeatherTypeRainy,
     WeatherTypeCloudy,
     WeatherTypeSnowy
 };
 
 Key Differences:
 - Swift: Enums can have associated values (store extra data)
 - Swift: Enums can have methods and computed properties
 - Swift: Pattern matching with switch is more powerful
 - Swift: Compiler ensures you handle all cases
 - Objective-C: Just simple integer constants
 - Swift: No need for prefixes (WeatherType.sunny vs WeatherTypeSunny)
*/

// MARK: - 11. STRUCTURES (Swift Special Feature)

print("\n=== STRUCTURES ===")

// Swift: Structs are like lightweight classes
struct Point {
    var x: Double
    var y: Double
    
    // Structs can have methods too!
    func distanceFromOrigin() -> Double {
        return (x * x + y * y).squareRoot()
    }
    
    // Mutating method (can change the struct)
    mutating func moveBy(deltaX: Double, deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var point = Point(x: 3.0, y: 4.0)  // Gets free initializer!
print("Distance from origin: \(point.distanceFromOrigin())")
point.moveBy(deltaX: 1.0, deltaY: 1.0)
print("New position: (\(point.x), \(point.y))")

/*
 Objective-C equivalent:
 // Objective-C doesn't have structs like Swift
 // You'd use a class or C struct, but with limitations
 
 typedef struct {
     double x;
     double y;
 } Point;
 
 Key Differences:
 - Swift: Structs are value types (copied when passed around)
 - Swift: Structs can have methods, properties, and initializers
 - Swift: Automatic memberwise initializers
 - Swift: Copy-on-write optimization
 - Objective-C: Basic C structs without methods
 - Swift: 'mutating' keyword needed to modify struct in methods
*/

// MARK: - 12. MEMORY MANAGEMENT

print("\n=== MEMORY MANAGEMENT ===")

// Swift: Automatic Reference Counting (ARC) - mostly automatic!
class Owner {
    let name: String
    var pet: Pet?
    
    init(name: String) {
        self.name = name
        print("\(name) is created")
    }
    
    deinit {  // Called when object is destroyed
        print("\(name) is destroyed")
    }
}

class Pet {
    let name: String
    weak var owner: Owner?  // 'weak' prevents memory leaks!
    
    init(name: String) {
        self.name = name
        print("Pet \(name) is created")
    }
    
    deinit {
        print("Pet \(name) is destroyed")
    }
}

// Demo - objects get cleaned up automatically
do {
    let john = Owner(name: "John")
    let fluffy = Pet(name: "Fluffy")
    
    john.pet = fluffy
    fluffy.owner = john  // weak reference prevents retain cycle
    
    print("John has pet: \(john.pet?.name ?? "None")")
    print("Fluffy's owner: \(fluffy.owner?.name ?? "None")")
} // Both objects destroyed here automatically!

/*
 Objective-C equivalent:
 // Manual memory management (older) or ARC (newer)
 @property (nonatomic, strong) Pet *pet;
 @property (nonatomic, weak) Owner *owner;  // weak to prevent retain cycles
 
 Key Differences:
 - Swift: ARC is always on, simpler to use
 - Swift: 'weak' and 'unowned' references to break cycles
 - Swift: No manual retain/release calls
 - Objective-C: Had manual memory management (retain/release/autorelease)
 - Both: Need to be careful about retain cycles
 - Swift: Better compile-time warnings about memory issues
*/

// MARK: - 13. ERROR HANDLING

print("\n=== ERROR HANDLING ===")

// Swift: Built-in error handling system
enum NetworkError: Error {
    case noInternet
    case serverDown
    case invalidData(String)
}

// Function that can throw errors
func fetchData(from url: String) throws -> String {
    guard url.starts(with: "https://") else {
        throw NetworkError.invalidData("URL must start with https://")
    }
    
    // Simulate network conditions
    if url.contains("badserver") {
        throw NetworkError.serverDown
    }
    
    return "Data from \(url)"
}

// Handling errors safely
do {
    let data1 = try fetchData(from: "https://goodserver.com")
    print("Success: \(data1)")
    
    let data2 = try fetchData(from: "http://badurl.com")  // This will throw!
    print("This won't print")
    
} catch NetworkError.noInternet {
    print("No internet connection")
} catch NetworkError.serverDown {
    print("Server is down, try again later")
} catch NetworkError.invalidData(let details) {
    print("Invalid data: \(details)")
} catch {
    print("Unknown error: \(error)")
}

// Optional try (converts errors to nil)
let result = try? fetchData(from: "https://maybe.com")
print("Optional result: \(result ?? "Failed")")

/*
 Objective-C equivalent:
 - (NSString *)fetchDataFromURL:(NSString *)url error:(NSError **)error {
     if (![url hasPrefix:@"https://"]) {
         *error = [NSError errorWithDomain:@"NetworkDomain"
                                     code:100
                                 userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL"}];
         return nil;
     }
     return @"Data";
 }
 
 // Using it:
 NSError *error;
 NSString *data = [self fetchDataFromURL:@"http://bad.com" error:&error];
 if (error) {
     NSLog(@"Error: %@", error.localizedDescription);
 }
 
 Key Differences:
 - Swift: Built-in error handling with do-try-catch
 - Swift: Errors are first-class types (can be enums with data)
 - Swift: Compiler enforces error handling
 - Swift: 'try?' for optional error handling
 - Objective-C: Manual error parameter passing
 - Swift: More expressive and safer error handling
*/

// MARK: - 14. CLOSURES vs BLOCKS

print("\n=== CLOSURES vs BLOCKS ===")

// Swift: Closures are like mini-functions you can pass around
let numbers = [1, 2, 3, 4, 5]

// Simple closure
let doubled = numbers.map { $0 * 2 }  // $0 is shorthand for first parameter
print("Doubled: \(doubled)")

// More explicit closure
let filtered = numbers.filter { number in
    return number > 3
}
print("Filtered: \(filtered)")

// Closure as function parameter
func processArray(_ array: [Int], operation: (Int) -> Int) -> [Int] {
    return array.map(operation)
}

let squared = processArray([1, 2, 3]) { $0 * $0 }
print("Squared: \(squared)")

// Escaping closure (lives longer than the function call)
// Fixed version to avoid data race warnings
func delayedOperation(completion: @escaping @Sendable () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        completion()
    }
}

// Alternative modern Swift approach using async/await
func modernDelayedOperation() async {
    try? await Task.sleep(for: .milliseconds(100))
    print("Modern async approach - no data race concerns!")
}

// Safe usage examples
delayedOperation {
    print("This runs after a delay!")
}

// Using the modern async version
Task {
    await modernDelayedOperation()
}

/*
 Objective-C equivalent:
 // Using blocks
 NSArray *numbers = @[@1, @2, @3, @4, @5];
 
 // Map equivalent
 NSMutableArray *doubled = [NSMutableArray array];
 [numbers enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
     [doubled addObject:@([number intValue] * 2)];
 }];
 
 // Block as parameter
 typedef NSNumber* (^OperationBlock)(NSNumber*);
 - (NSArray *)processArray:(NSArray *)array operation:(OperationBlock)operation {
     // Implementation...
 }
 
 Key Differences:
 - Swift: Much cleaner syntax, less verbose
 - Swift: Trailing closure syntax when closure is last parameter
 - Swift: Automatic type inference in most cases
 - Swift: $0, $1, etc. for parameter shorthand
 - Swift: @Sendable closures prevent data races in concurrent code
 - Swift: Modern async/await eliminates many callback patterns
 - Objective-C: Blocks have complex syntax with ^
 - Swift: @escaping keyword for closures that outlive function
 
 Data Race Prevention:
 - @Sendable ensures closure can safely cross concurrency boundaries
 - Modern Swift prefers async/await over callback-based patterns
 - Compiler warns about potential data races in concurrent code
*/

// MARK: - 15. GENERICS (Type-Safe Code Reuse)

print("\n=== GENERICS ===")

// Swift: Generics let you write flexible, reusable code
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var x = 10
var y = 20
print("Before swap: x=\(x), y=\(y)")
swapValues(&x, &y)
print("After swap: x=\(x), y=\(y)")

var name1 = "Alice"
var name2 = "Bob"
print("Before swap: \(name1), \(name2)")
swapValues(&name1, &name2)
print("After swap: \(name1), \(name2)")

// Generic class - like a box that can hold any type
class Box<T> {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func setValue(_ newValue: T) {
        self.value = newValue
    }
    
    func getValue() -> T {
        return value
    }
}

let intBox = Box(42)
print("Int box: \(intBox.getValue())")

let stringBox = Box("Hello Generics!")
print("String box: \(stringBox.getValue())")

/*
 Objective-C equivalent:
 // Objective-C has limited generics (lightweight generics)
 @interface Box<ObjectType> : NSObject
 @property (nonatomic, strong) ObjectType value;
 - (instancetype)initWithValue:(ObjectType)value;
 @end
 
 // But it's not as powerful as Swift's generics
 
 Key Differences:
 - Swift: Full generic system with type constraints
 - Swift: Generics work at compile time (type safety + performance)
 - Swift: Generic functions, classes, structs, enums
 - Objective-C: Limited generics, mainly for collections
 - Swift: Where clauses for complex generic constraints
 - Swift: Associated types in protocols
*/

// MARK: - 16. EXTENSIONS (Adding Powers to Existing Types)

print("\n=== EXTENSIONS ===")

// Swift: Extensions let you add new methods to existing types
extension String {
    func isPalindrome() -> Bool {
        let lowercased = self.lowercased()
        return lowercased == String(lowercased.reversed())
    }
    
    func wordCount() -> Int {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }.count
    }
}

let testString = "racecar"
print("Is '\(testString)' a palindrome? \(testString.isPalindrome())")

let sentence = "Hello world from Swift extensions"
print("Word count: \(sentence.wordCount())")

// Extension with computed property
extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var squared: Int {
        return self * self
    }
}

let number = 7
print("\(number) is even: \(number.isEven)")
print("\(number) squared: \(number.squared)")

/*
 Objective-C equivalent:
 // Categories (similar to extensions)
 @interface NSString (PalindromeCheck)
 - (BOOL)isPalindrome;
 - (NSInteger)wordCount;
 @end
 
 @implementation NSString (PalindromeCheck)
 - (BOOL)isPalindrome {
     // Implementation...
 }
 @end
 
 Key Differences:
 - Swift: Can add computed properties via extensions
 - Swift: Cleaner syntax, no separate files needed
 - Swift: Can add protocol conformance via extensions
 - Objective-C: Categories can't add properties (stored variables)
 - Swift: Can extend any type, including primitives and generics
*/

// MARK: - 17. PROPERTY OBSERVERS (Watching Changes)

print("\n=== PROPERTY OBSERVERS ===")

// Swift: Get notified when properties change
class Temperature {
    var celsius: Double = 0 {
        willSet {  // Called before value changes
            print("Temperature will change from \(celsius)°C to \(newValue)°C")
        }
        didSet {  // Called after value changes
            print("Temperature changed from \(oldValue)°C to \(celsius)°C")
            if celsius > 30 {
                print("🔥 It's getting hot!")
            } else if celsius < 0 {
                print("🧊 Freezing cold!")
            }
        }
    }
    
    var fahrenheit: Double {
        get {
            return celsius * 9/5 + 32
        }
        set {  // Computed property setter
            celsius = (newValue - 32) * 5/9
        }
    }
}

let temp = Temperature()
temp.celsius = 25  // Triggers observers
temp.fahrenheit = 100  // Also triggers celsius observers
print("Final temp: \(temp.celsius)°C / \(temp.fahrenheit)°F")

/*
 Objective-C equivalent:
 // Manual setter override
 - (void)setCelsius:(double)celsius {
     double oldValue = _celsius;
     _celsius = celsius;
     
     // Manual notification
     if (celsius > 30) {
         NSLog(@"It's hot!");
     }
 }
 
 Key Differences:
 - Swift: Built-in property observers (willSet/didSet)
 - Swift: Automatic oldValue and newValue parameters
 - Swift: Computed properties with get/set
 - Objective-C: Manual setter overrides, more verbose
 - Swift: Observers on any property, not just custom setters
*/

// MARK: - 18. ACCESS CONTROL (Who Can Use What)

print("\n=== ACCESS CONTROL ===")

// Swift: Clear access levels
public class PublicClass {           // Anyone can use this
    public var publicVar = "Everyone can see this"
    internal var internalVar = "Only my module can see this"  // Default level
    private var privateVar = "Only this class can see this"
    
    public init() {}
    
    public func publicMethod() -> String {
        return "Public method called"
    }
    
    private func privateMethod() -> String {
        return "Only I can call this method"
    }
    
    public func demonstrateAccess() -> String {
        // This class can access its own private members
        return privateMethod() + " - " + privateVar
    }
}

let instance = PublicClass()
print(instance.publicVar)           // ✅ Works
print(instance.internalVar)         // ✅ Works (same module)
// print(instance.privateVar)       // ❌ Won't compile - private!
print(instance.publicMethod())      // ✅ Works
// instance.privateMethod()         // ❌ Won't compile - private!
print(instance.demonstrateAccess()) // ✅ Works - internal access

/*
 Objective-C equivalent:
 // Less clear access control
 @interface PublicClass : NSObject
 @property (nonatomic, strong) NSString *publicProperty;
 - (NSString *)publicMethod;
 @end
 
 @interface PublicClass ()  // Private extension
 @property (nonatomic, strong) NSString *privateProperty;
 - (NSString *)privateMethod;
 @end
 
 Key Differences:
 - Swift: 5 clear access levels (open, public, internal, fileprivate, private)
 - Swift: Compiler enforces access control
 - Swift: More granular control than Objective-C
 - Objective-C: Mainly public/private via header files
 - Swift: Better encapsulation and module boundaries
*/

// MARK: - 19. MODERN SWIFT FEATURES

print("\n=== MODERN SWIFT FEATURES ===")

// Async/Await (Concurrency made simple)
func fetchUserData() async -> String {
    // Simulate network delay
    try? await Task.sleep(for: .milliseconds(100))
    return "User data loaded"
}

// Using async function
Task {
    let userData = await fetchUserData()
    print("Async result: \(userData)")
}

// Result Builders (SwiftUI magic!)
@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components.joined()
    }
}

func createHTML(@HTMLBuilder content: () -> String) -> String {
    return "<html>\(content())</html>"
}

let html = createHTML {
    "<head><title>Swift</title></head>"
    "<body><h1>Hello World!</h1></body>"
}
print("Generated HTML: \(html)")

// Property Wrappers (Code that writes code!)
@propertyWrapper
struct Capitalized {
    private var value: String = ""
    
    var wrappedValue: String {
        get { value }
        set { value = newValue.capitalized }
    }
}

struct Person {
    @Capitalized var firstName: String
    @Capitalized var lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

let person2 = Person(firstName: "john", lastName: "smith")
print("Name: \(person2.firstName) \(person2.lastName)")  // Automatically capitalized!

/*
 Objective-C equivalent:
 // These modern features don't have direct equivalents
 // You'd need to implement similar functionality manually
 
 Key Differences:
 - Swift: Modern language features for common patterns
 - Swift: Async/await for clean concurrency code
 - Swift: Result builders for DSLs (Domain Specific Languages)
 - Swift: Property wrappers for reusable property logic
 - Objective-C: Would need manual implementation of these patterns
 - Swift: Constantly evolving with new features
*/

// MARK: - 20. PERFORMANCE AND COMPILATION

print("\n=== PERFORMANCE DIFFERENCES ===")

// Swift: Value types vs Reference types performance
struct FastStruct {
    let data: [Int]
    
    func process() -> Int {
        return data.reduce(0, +)
    }
}

class SlowerClass {
    let data: [Int]
    
    init(data: [Int]) {
        self.data = data
    }
    
    func process() -> Int {
        return data.reduce(0, +)
    }
}

let testData = Array(1...1000)
let fastStruct = FastStruct(data: testData)
let slowerClass = SlowerClass(data: testData)

print("Struct result: \(fastStruct.process())")
print("Class result: \(slowerClass.process())")

/*
 Key Performance Differences:
 
 Swift Advantages:
 - Compile-time optimizations
 - Value types (structs) often faster than classes
 - Optional unwrapping optimized away at compile time
 - Generic specialization eliminates runtime type checking
 - ARC optimizations for memory management
 - Whole module optimization
 
 Objective-C Characteristics:
 - Runtime-heavy language (dynamic dispatch)
 - Message sending overhead
 - Boxing/unboxing for primitives in collections
 - Less aggressive compiler optimizations
 - Manual memory management overhead (pre-ARC)
 
 When Swift is Faster:
 - Math-heavy computations
 - Value type operations
 - Type-safe collections
 - Memory-intensive applications
 
 When They're Similar:
 - UI operations (both call same UIKit)
 - File I/O operations
 - Network operations
 - Most real-world app performance
*/

print("\n=== SUMMARY ===")
print("🎉 Swift vs Objective-C Comparison Complete!")
print("Swift offers: Safety, Performance, Readability, Modern Features")
print("Objective-C offers: Maturity, C Compatibility, Dynamic Runtime")
print("Both can work together in the same project! 🤝")

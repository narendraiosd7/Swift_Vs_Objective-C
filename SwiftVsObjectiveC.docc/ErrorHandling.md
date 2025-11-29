# Error Handling

Comparing error handling approaches between Swift and Objective-C.

## Overview

Swift provides a built-in error handling system with try-catch semantics, while Objective-C uses NSError parameters and manual error propagation. Swift's approach is more type-safe and easier to use.

## Basic Error Handling

### Swift: Built-in Error System
```swift
// Define error types
enum NetworkError: Error {
    case noConnection
    case timeout
    case invalidResponse
    case serverError(Int)
    case invalidData(String)
}

enum ValidationError: Error {
    case emptyInput
    case tooShort(minimum: Int)
    case invalidFormat(expected: String)
}

// Function that can throw errors
func validateEmail(_ email: String) throws -> String {
    guard !email.isEmpty else {
        throw ValidationError.emptyInput
    }
    
    guard email.count >= 5 else {
        throw ValidationError.tooShort(minimum: 5)
    }
    
    guard email.contains("@") && email.contains(".") else {
        throw ValidationError.invalidFormat(expected: "user@domain.com")
    }
    
    return email.lowercased()
}

// Handling errors with do-catch
func processEmail(_ input: String) {
    do {
        let validEmail = try validateEmail(input)
        print("Valid email: \(validEmail)")
    } catch ValidationError.emptyInput {
        print("Error: Email cannot be empty")
    } catch ValidationError.tooShort(let minimum) {
        print("Error: Email must be at least \(minimum) characters")
    } catch ValidationError.invalidFormat(let expected) {
        print("Error: Invalid format. Expected: \(expected)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

// Usage
processEmail("")                    // Error: Email cannot be empty
processEmail("ab")                  // Error: Email must be at least 5 characters  
processEmail("invalid")             // Error: Invalid format. Expected: user@domain.com
processEmail("user@example.com")    // Valid email: user@example.com
```

### Objective-C: NSError Parameter Pattern
```objective-c
// Error constants
NSString *const ValidationErrorDomain = @"ValidationErrorDomain";

typedef NS_ENUM(NSInteger, ValidationErrorCode) {
    ValidationErrorEmptyInput = 1001,
    ValidationErrorTooShort = 1002,
    ValidationErrorInvalidFormat = 1003
};

// Function with NSError parameter
- (NSString *)validateEmail:(NSString *)email error:(NSError **)error {
    if (!email || [email length] == 0) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorEmptyInput
                                     userInfo:@{NSLocalizedDescriptionKey: @"Email cannot be empty"}];
        }
        return nil;
    }
    
    if ([email length] < 5) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorTooShort
                                     userInfo:@{NSLocalizedDescriptionKey: @"Email must be at least 5 characters",
                                               @"MinimumLength": @5}];
        }
        return nil;
    }
    
    if (![email containsString:@"@"] || ![email containsString:@"."]) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorInvalidFormat
                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid email format",
                                               @"ExpectedFormat": @"user@domain.com"}];
        }
        return nil;
    }
    
    return [email lowercaseString];
}

// Handling errors manually
- (void)processEmail:(NSString *)input {
    NSError *error;
    NSString *validEmail = [self validateEmail:input error:&error];
    
    if (validEmail) {
        NSLog(@"Valid email: %@", validEmail);
    } else {
        switch (error.code) {
            case ValidationErrorEmptyInput:
                NSLog(@"Error: Email cannot be empty");
                break;
            case ValidationErrorTooShort:
                NSLog(@"Error: Email must be at least %@ characters", 
                      error.userInfo[@"MinimumLength"]);
                break;
            case ValidationErrorInvalidFormat:
                NSLog(@"Error: Invalid format. Expected: %@", 
                      error.userInfo[@"ExpectedFormat"]);
                break;
            default:
                NSLog(@"Unexpected error: %@", error.localizedDescription);
                break;
        }
    }
}
```

## Optional Try Variants

### Swift: Flexible Error Handling Options
```swift
func riskyOperation() throws -> String {
    // Simulate random failure
    if Bool.random() {
        throw NetworkError.timeout
    }
    return "Success!"
}

// Different ways to handle errors
func demonstrateErrorHandling() {
    // 1. Standard try with do-catch
    do {
        let result = try riskyOperation()
        print("Result: \(result)")
    } catch {
        print("Failed: \(error)")
    }
    
    // 2. Optional try (converts error to nil)
    if let result = try? riskyOperation() {
        print("Success: \(result)")
    } else {
        print("Operation failed (no error details)")
    }
    
    // 3. Force try (crashes if error occurs - use carefully!)
    // let result = try! riskyOperation()  // Dangerous!
    
    // 4. nil-coalescing with optional try
    let result = (try? riskyOperation()) ?? "Default value"
    print("Result with fallback: \(result)")
}
```

### Objective-C: Manual Optional Handling
```objective-c
// Must manually decide how to handle errors
- (NSString *)riskyOperation:(NSError **)error {
    if (arc4random_uniform(2)) {
        if (error) {
            *error = [NSError errorWithDomain:@"NetworkDomain"
                                         code:1001
                                     userInfo:@{NSLocalizedDescriptionKey: @"Timeout"}];
        }
        return nil;
    }
    return @"Success!";
}

- (void)demonstrateErrorHandling {
    // Standard error handling
    NSError *error;
    NSString *result = [self riskyOperation:&error];
    if (result) {
        NSLog(@"Result: %@", result);
    } else {
        NSLog(@"Failed: %@", error.localizedDescription);
    }
    
    // "Optional" handling by ignoring errors
    NSString *resultIgnoringErrors = [self riskyOperation:NULL];
    if (resultIgnoringErrors) {
        NSLog(@"Success: %@", resultIgnoringErrors);
    } else {
        NSLog(@"Operation failed (no error details)");
    }
    
    // Fallback value
    NSString *resultWithFallback = [self riskyOperation:NULL] ?: @"Default value";
    NSLog(@"Result with fallback: %@", resultWithFallback);
}
```

## Error Propagation

### Swift: Automatic Error Propagation
```swift
// Errors automatically propagate up the call stack
func parseData(_ data: Data) throws -> [String] {
    // This can throw
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    
    guard let array = json as? [String] else {
        throw ValidationError.invalidFormat(expected: "Array of strings")
    }
    
    return array
}

func processFile(at url: URL) throws -> [String] {
    // Multiple throwing operations
    let data = try Data(contentsOf: url)  // Can throw
    return try parseData(data)            // Can throw
}

func handleFile(at url: URL) {
    do {
        let results = try processFile(at: url)
        print("Processed \(results.count) items")
    } catch {
        print("File processing failed: \(error)")
    }
}
```

### Objective-C: Manual Error Propagation
```objective-c
- (NSArray<NSString *> *)parseData:(NSData *)data error:(NSError **)error {
    NSError *jsonError;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:&jsonError];
    
    if (!json) {
        // Propagate JSON error
        if (error) *error = jsonError;
        return nil;
    }
    
    if (![json isKindOfClass:[NSArray class]]) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorInvalidFormat
                                     userInfo:@{NSLocalizedDescriptionKey: @"Expected array of strings"}];
        }
        return nil;
    }
    
    return (NSArray<NSString *> *)json;
}

- (NSArray<NSString *> *)processFileAtURL:(NSURL *)url error:(NSError **)error {
    NSError *fileError;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&fileError];
    
    if (!data) {
        // Propagate file error
        if (error) *error = fileError;
        return nil;
    }
    
    // Must manually propagate parsing errors
    NSError *parseError;
    NSArray<NSString *> *results = [self parseData:data error:&parseError];
    
    if (!results) {
        if (error) *error = parseError;
        return nil;
    }
    
    return results;
}

- (void)handleFileAtURL:(NSURL *)url {
    NSError *error;
    NSArray<NSString *> *results = [self processFileAtURL:url error:&error];
    
    if (results) {
        NSLog(@"Processed %lu items", (unsigned long)[results count]);
    } else {
        NSLog(@"File processing failed: %@", error.localizedDescription);
    }
}
```

## Result Type Pattern

### Swift: Result Type for Functional Error Handling
```swift
// Result type for functional error handling
enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

func fetchUserData(id: Int) -> Result<User, NetworkError> {
    // Simulate network operation
    if id <= 0 {
        return .failure(.invalidData("User ID must be positive"))
    }
    
    // Simulate random network failure
    if Bool.random() {
        return .failure(.noConnection)
    }
    
    let user = User(id: id, name: "User \(id)")
    return .success(user)
}

// Functional composition with Result
func processUserData(id: Int) -> Result<String, NetworkError> {
    return fetchUserData(id: id)
        .map { user in "Processing user: \(user.name)" }
        .mapError { error in
            // Could transform error here if needed
            return error
        }
}

// Usage
switch processUserData(id: 123) {
case .success(let message):
    print(message)
case .failure(let error):
    print("Error: \(error)")
}
```

### Objective-C: Manual Result Pattern
```objective-c
// Manual result-like pattern using blocks
typedef void(^UserResultBlock)(User * _Nullable user, NSError * _Nullable error);

- (void)fetchUserDataWithID:(NSInteger)userID completion:(UserResultBlock)completion {
    if (userID <= 0) {
        NSError *error = [NSError errorWithDomain:@"NetworkDomain"
                                             code:1001
                                         userInfo:@{NSLocalizedDescriptionKey: @"User ID must be positive"}];
        completion(nil, error);
        return;
    }
    
    // Simulate async operation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), 
                   dispatch_get_main_queue(), ^{
        if (arc4random_uniform(2)) {
            NSError *error = [NSError errorWithDomain:@"NetworkDomain"
                                                 code:1002
                                             userInfo:@{NSLocalizedDescriptionKey: @"No connection"}];
            completion(nil, error);
        } else {
            User *user = [[User alloc] initWithID:userID name:[NSString stringWithFormat:@"User %ld", (long)userID]];
            completion(user, nil);
        }
    });
}

// Usage
[self fetchUserDataWithID:123 completion:^(User *user, NSError *error) {
    if (user) {
        NSLog(@"Processing user: %@", user.name);
    } else {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}];
```

## Error Recovery and Cleanup

### Swift: Defer and Clean Error Recovery
```swift
func processFileWithCleanup(path: String) throws -> String {
    let fileHandle = FileHandle(forReadingAtPath: path)
    
    defer {
        // Always executed, even if error is thrown
        fileHandle?.closeFile()
        print("File closed")
    }
    
    guard let handle = fileHandle else {
        throw ValidationError.invalidFormat(expected: "Valid file path")
    }
    
    let data = handle.readDataToEndOfFile()
    
    guard !data.isEmpty else {
        throw ValidationError.emptyInput
    }
    
    guard let content = String(data: data, encoding: .utf8) else {
        throw ValidationError.invalidFormat(expected: "UTF-8 encoded text")
    }
    
    return content
}

// Multiple defer statements execute in reverse order
func complexOperation() throws {
    defer { print("Cleanup 1") }
    defer { print("Cleanup 2") }
    
    // Do work...
    throw ValidationError.emptyInput
    
    // Output:
    // Cleanup 2
    // Cleanup 1
}
```

### Objective-C: Manual Cleanup
```objective-c
- (NSString *)processFileWithCleanupAtPath:(NSString *)path error:(NSError **)error {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if (!fileHandle) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorInvalidFormat
                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid file path"}];
        }
        return nil;
    }
    
    NSData *data = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];  // Must remember to clean up manually
    
    if ([data length] == 0) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorEmptyInput
                                     userInfo:@{NSLocalizedDescriptionKey: @"File is empty"}];
        }
        return nil;
    }
    
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!content) {
        if (error) {
            *error = [NSError errorWithDomain:ValidationErrorDomain
                                         code:ValidationErrorInvalidFormat
                                     userInfo:@{NSLocalizedDescriptionKey: @"File is not UTF-8 encoded"}];
        }
        return nil;
    }
    
    return content;
}
```

## Key Error Handling Advantages

### Swift Benefits
1. **Type Safety**: Error types are part of the function signature
2. **Forced Handling**: Compiler ensures errors are handled or propagated
3. **Clean Syntax**: try-catch is more readable than NSError parameters
4. **Automatic Propagation**: Errors bubble up automatically
5. **Defer Statement**: Guaranteed cleanup code execution

### Best Practices

#### Swift Error Handling Guidelines
1. **Use specific error types**: Create meaningful error enums
2. **Handle or propagate**: Never silently ignore errors
3. **Use defer for cleanup**: Ensure resources are always released
4. **Consider optional try**: When you don't need error details
5. **Document throwing functions**: Make it clear what errors can be thrown

Swift's error handling system provides a more robust, type-safe, and maintainable approach to error management compared to Objective-C's manual NSError pattern.
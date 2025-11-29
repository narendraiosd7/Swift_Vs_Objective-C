# Modern Swift Features

Exploring Swift's cutting-edge features that have no equivalent in Objective-C.

## Overview

Swift continues to evolve with modern programming language features that enable new patterns and improve code quality. These features represent the future of iOS development and showcase Swift's commitment to innovation.

## Async/Await Concurrency

### Swift: Modern Concurrency Model
```swift
// Async functions
func fetchUserData(id: Int) async throws -> User {
    let url = URL(string: "https://api.example.com/users/\(id)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

func fetchUserPosts(userID: Int) async throws -> [Post] {
    let url = URL(string: "https://api.example.com/users/\(userID)/posts")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Post].self, from: data)
}

// Concurrent execution
func loadUserProfile(id: Int) async throws -> UserProfile {
    // Both requests run concurrently
    async let user = fetchUserData(id: id)
    async let posts = fetchUserPosts(userID: id)
    
    // Wait for both to complete
    let userData = try await user
    let userPosts = try await posts
    
    return UserProfile(user: userData, posts: userPosts)
}

// Task groups for dynamic concurrency
func loadMultipleUsers(ids: [Int]) async throws -> [User] {
    return try await withThrowingTaskGroup(of: User.self) { group in
        // Add tasks to the group
        for id in ids {
            group.addTask {
                try await fetchUserData(id: id)
            }
        }
        
        // Collect results
        var users: [User] = []
        for try await user in group {
            users.append(user)
        }
        return users
    }
}

// Usage in SwiftUI or other contexts
@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    
    func loadUsers() {
        isLoading = true
        
        Task {
            do {
                let userIDs = [1, 2, 3, 4, 5]
                self.users = try await loadMultipleUsers(ids: userIDs)
            } catch {
                print("Failed to load users: \(error)")
            }
            
            self.isLoading = false
        }
    }
}
```

### Objective-C: Traditional Callback Pattern
```objective-c
// Traditional completion handler pattern
- (void)fetchUserDataWithID:(NSInteger)userID 
                 completion:(void(^)(User * _Nullable user, NSError * _Nullable error))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.example.com/users/%ld", (long)userID]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Manual JSON parsing...
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

// Nested callbacks for sequential operations
- (void)loadUserProfileWithID:(NSInteger)userID 
                   completion:(void(^)(UserProfile * _Nullable profile, NSError * _Nullable error))completion {
    
    [self fetchUserDataWithID:userID completion:^(User *user, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        [self fetchUserPostsWithUserID:userID completion:^(NSArray<Post *> *posts, NSError *postsError) {
            if (postsError) {
                completion(nil, postsError);
                return;
            }
            
            UserProfile *profile = [[UserProfile alloc] initWithUser:user posts:posts];
            completion(profile, nil);
        }];
    }];
}
```

## Property Wrappers

### Swift: Reusable Property Logic
```swift
// Custom property wrapper
@propertyWrapper
struct Capitalized {
    private var value: String = ""
    
    var wrappedValue: String {
        get { value }
        set { value = newValue.capitalized }
    }
}

@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = max(range.lowerBound, min(range.upperBound, wrappedValue))
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = max(range.lowerBound, min(range.upperBound, newValue)) }
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// Using property wrappers
struct User {
    @Capitalized var firstName: String
    @Capitalized var lastName: String
    @Clamped(0...100) var age: Int
}

class AppSettings {
    @UserDefault(key: "username", defaultValue: "")
    var username: String
    
    @UserDefault(key: "theme", defaultValue: "light")
    var theme: String
    
    @UserDefault(key: "notifications", defaultValue: true)
    var notificationsEnabled: Bool
}

// Usage
var user = User(firstName: "john", lastName: "doe", age: 25)
print("\(user.firstName) \(user.lastName)")  // "John Doe"

user.age = 150  // Automatically clamped to 100
print(user.age)  // 100

let settings = AppSettings()
settings.username = "alice"  // Automatically saved to UserDefaults
```

### Objective-C: Manual Property Management
```objective-c
// Must manually implement property logic
@interface User : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) NSInteger age;
@end

@implementation User

- (void)setFirstName:(NSString *)firstName {
    _firstName = [firstName capitalizedString];
}

- (void)setLastName:(NSString *)lastName {
    _lastName = [lastName capitalizedString];
}

- (void)setAge:(NSInteger)age {
    _age = MAX(0, MIN(100, age));  // Manual clamping
}

@end

// UserDefaults wrapper
@interface AppSettings : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, assign) BOOL notificationsEnabled;
@end

@implementation AppSettings

- (NSString *)username {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"username"] ?: @"";
}

- (void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
}

// Repeat for each property...

@end
```

## Result Builders

### Swift: Domain-Specific Languages
```swift
// Result builder for creating HTML
@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components.joined()
    }
    
    static func buildOptional(_ component: String?) -> String {
        return component ?? ""
    }
    
    static func buildEither(first component: String) -> String {
        return component
    }
    
    static func buildEither(second component: String) -> String {
        return component
    }
}

// HTML DSL
func html(@HTMLBuilder content: () -> String) -> String {
    return "<html>\(content())</html>"
}

func body(@HTMLBuilder content: () -> String) -> String {
    return "<body>\(content())</body>"
}

func h1(_ text: String) -> String {
    return "<h1>\(text)</h1>"
}

func p(_ text: String) -> String {
    return "<p>\(text)</p>"
}

func div(@HTMLBuilder content: () -> String) -> String {
    return "<div>\(content())</div>"
}

// Usage - reads like HTML structure
let webpage = html {
    body {
        h1("Welcome to Swift")
        div {
            p("This is a paragraph.")
            p("This is another paragraph.")
        }
    }
}

print(webpage)
// <html><body><h1>Welcome to Swift</h1><div><p>This is a paragraph.</p><p>This is another paragraph.</p></div></body></html>

// Result builder for math expressions
@resultBuilder
struct MathBuilder {
    static func buildBlock(_ numbers: Double...) -> Double {
        return numbers.reduce(0, +)
    }
}

func calculate(@MathBuilder expression: () -> Double) -> Double {
    return expression()
}

let result = calculate {
    10.5
    20.3
    5.2
}  // 36.0
```

### Objective-C: Manual String Building
```objective-c
// Must manually build strings
- (NSString *)createHTML {
    NSMutableString *html = [NSMutableString stringWithString:@"<html>"];
    [html appendString:@"<body>"];
    [html appendString:@"<h1>Welcome to Objective-C</h1>"];
    [html appendString:@"<div>"];
    [html appendString:@"<p>This is a paragraph.</p>"];
    [html appendString:@"<p>This is another paragraph.</p>"];
    [html appendString:@"</div>"];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    return [html copy];
}
```

## SwiftUI Integration

### Swift: Declarative UI with Modern Features
```swift
import SwiftUI

// Property wrappers for state management
struct ContentView: View {
    @State private var username = ""
    @State private var isLoading = false
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Load Profile") {
                    loadProfile()
                }
                .disabled(username.isEmpty || isLoading)
                
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    List(viewModel.users, id: \.id) { user in
                        UserRow(user: user)
                    }
                }
            }
            .padding()
            .navigationTitle("Users")
        }
    }
    
    // Async function in SwiftUI
    private func loadProfile() {
        isLoading = true
        
        Task {
            await viewModel.loadUsers()
            isLoading = false
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
            }
            .frame(width: 50, height: 50)
            .cornerRadius(25)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
```

### Objective-C: UIKit with Callbacks
```objective-c
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) NSArray<User *> *users;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.usernameField addTarget:self
                           action:@selector(textFieldChanged:)
                 forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)loadButtonTapped:(id)sender {
    [self loadProfile];
}

- (void)loadProfile {
    [self.loadingIndicator startAnimating];
    self.loadButton.enabled = NO;
    
    // Manual callback handling
    [self fetchUsersWithCompletion:^(NSArray<User *> *users, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingIndicator stopAnimating];
            self.loadButton.enabled = YES;
            
            if (users) {
                self.users = users;
                [self.tableView reloadData];
            } else {
                // Handle error
                [self showErrorAlert:error];
            }
        });
    }];
}

- (void)textFieldChanged:(UITextField *)textField {
    self.loadButton.enabled = textField.text.length > 0;
}

// TableView delegate methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Manual cell configuration...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    User *user = self.users[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.email;
    return cell;
}

@end
```

## Structured Concurrency

### Swift: Actor Model and Safe Concurrency
```swift
// Actor for thread-safe state management
actor UserCache {
    private var cache: [Int: User] = [:]
    
    func getUser(id: Int) -> User? {
        return cache[id]
    }
    
    func setUser(_ user: User) {
        cache[user.id] = user
    }
    
    func clearCache() {
        cache.removeAll()
    }
}

// Global actors for UI updates
@MainActor
class UIManager {
    static let shared = UIManager()
    
    func updateUI() {
        // Always runs on main thread
        print("Updating UI on main thread")
    }
}

// Custom actor for API management
actor APIManager {
    private let session = URLSession.shared
    private var activeRequests: Set<URL> = []
    
    func fetchData(from url: URL) async throws -> Data {
        // Prevent duplicate requests
        guard !activeRequests.contains(url) else {
            throw APIError.requestInProgress
        }
        
        activeRequests.insert(url)
        defer { activeRequests.remove(url) }
        
        let (data, _) = try await session.data(from: url)
        return data
    }
}

// Usage with proper isolation
func loadAndDisplayUser(id: Int) async {
    let cache = UserCache()
    let apiManager = APIManager()
    
    // Check cache first
    if let cachedUser = await cache.getUser(id: id) {
        await UIManager.shared.updateUI()
        return
    }
    
    // Fetch from API
    do {
        let url = URL(string: "https://api.example.com/users/\(id)")!
        let data = try await apiManager.fetchData(from: url)
        let user = try JSONDecoder().decode(User.self, from: data)
        
        await cache.setUser(user)
        await UIManager.shared.updateUI()
    } catch {
        print("Failed to load user: \(error)")
    }
}
```

## Key Modern Features Summary

### Swift's Cutting-Edge Capabilities
1. **Async/Await**: Modern concurrency without callback hell
2. **Property Wrappers**: Reusable property behavior
3. **Result Builders**: Domain-specific language creation
4. **Actors**: Safe concurrent programming
5. **Structured Concurrency**: Predictable async code execution
6. **SwiftUI Integration**: Declarative UI with modern patterns

### Migration Strategy
When adopting modern Swift features:

1. **Start with async/await**: Replace completion handlers gradually
2. **Identify repeated patterns**: Create property wrappers for common logic
3. **Use actors for shared state**: Replace locks and queues
4. **Embrace SwiftUI**: For new UI development
5. **Create DSLs with result builders**: For complex configuration patterns

These modern Swift features represent the future of iOS development, offering safer, more expressive, and more maintainable code patterns that simply aren't possible in Objective-C.
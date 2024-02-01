# NetworkLayer
Generic network library for service model protocol, handling networking commons errors.

```swift
public typealias Headers = [String: String]

public protocol NetworkService {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: Headers? { get }
}
```

Built with URLSession and Codable.

Tested with Quick, Nimble and Dependency Injection of test doubles.

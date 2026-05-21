# PersistState 🚀

**PersistState** is a lightweight Swift library that leverages the power of **Swift Macros** to eliminate `UserDefaults` boilerplate code. With a single attribute, you can persist variables across app launches with full type safety and `Codable` support.

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS-blue.svg)](https://apple.com)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- ✅ **One-line Persistence:** Just add `@Persisted` to your properties.
- ✅ **Type Safety:** Automatically infers types from your property declarations.
- ✅ **Codable Support:** Persist complex structs or classes seamlessly using JSON encoding.
- ✅ **Clean Code:** Reduces boilerplate code in your ViewModels or Settings managers.
- ✅ **Modern:** Built using the latest Swift Macro system (Swift 5.9+).

## 📸 Usage

### Before (The Standard Way)
```swift
var username: String {
    get {
        UserDefaults.standard.string(forKey: "username") ?? "Guest"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "username")
    }
}

After (With PersistState)

@Persisted var username: String = "Guest"
@Persisted var score: Int = 10
@Persisted var isPremium: Bool = false

// Even works with complex Codable types!
@Persisted var userProfile: UserProfile = .defaultProfile 

📦 Installation

Swift Package Manager (SPM)

Add the following URL to your Xcode project's package dependencies:

https://github.com/irmakcenker/PersistState

1.  In Xcode, go to File -> Add Packages...
2.  Paste the URL above into the search bar.
3.  Select PersistState and click Add Package.

🛠 How It Works

PersistState uses an @attached(accessor) macro. During compilation, it generates
a custom getter and setter for your property. It automatically:

1.  Detects the variable name to use as a unique UserDefaults key.
2.  Handles reading and casting to the correct type.
3.  Uses JSONEncoder and JSONDecoder automatically if the type is complex,
    ensuring your objects are stored correctly as Data.

🧪 Testing

The library is fully covered by unit tests using SwiftSyntaxMacrosTestSupport to
ensure the macro expansion generates the correct and safe Swift code.

To run tests:

  - Open the package in Xcode.
  - Press Cmd + U.

📄 License

This project is licensed under the MIT License - see the LICENSE file for
details.

Developed with ❤️ by irmakcenker

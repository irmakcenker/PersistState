import Foundation

/// A property macro that automatically persists a value to `UserDefaults`.
///
/// Use this macro to eliminate boilerplate code for reading and writing to `UserDefaults`.
/// It automatically uses the variable name as the key and handles both primitive types
/// and `Codable` objects.
///
/// ### Example:
/// ```swift
/// @Persisted var username: String = "Guest"
/// @Persisted var highscore: Int = 0
/// ```
///
/// - Important: The variable must have an initial value to determine the default value.
///
@attached(accessor)
public macro Persisted() = #externalMacro(module: "PersistStateMacros", type: "PersistedMacro")

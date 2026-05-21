import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Error types thrown during the compilation phase of the `@Persisted` macro.
enum PersistedError: Error, CustomStringConvertible {
    /// Thrown when the macro is applied to something other than a variable (e.g., a class or function).
    case onlyApplicableToVariables
    
    /// A localized description of the error.
    var description: String {
        switch self {
        case .onlyApplicableToVariables:
            return "@Persisted can only be applied to variables (properties)."
        }
    }
}

/// The implementation engine for the `@Persisted` macro.
///
/// It conforms to `AccessorMacro` to generate `get` and `set` blocks for the targeted property.
public struct PersistedMacro: AccessorMacro {
    
    /// Expands the `@Persisted` macro into getter and setter accessors.
    ///
    /// This function performs the following steps:
    /// 1. Validates that the declaration is a variable.
    /// 2. Extracts the variable name to use as a `UserDefaults` key.
    /// 3. Injects logic to handle `JSONEncoder`/`JSONDecoder` for `Codable` support.
    ///
    /// - Parameters:
    ///   - node: The attribute syntax representing the macro call.
    ///   - declaration: The declaration (variable) the macro is attached to.
    ///   - context: The macro expansion context for error reporting.
    /// - Returns: A list of accessors (get and set) for the property.
    /// - Throws: `PersistedError.onlyApplicableToVariables` if validation fails.
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            throw PersistedError.onlyApplicableToVariables
        }

        let key = identifier
        let type = binding.typeAnnotation?.type.description ?? "Any"
        let defaultValue = binding.initializer?.value.description ?? "nil"

        // Implementation of getter
        let getAccessor: AccessorDeclSyntax = """
        get {
            let key = "\(raw: key)"
            let defaultValue = \(raw: defaultValue)
            if let data = UserDefaults.standard.data(forKey: key) {
                if let decoded = try? JSONDecoder().decode(\(raw: type).self, from: data) {
                    return decoded
                }
            }
            return UserDefaults.standard.object(forKey: key) as? \(raw: type) ?? defaultValue
        }
        """

        // Implementation of setter
        let setAccessor: AccessorDeclSyntax = """
        set {
            let key = "\(raw: key)"
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
        """

        return [getAccessor, setAccessor]
    }
}

/// The entry point for the Swift Macro plugin.
@main
struct PersistStatePlugin: CompilerPlugin {
    /// The list of macros provided by this compiler plugin.
    let providingMacros: [Macro.Type] = [
        PersistedMacro.self
    ]
}

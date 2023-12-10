import SwiftSyntax
import SwiftSyntaxMacros

public enum AccessAssociatedValueMacro: MemberMacro {
    /// Access Associated Value Macro Error
    public enum AccessAssociatedValueError: Error {
        /// Not Found Enum Case Element Syntax
        case notFoundEnumCaseElementSyntax
        /// Could Not Parse Type Syntax
        case couldNotParseTypeSyntaxError
    }
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        return try declaration.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .map { $0.elements }
            .map {
                guard let element = $0.first else { throw AccessAssociatedValueError.notFoundEnumCaseElementSyntax }
                let caseName = element.name.text
                
                guard let parameterClause = element.parameterClause else {
                    return makeComputedProperty(caseName: caseName, associatedValues: [])
                }
                
                let associatedValues: [AssociatedValue] = try parameterClause.parameters.map {
                    let identifier = $0.firstName?.text
                    var parser = TypeSyntaxParser(typeSyntax: $0.type)
                    guard let type = parser.run() else {
                        throw AccessAssociatedValueError.couldNotParseTypeSyntaxError
                    }
                    return AssociatedValue(identifier: identifier, type: type)
                }
                
                return makeComputedProperty(caseName: caseName, associatedValues: associatedValues)
            }
    }

    private static func makeComputedProperty(caseName: String, associatedValues: [AssociatedValue]) -> SwiftSyntax.DeclSyntax {
        if associatedValues.isEmpty {
            return """
            var \(raw: caseName): Bool {
                guard case .\(raw: caseName) = self else {
                    return false
                }
                return true
            }
            """
        } else if associatedValues.count == 1 {
            let type = associatedValues.map { $0.type }.joined()
            let identifier = associatedValues.map { $0.identifier ?? "value" }.joined()
            return """
            var \(raw: caseName): \(raw: type)? {
                guard case let .\(raw: caseName)(\(raw: identifier)) = self else {
                    return nil
                }
                return \(raw: identifier)
            }
            """
        } else {
            let type = associatedValues
                .map {
                    guard let identifier = $0.identifier else {
                        return $0.type
                    }
                    return "\(identifier): \($0.type)"
                }
                .joined(separator: ",")
            
            let identifiers = associatedValues
                .enumerated()
                .map {
                    $0.element.identifier ?? "value\($0.offset)"
                }
                .joined(separator: ",")
            
            return """
            var \(raw: caseName): (\(raw: type))? {
                guard case let .\(raw: caseName)(\(raw: identifiers)) = self else {
                    return nil
                }
                return (\(raw: identifiers))
            }
            """
        }
    }
}

extension AccessAssociatedValueMacro {
    private struct AssociatedValue {
        var identifier: String?
        var type: String
    }
}





public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

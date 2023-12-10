import Foundation
import SwiftSyntax

public struct TypeSyntaxParser {
    private var typeSyntax: TypeSyntaxProtocol
    private var tokens: [String] = []
    
    public init(typeSyntax: TypeSyntaxProtocol) {
        self.typeSyntax = typeSyntax
    }
    
    public mutating func run() -> String? {
        classifyTypeSyntax(typeSyntax: typeSyntax)
        return tokens.joined()
    }
    
    private mutating func classifyTypeSyntax(typeSyntax: TypeSyntaxProtocol) {
        if let identifier = getIdentifier(typeSyntax: typeSyntax) {
            tokens.append(identifier)
            return
        }
         
        if let arrayType = getArrayType(typeSyntax: typeSyntax) {
            tokens.append(arrayType.leftSquare)
            classifyTypeSyntax(typeSyntax: arrayType.element)
            tokens.append(arrayType.rightSquare)
            return
        }
        
        if let dictionaryType = getDictionaryType(typeSyntax: typeSyntax) {
            tokens.append(dictionaryType.leftSquare)
            classifyTypeSyntax(typeSyntax: dictionaryType.key)
            tokens.append(dictionaryType.colon)
            classifyTypeSyntax(typeSyntax: dictionaryType.value)
            tokens.append(dictionaryType.rightSquare)
        }
        
        if let tupleType = getTupleType(typeSyntax: typeSyntax) {
            tokens.append(tupleType.leftParen)
            classifyTupleTypeElementListSyntax(tupleTypeElementListSyntax: tupleType.elements)
            tokens.append(tupleType.rightParen)
        }
    }
    
    private mutating func classifyTupleTypeElementListSyntax(tupleTypeElementListSyntax: TupleTypeElementListSyntax) {
        tupleTypeElementListSyntax.map {
            if let firstName = $0.firstName {
                tokens.append(firstName.text)
            }
            if let colon = $0.colon {
                tokens.append(colon.text)
            }
            classifyTypeSyntax(typeSyntax: $0.type)
            if let trailingComma = $0.trailingComma {
                tokens.append(trailingComma.text)
            }
        }
        
    }
    
    private func getIdentifier(typeSyntax: TypeSyntaxProtocol) -> String? {
        guard let identifierTypeSyntax = typeSyntax.as(IdentifierTypeSyntax.self) else { return nil }
        return identifierTypeSyntax.name.text
    }
    
    private func getArrayType(typeSyntax: TypeSyntaxProtocol) -> ArrayType? {
        guard let arrayTypeSyntax = typeSyntax.as(ArrayTypeSyntax.self) else { return nil }
        return ArrayType(leftSquare: arrayTypeSyntax.leftSquare.text, element: arrayTypeSyntax.element, rightSquare: arrayTypeSyntax.rightSquare.text)
    }
    
    private func getDictionaryType(typeSyntax: TypeSyntaxProtocol) -> DictionaryType? {
        guard let dictionaryTypeSyntax = typeSyntax.as(DictionaryTypeSyntax.self) else { return nil }
        return DictionaryType(
            leftSquare: dictionaryTypeSyntax.leftSquare.text,
            key: dictionaryTypeSyntax.key,
            colon: dictionaryTypeSyntax.colon.text,
            value: dictionaryTypeSyntax.value,
            rightSquare: dictionaryTypeSyntax.rightSquare.text
        )
    }
    
    private func getTupleType(typeSyntax: TypeSyntaxProtocol) -> TupleType? {
        guard let tupleTypeSyntax = typeSyntax.as(TupleTypeSyntax.self) else { return nil }
        return TupleType(leftParen: tupleTypeSyntax.leftParen.text, elements: tupleTypeSyntax.elements, rightParen: tupleTypeSyntax.rightParen.text)
    }
}

private extension TypeSyntaxParser {
    struct ArrayType {
        var leftSquare: String
        var element: TypeSyntaxProtocol
        var rightSquare: String
    }
    
    struct TupleType {
        var leftParen: String
        var elements: TupleTypeElementListSyntax
        var rightParen: String
    }
    
    struct DictionaryType {
        var leftSquare: String
        var key: TypeSyntaxProtocol
        var colon: String
        var value: TypeSyntaxProtocol
        var rightSquare: String
    }
}


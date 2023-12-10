import XCTest
@testable import AccessAssociatedValueMacros
import SwiftSyntax

final class ASTrunTests: XCTestCase {
    
    private let leftSquare: TokenSyntax = .init(stringLiteral: "[")
    private let rightSquare: TokenSyntax = .init(stringLiteral: "]")
    private let leftParen: TokenSyntax = .init(stringLiteral: "(")
    private let rightParen: TokenSyntax = .init(stringLiteral: ")")
    private let colon: TokenSyntax = .init(stringLiteral: ":")
    private let trailingComma: TokenSyntax = .init(stringLiteral: ",")

    private let boolType: IdentifierTypeSyntax = .init(name: "Bool")
    private let stringType: IdentifierTypeSyntax = .init(name: "String")
    
    private let v1Identifier: TokenSyntax = .init(stringLiteral: "v1")
    private let v2Identifier: TokenSyntax = .init(stringLiteral: "v2")
    
    func testIdentifierTypeSyntax() throws {
        var typeSyntaxParser = TypeSyntaxParser(typeSyntax: boolType)
        
        XCTAssertEqual(typeSyntaxParser.run(), "Bool")
    }
    
    func testArrayTypeSyntax() throws {
        let arrayTypeSyntax = ArrayTypeSyntax(leadingTrivia: nil, nil, leftSquare: leftSquare, nil, element: stringType, nil, rightSquare: rightSquare, nil, trailingTrivia: nil)
        var typeSyntaxParser = TypeSyntaxParser(typeSyntax: arrayTypeSyntax)
        
        XCTAssertEqual(typeSyntaxParser.run(), "[String]")
    }
    
    func testDictionaryTypeSyntax() throws {
        let dictionaryTypeSyntax = DictionaryTypeSyntax(leadingTrivia: nil, nil, leftSquare: leftSquare, nil, key: stringType, nil, colon: colon, nil, value: boolType, nil, rightSquare: rightSquare, nil, trailingTrivia: nil)
        var typeSyntaxParser = TypeSyntaxParser(typeSyntax: dictionaryTypeSyntax)
        
        XCTAssertEqual(typeSyntaxParser.run(), "[String:Bool]")
    }
    
    func testTupleTypeSyntax() throws {
        let tupleTypeSyntax = TupleTypeSyntax(elements: .init(itemsBuilder: {
            TupleTypeElementSyntax(leadingTrivia: nil, nil, inoutKeyword: nil, nil, firstName: nil, nil, secondName: nil, nil, colon: nil, nil, type: boolType, nil, ellipsis: nil, nil, trailingComma: nil, nil, trailingTrivia: nil)
        }))
        var typeSyntaxParser = TypeSyntaxParser(typeSyntax: tupleTypeSyntax)
        
        XCTAssertEqual(typeSyntaxParser.run(), "(Bool)")
    }
    
    func testTupleTypeSyntaxWithLabel() throws {
        let tupleTypeSyntax = TupleTypeSyntax(elements: .init(itemsBuilder: {
            TupleTypeElementSyntax(leadingTrivia: nil, nil, inoutKeyword: nil, nil, firstName: v1Identifier, nil, secondName: nil, nil, colon: colon, nil, type: boolType, nil, ellipsis: nil, nil, trailingComma: trailingComma, nil, trailingTrivia: nil)
            TupleTypeElementSyntax(leadingTrivia: nil, nil, inoutKeyword: nil, nil, firstName: v2Identifier, nil, secondName: nil, nil, colon: colon, nil, type: boolType, nil, ellipsis: nil, nil, trailingComma: nil, nil, trailingTrivia: nil)
        }))
        var typeSyntaxParser = TypeSyntaxParser(typeSyntax: tupleTypeSyntax)
        
        XCTAssertEqual(typeSyntaxParser.run(), "(v1:Bool,v2:Bool)")
    }
    
    func testTupleTypeSyntaxWith3Items() throws {
        let tupleTypeSyntax = TupleTypeSyntax(elements: .init(itemsBuilder: {
            TupleTypeElementSyntax(leadingTrivia: nil, nil, inoutKeyword: nil, nil, firstName: v1Identifier, nil, secondName: nil, nil, colon: colon, nil, type: boolType, nil, ellipsis: nil, nil, trailingComma: trailingComma, nil, trailingTrivia: nil)
            TupleTypeElementSyntax(leadingTrivia: nil, nil, inoutKeyword: nil, nil, firstName: v2Identifier, nil, secondName: nil, nil, colon: colon, nil, type: boolType, nil, ellipsis: nil, nil, trailingComma: trailingComma, nil, trailingTrivia: nil)
            TupleTypeElementSyntax(leadingTrivia: nil, nil, inoutKeyword: nil, nil, firstName: nil, nil, secondName: nil, nil, colon: nil, nil, type: boolType, nil, ellipsis: nil, nil, trailingComma: nil, nil, trailingTrivia: nil)
            
        }))
        var typeSyntaxParser = TypeSyntaxParser(typeSyntax: tupleTypeSyntax)
        
        XCTAssertEqual(typeSyntaxParser.run(), "(v1:Bool,v2:Bool,Bool)")
    }
    
    func testTupleTypeSyntaxWithTuple() throws {
        // FIXME: need to implemented test
    }
}

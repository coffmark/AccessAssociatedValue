import Foundation
import XCTest
import MacroTesting
import SwiftSyntaxMacros
import AccessAssociatedValueMacros

final class AccessAssociatedValueTests: XCTestCase {
    
    private let testMacros: [String: Macro.Type] = ["AccessAssociatedValue": AccessAssociatedValueMacro.self]
    
    func testAccessAssociatedValue() {
        assertMacro(testMacros, record: false) {
            """
            @AccessAssociatedValue
            enum ViewState {
                case initialLoading
                case loading(hasIndicator: Bool)
                case loaded(cards: [String], hasIndicator: Bool)
            }
            """
        } expansion: {
            """
            enum ViewState {
                case initialLoading
                case loading(hasIndicator: Bool)
                case loaded(cards: [String], hasIndicator: Bool)

                var initialLoading: Bool {
                    guard case .initialLoading = self else {
                        return false
                    }
                    return true
                }

                var loading: Bool? {
                    guard case let .loading(hasIndicator) = self else {
                        return nil
                    }
                    return hasIndicator
                }

                var loaded: (cards: [String], hasIndicator: Bool)? {
                    guard case let .loaded(cards, hasIndicator) = self else {
                        return nil
                    }
                    return (cards, hasIndicator)
                }
            }
            """
        }
    }
    
    func testAccessAssociatedValueWithoutLabels() {
        assertMacro(testMacros, record: false) {
            """
            @AccessAssociatedValue
            enum ViewState {
                case loading0
                case loading1(Bool)
                case loading2(Bool, Bool)
                case loading3((Bool, Bool), Bool)
                case loading4((Bool, Bool, (Bool, Bool)), Bool, (Bool, Bool))
            }
            """
        } expansion: {
            """
            enum ViewState {
                case loading0
                case loading1(Bool)
                case loading2(Bool, Bool)
                case loading3((Bool, Bool), Bool)
                case loading4((Bool, Bool, (Bool, Bool)), Bool, (Bool, Bool))
            
                var loading0: Bool {
                    guard case .loading0 = self else {
                        return false
                    }
                    return true
                }
            
                var loading1: Bool? {
                    guard case let .loading1(value) = self else {
                        return nil
                    }
                    return value
                }
            
                var loading2: (Bool, Bool)? {
                    guard case let .loading2(value0, value1) = self else {
                        return nil
                    }
                    return (value0, value1)
                }
            
                var loading3: ((Bool, Bool), Bool)? {
                    guard case let .loading3(value0, value1) = self else {
                        return nil
                    }
                    return (value0, value1)
                }
            
                var loading4: ((Bool, Bool, (Bool, Bool)), Bool, (Bool, Bool))? {
                    guard case let .loading4(value0, value1, value2) = self else {
                        return nil
                    }
                    return (value0, value1, value2)
                }
            }
            """
        }
    }
    
    func testAccessAssociatedValueWithLabels() {
        // case loaded(cards: [String], isIndicator: Bool)
        // case loaded(cards: [String], isIndicator: Bool, hasError: Bool)
        assertMacro(testMacros, record: false) {
            """
            @AccessAssociatedValue
            enum ViewState {
                case loading0(hasIndicator: (v1: String, v2: Bool))
                case loading1(cards: [String], isIndicator: Bool, hasError: Bool)
                case loading2(isIndicator: ((v1: Bool, v2: Bool), Bool))
            }
            """
        } expansion: {
            """
            enum ViewState {
                case loading0(hasIndicator: (v1: String, v2: Bool))
                case loading1(cards: [String], isIndicator: Bool, hasError: Bool)
                case loading2(isIndicator: ((v1: Bool, v2: Bool), Bool))
            
                var loading0: (v1: String, v2: Bool)? {
                    guard case let .loading0(hasIndicator) = self else {
                        return nil
                    }
                    return hasIndicator
                }

                var loading1: (cards: [String], isIndicator: Bool, hasError: Bool)? {
                    guard case let .loading1(cards, isIndicator, hasError) = self else {
                        return nil
                    }
                    return (cards, isIndicator, hasError)
                }

                var loading2: ((v1: Bool, v2: Bool), Bool)? {
                    guard case let .loading2(isIndicator) = self else {
                        return nil
                    }
                    return isIndicator
                }
            }
            """
        }
    }
}

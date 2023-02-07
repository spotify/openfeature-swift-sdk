import Foundation

public protocol BaseEvaluation {
    associatedtype ValueType
    var value: ValueType { get }
    var variant: String? { get }
    var reason: String? { get }
    var errorCode: ErrorCode? { get }
    var errorMessage: String? { get }
}

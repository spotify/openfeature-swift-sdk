import Foundation

public protocol EvaluationContext: Structure {
    func getTargetingKey() -> String

    func setTargetingKey(targetingKey: String)
}

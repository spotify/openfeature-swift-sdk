import Foundation

public struct HookContext<T> {
    var flagKey: String
    var type: FlagValueType
    var defaultValue: T
    var ctx: EvaluationContext
    var clientMetadata: Metadata?
    var providerMetadata: Metadata?
}

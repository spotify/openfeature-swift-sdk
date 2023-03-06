import Foundation

public struct HookContext<T> {
    var flagKey: String
    var type: FlagValueType
    var defaultValue: T
    var clientMetadata: Metadata?
    var providerMetadata: Metadata?
}

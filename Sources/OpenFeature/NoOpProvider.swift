import Foundation

class NoOpProvider: FeatureProvider {
    public static let passedInDefault = "Passed in default"

    var metadata: Metadata = NoOpMetadata(name: "No-op provider")
    var hooks: [AnyHook] = []

    func onContextSet(oldContext: EvaluationContext, newContext: EvaluationContext) {
        // no-op
    }

    func initialize(initialContext: EvaluationContext) {
        // no-op
    }

    func getBooleanEvaluation(key: String, defaultValue: Bool) throws -> ProviderEvaluation<
        Bool
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getStringEvaluation(key: String, defaultValue: String) throws -> ProviderEvaluation<
        String
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getIntegerEvaluation(key: String, defaultValue: Int64) throws -> ProviderEvaluation<
        Int64
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getDoubleEvaluation(key: String, defaultValue: Double) throws -> ProviderEvaluation<
        Double
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getObjectEvaluation(key: String, defaultValue: Value) throws -> ProviderEvaluation<
        Value
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }
}

extension NoOpProvider {
    struct NoOpMetadata: Metadata {
        var name: String?
    }
}

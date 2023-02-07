import Foundation

class NoOpProvider: FeatureProvider {
    public static let passedInDefault = "Passed in default"

    var metadata: Metadata = NoOpMetadata(name: "No-op provider")
    var hooks: [AnyHook] = []

    func getBooleanEvaluation(key: String, defaultValue: Bool, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Bool
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getStringEvaluation(key: String, defaultValue: String, ctx: EvaluationContext) throws -> ProviderEvaluation<
        String
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getIntegerEvaluation(key: String, defaultValue: Int64, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Int64
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getDoubleEvaluation(key: String, defaultValue: Double, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Double
    > {
        return ProviderEvaluation(
            value: defaultValue, variant: NoOpProvider.passedInDefault, reason: Reason.defaultReason.rawValue)
    }

    func getObjectEvaluation(key: String, defaultValue: Value, ctx: EvaluationContext) throws -> ProviderEvaluation<
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

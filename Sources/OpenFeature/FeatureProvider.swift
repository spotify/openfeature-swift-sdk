import Foundation

/// The interface implemented by upstream flag providers to resolve flags for their service.
public protocol FeatureProvider {
    var hooks: [AnyHook] { get }
    var metadata: Metadata { get }

    func getBooleanEvaluation(key: String, defaultValue: Bool, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Bool
    >
    func getStringEvaluation(key: String, defaultValue: String, ctx: EvaluationContext) throws -> ProviderEvaluation<
        String
    >
    func getIntegerEvaluation(key: String, defaultValue: Int64, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Int64
    >
    func getDoubleEvaluation(key: String, defaultValue: Double, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Double
    >
    func getObjectEvaluation(key: String, defaultValue: Value, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Value
    >
}

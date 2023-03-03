import Foundation

/// The interface implemented by upstream flag providers to resolve flags for their service.
public protocol FeatureProvider {
    var hooks: [AnyHook] { get }
    var metadata: Metadata { get }

    // Called by OpenFeatureAPI whenever the new Provider is registered
    func initialize(initialContext: EvaluationContext)

    // Called by OpenFeatureAPI whenever a new EvaluationContext is set by the application
    // TODO Should this be Async?
    func onContextSet(oldContext: EvaluationContext, newContext: EvaluationContext)

    func getBooleanEvaluation(key: String, defaultValue: Bool) throws -> ProviderEvaluation<
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

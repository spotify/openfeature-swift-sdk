import Foundation
import OpenFeature

class DoSomethingProvider: FeatureProvider {
    public static let name = "Something"

    func onContextSet(oldContext: OpenFeature.EvaluationContext, newContext: OpenFeature.EvaluationContext) {
        // no-op
    }

    func initialize(initialContext: OpenFeature.EvaluationContext) {
        // no-op
    }

    var hooks: [OpenFeature.AnyHook] = []
    var metadata: OpenFeature.Metadata = DoMetadata()

    func getBooleanEvaluation(key: String, defaultValue: Bool) throws -> ProviderEvaluation<
        Bool
    > {
        return ProviderEvaluation(value: !defaultValue)
    }

    func getStringEvaluation(key: String, defaultValue: String, ctx: EvaluationContext) throws -> ProviderEvaluation<
        String
    > {
        return ProviderEvaluation(value: String(defaultValue.reversed()))
    }

    func getIntegerEvaluation(key: String, defaultValue: Int64, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Int64
    > {
        return ProviderEvaluation(value: defaultValue * 100)
    }

    func getDoubleEvaluation(key: String, defaultValue: Double, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Double
    > {
        return ProviderEvaluation(value: defaultValue * 100)
    }

    func getObjectEvaluation(key: String, defaultValue: Value, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Value
    > {
        return ProviderEvaluation(value: .null)
    }

    public struct DoMetadata: Metadata {
        public var name: String? = DoSomethingProvider.name
    }
}

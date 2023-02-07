import Foundation
import OpenFeature

class DoSomethingProvider: FeatureProvider {
    public static let name = "Something"
    private var savedContext: EvaluationContext?
    var mergedContext: EvaluationContext? {
        savedContext
    }

    var hooks: [OpenFeature.AnyHook] = []
    var metadata: OpenFeature.Metadata = DoMetadata()

    func getBooleanEvaluation(key: String, defaultValue: Bool, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Bool
    > {
        savedContext = ctx
        return ProviderEvaluation(value: !defaultValue)
    }

    func getStringEvaluation(key: String, defaultValue: String, ctx: EvaluationContext) throws -> ProviderEvaluation<
        String
    > {
        savedContext = ctx
        return ProviderEvaluation(value: String(defaultValue.reversed()))
    }

    func getIntegerEvaluation(key: String, defaultValue: Int64, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Int64
    > {
        savedContext = ctx
        return ProviderEvaluation(value: defaultValue * 100)
    }

    func getDoubleEvaluation(key: String, defaultValue: Double, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Double
    > {
        savedContext = ctx
        return ProviderEvaluation(value: defaultValue * 100)
    }

    func getObjectEvaluation(key: String, defaultValue: Value, ctx: EvaluationContext) throws -> ProviderEvaluation<
        Value
    > {
        savedContext = ctx
        return ProviderEvaluation(value: .null)
    }

    public struct DoMetadata: Metadata {
        public var name: String? = DoSomethingProvider.name
    }
}

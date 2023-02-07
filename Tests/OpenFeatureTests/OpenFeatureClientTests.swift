import Foundation
import XCTest

@testable import OpenFeature

final class OpenFeatureClientTests: XCTestCase {
    func testShouldNowThrowIfHookHasDifferentTypeArgument() {
        OpenFeatureAPI.shared.provider = DoSomethingProvider()
        OpenFeatureAPI.shared.addHooks(hooks: .boolean(BooleanHookMock()))

        let client = OpenFeatureAPI.shared.getClient()

        let details = client.getStringDetails(key: "key", defaultValue: "test")

        XCTAssertEqual(details.value, "tset")
    }

    func testMergeContexts() {
        let targetingKey = "targetingKey"
        OpenFeatureAPI.shared.provider = TestProvider(targetingKey: targetingKey)
        let ctx = MutableContext(targetingKey: targetingKey)

        var client = OpenFeatureAPI.shared.getClient()
        client.evaluationContext = ctx

        let details = client.getBooleanDetails(key: "flag", defaultValue: false)

        XCTAssertEqual(details.value, true)
    }
}

extension OpenFeatureClientTests {
    class BooleanHookMock: BooleanHook {
        var numCalls = 0
        public func finallyAfter(ctx: HookContext<Bool>, hints: [String: Any]) {
            numCalls += 1
        }
    }

    class TestProvider: FeatureProvider {
        var hooks: [OpenFeature.AnyHook] = []

        var metadata: OpenFeature.Metadata = TestMetadata()
        private var targetingKey: String

        init(targetingKey: String) {
            self.targetingKey = targetingKey
        }

        func getBooleanEvaluation(key: String, defaultValue: Bool, ctx: OpenFeature.EvaluationContext) throws
            -> OpenFeature.ProviderEvaluation<Bool>
        {
            if ctx.getTargetingKey() == self.targetingKey {
                return ProviderEvaluation(value: true)
            } else {
                return ProviderEvaluation(value: false)
            }
        }

        func getStringEvaluation(key: String, defaultValue: String, ctx: OpenFeature.EvaluationContext) throws
            -> OpenFeature.ProviderEvaluation<String>
        {
            return ProviderEvaluation(value: "")
        }

        func getIntegerEvaluation(key: String, defaultValue: Int64, ctx: OpenFeature.EvaluationContext) throws
            -> OpenFeature.ProviderEvaluation<Int64>
        {
            return ProviderEvaluation(value: 0)
        }

        func getDoubleEvaluation(key: String, defaultValue: Double, ctx: OpenFeature.EvaluationContext) throws
            -> OpenFeature.ProviderEvaluation<Double>
        {
            return ProviderEvaluation(value: 0.0)
        }

        func getObjectEvaluation(key: String, defaultValue: OpenFeature.Value, ctx: OpenFeature.EvaluationContext)
            throws -> OpenFeature.ProviderEvaluation<OpenFeature.Value>
        {
            return ProviderEvaluation(value: .null)
        }
    }

    public struct TestMetadata: Metadata {
        public var name: String? = "test"
    }
}

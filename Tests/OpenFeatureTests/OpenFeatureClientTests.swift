import Foundation
import XCTest

@testable import OpenFeature

final class OpenFeatureClientTests: XCTestCase {
    func testShouldNowThrowIfHookHasDifferentTypeArgument() {
        OpenFeatureAPI.shared.setProvider(provider: DoSomethingProvider())
        OpenFeatureAPI.shared.addHooks(hooks: .boolean(BooleanHookMock()))

        let client = OpenFeatureAPI.shared.getClient()

        let details = client.getStringDetails(key: "key", defaultValue: "test")

        XCTAssertEqual(details.value, "tset")
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

        func onContextSet(oldContext: OpenFeature.EvaluationContext, newContext: OpenFeature.EvaluationContext) {
            // no-op
        }

        func initialize(initialContext: OpenFeature.EvaluationContext) {
            // no-op
        }

        init(targetingKey: String) {
            self.targetingKey = targetingKey
        }

        func getBooleanEvaluation(key: String, defaultValue: Bool) throws
            -> OpenFeature.ProviderEvaluation<Bool>
        {
            return ProviderEvaluation(value: true)

        }

        func getStringEvaluation(key: String, defaultValue: String) throws
            -> OpenFeature.ProviderEvaluation<String>
        {
            return ProviderEvaluation(value: "")
        }

        func getIntegerEvaluation(key: String, defaultValue: Int64) throws
            -> OpenFeature.ProviderEvaluation<Int64>
        {
            return ProviderEvaluation(value: 0)
        }

        func getDoubleEvaluation(key: String, defaultValue: Double) throws
            -> OpenFeature.ProviderEvaluation<Double>
        {
            return ProviderEvaluation(value: 0.0)
        }

        func getObjectEvaluation(key: String, defaultValue: OpenFeature.Value)
            throws -> OpenFeature.ProviderEvaluation<OpenFeature.Value>
        {
            return ProviderEvaluation(value: .null)
        }
    }

    public struct TestMetadata: Metadata {
        public var name: String? = "test"
    }
}

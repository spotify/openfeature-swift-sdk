import XCTest

@testable import OpenFeature

final class DeveloperExperienceTests: XCTestCase {
    func testNoProviderSet() {
        OpenFeatureAPI.shared.provider = nil
        let client = OpenFeatureAPI.shared.getClient()

        let flagValue = client.getStringValue(key: "test", defaultValue: "no-op")
        XCTAssertEqual(flagValue, "no-op")
    }

    func testSimpleBooleanFlag() {
        OpenFeatureAPI.shared.provider = NoOpProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let flagValue = client.getBooleanValue(key: "test", defaultValue: false)
        XCTAssertFalse(flagValue)
    }

    func testClientHooks() {
        OpenFeatureAPI.shared.provider = NoOpProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()
        client.addHooks(.boolean(hook))

        _ = client.getBooleanValue(key: "test", defaultValue: false)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testEvalHooks() {
        OpenFeatureAPI.shared.provider = NoOpProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()
        let options = FlagEvaluationOptions(hooks: [.boolean(hook)])
        _ = client.getBooleanValue(key: "test", defaultValue: false, ctx: nil, options: options)

        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testProvidingContext() {
        let provider = NoOpProviderMock()
        OpenFeatureAPI.shared.provider = provider
        let client = OpenFeatureAPI.shared.getClient()

        let ctx = MutableContext()
            .add(key: "int-val", value: .integer(3))
            .add(key: "double-val", value: .double(4.0))
            .add(key: "bool-val", value: .boolean(false))
            .add(key: "str-val", value: .string("test"))
            .add(key: "value-val", value: .list([.integer(2), .integer(4)]))

        _ = client.getBooleanValue(key: "test", defaultValue: false, ctx: ctx)

        XCTAssertEqual(ctx.asMap(), provider.ctxWhenCalled?.asMap())
    }

    func testBrokenProvider() {
        OpenFeatureAPI.shared.provider = AlwaysBrokenProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let details = client.getBooleanDetails(key: "test", defaultValue: false)

        XCTAssertEqual(details.errorCode, .flagNotFound)
        XCTAssertEqual(details.errorMessage, "Could not find flag for key: test")
        XCTAssertEqual(details.reason, Reason.error.rawValue)
    }
}

extension DeveloperExperienceTests {
    class NoOpProviderMock: NoOpProvider {
        var ctxWhenCalled: EvaluationContext?

        override func getBooleanEvaluation(key: String, defaultValue: Bool, ctx: EvaluationContext) throws
            -> ProviderEvaluation<Bool>
        {
            self.ctxWhenCalled = ctx

            return try super.getBooleanEvaluation(key: key, defaultValue: defaultValue, ctx: ctx)
        }
    }
}

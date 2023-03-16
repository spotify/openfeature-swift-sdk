import XCTest

@testable import OpenFeature

final class DeveloperExperienceTests: XCTestCase {
    func testNoProviderSet() {
        OpenFeatureAPI.shared.clearProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let flagValue = client.getStringValue(key: "test", defaultValue: "no-op")
        XCTAssertEqual(flagValue, "no-op")
    }

    func testSimpleBooleanFlag() async {
        await OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())
        let client = OpenFeatureAPI.shared.getClient()

        let flagValue = client.getBooleanValue(key: "test", defaultValue: false)
        XCTAssertFalse(flagValue)
    }

    func testClientHooks() async {
        await OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()
        client.addHooks(.boolean(hook))

        _ = client.getBooleanValue(key: "test", defaultValue: false)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testEvalHooks() async {
        await OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()
        let options = FlagEvaluationOptions(hooks: [.boolean(hook)])
        _ = client.getBooleanValue(key: "test", defaultValue: false, options: options)

        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testBrokenProvider() async {
        await OpenFeatureAPI.shared.setProvider(provider: AlwaysBrokenProvider())
        let client = OpenFeatureAPI.shared.getClient()

        let details = client.getBooleanDetails(key: "test", defaultValue: false)

        XCTAssertEqual(details.errorCode, .flagNotFound)
        XCTAssertEqual(details.errorMessage, "Could not find flag for key: test")
        XCTAssertEqual(details.reason, Reason.error.rawValue)
    }
}

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

        let booleanHook = BooleanHookMock()
        let intHook = IntHookMock()
        client.addHooks(booleanHook, intHook)

        _ = client.getStringValue(key: "string-test", defaultValue: "test")
        XCTAssertEqual(booleanHook.finallyAfterCalled, 0)
        XCTAssertEqual(intHook.finallyAfterCalled, 0)

        _ = client.getBooleanValue(key: "bool-test", defaultValue: false)
        XCTAssertEqual(booleanHook.finallyAfterCalled, 1)
        XCTAssertEqual(intHook.finallyAfterCalled, 0)

        _ = client.getIntegerValue(key: "int-test", defaultValue: 0)
        XCTAssertEqual(booleanHook.finallyAfterCalled, 1)
        XCTAssertEqual(intHook.finallyAfterCalled, 1)
    }

    func testEvalHooks() async {
        await OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())
        let client = OpenFeatureAPI.shared.getClient()

        let booleanHook = BooleanHookMock()
        let intHook = IntHookMock()
        let options = FlagEvaluationOptions(hooks: [booleanHook, intHook])

        _ = client.getStringValue(key: "test", defaultValue: "test", options: options)
        XCTAssertEqual(booleanHook.finallyAfterCalled, 0)
        XCTAssertEqual(intHook.finallyAfterCalled, 0)

        _ = client.getBooleanValue(key: "test", defaultValue: false, options: options)
        XCTAssertEqual(booleanHook.finallyAfterCalled, 1)
        XCTAssertEqual(intHook.finallyAfterCalled, 0)

        _ = client.getIntegerValue(key: "test", defaultValue: 0, options: options)
        XCTAssertEqual(booleanHook.finallyAfterCalled, 1)
        XCTAssertEqual(intHook.finallyAfterCalled, 1)
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

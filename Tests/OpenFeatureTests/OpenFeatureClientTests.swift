import Foundation
import XCTest

@testable import OpenFeature

final class OpenFeatureClientTests: XCTestCase {
    func testShouldNowThrowIfHookHasDifferentTypeArgument() async {
        await OpenFeatureAPI.shared.setProvider(provider: DoSomethingProvider())
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
}

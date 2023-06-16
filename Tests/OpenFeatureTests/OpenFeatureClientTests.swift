import Foundation
import XCTest

@testable import OpenFeature

final class OpenFeatureClientTests: XCTestCase {
    func testShouldNowThrowIfHookHasDifferentTypeArgument() async {
        await OpenFeatureAPI.shared.setProvider(provider: DoSomethingProvider())
        OpenFeatureAPI.shared.addHooks(hooks: BooleanHookMock())

        let client = OpenFeatureAPI.shared.getClient()

        let details = client.getDetails(key: "key", defaultValue: "test")

        XCTAssertEqual(details.value, "tset")
    }
}

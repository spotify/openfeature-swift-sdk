import Foundation
import OpenFeature
import XCTest

final class ProviderEventsTests: XCTestCase {
    func testReadyEventEmitted() {
        let provider = DoSomethingProvider()

        OpenFeatureAPI.shared.addHandler(
            observer: self, selector: #selector(readyEventEmitted(notification:)), event: .ready
        )

        OpenFeatureAPI.shared.setProvider(provider: provider)
        wait(for: [readyExpectation], timeout: 5)
    }

    // MARK: Handlers
    let readyExpectation = XCTestExpectation(description: "Ready")

    func readyEventEmitted(notification: NSNotification) {
        readyExpectation.fulfill()
    }
}

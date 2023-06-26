import Foundation
import XCTest

@testable import OpenFeature

final class HookSpecTests: XCTestCase {
    func testNoErrorHookCalled() async {
        await OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()

        let feo = FlagEvaluationOptions(hooks: [hook])

        _ = client.getValue(
            key: "key",
            defaultValue: false,
            options: feo)

        XCTAssertEqual(hook.beforeCalled, 1)
        XCTAssertEqual(hook.afterCalled, 1)
        XCTAssertEqual(hook.errorCalled, 0)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testErrorHookButNoAfterCalled() async {
        await OpenFeatureAPI.shared.setProvider(provider: AlwaysBrokenProvider())
        let client = OpenFeatureAPI.shared.getClient()
        let hook = BooleanHookMock()

        _ = client.getValue(
            key: "key",
            defaultValue: false,
            options: FlagEvaluationOptions(hooks: [hook]))

        XCTAssertEqual(hook.beforeCalled, 1)
        XCTAssertEqual(hook.afterCalled, 0)
        XCTAssertEqual(hook.errorCalled, 1)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testHookEvaluationOrder() async {
        var evalOrder: [String] = []
        let addEval: (String) -> Void = { eval in
            evalOrder.append(eval)
        }

        let providerMock = NoOpProviderMock(hooks: [
            BooleanHookMock(prefix: "provider", addEval: addEval)
        ])
        await OpenFeatureAPI.shared.setProvider(provider: providerMock)
        OpenFeatureAPI.shared.addHooks(hooks: BooleanHookMock(prefix: "api", addEval: addEval))
        let client = OpenFeatureAPI.shared.getClient()
        client.addHooks(BooleanHookMock(prefix: "client", addEval: addEval))
        let flagOptions = FlagEvaluationOptions(hooks: [
            BooleanHookMock(prefix: "invocation", addEval: addEval)
        ])

        _ = client.getValue(key: "key", defaultValue: false, options: flagOptions)

        XCTAssertEqual(
            evalOrder,
            [
                "api before",
                "client before",
                "invocation before",
                "provider before",
                "provider after",
                "invocation after",
                "client after",
                "api after",
                "provider finallyAfter",
                "invocation finallyAfter",
                "client finallyAfter",
                "api finallyAfter",
            ])
    }
}

extension HookSpecTests {
    class NoOpProviderMock: NoOpProvider {
        init(hooks: [any Hook]) {
            super.init()
            self.hooks.append(contentsOf: hooks)
        }
    }
}

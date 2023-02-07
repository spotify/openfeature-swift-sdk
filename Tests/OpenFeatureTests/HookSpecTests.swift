import Foundation
import XCTest

@testable import OpenFeature

final class HookSpecTests: XCTestCase {
    func testNoErrorHookCalled() {
        OpenFeatureAPI.shared.provider = NoOpProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()

        _ = client.getBooleanValue(
            key: "key",
            defaultValue: false,
            ctx: MutableContext(),
            options: FlagEvaluationOptions(hooks: [.boolean(hook)]))

        XCTAssertEqual(hook.beforeCalled, 1)
        XCTAssertEqual(hook.afterCalled, 1)
        XCTAssertEqual(hook.errorCalled, 0)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testErrorHookButNoAfterCalled() {
        OpenFeatureAPI.shared.provider = AlwaysBrokenProvider()
        let client = OpenFeatureAPI.shared.getClient()

        let hook = BooleanHookMock()

        _ = client.getBooleanValue(
            key: "key",
            defaultValue: false,
            ctx: MutableContext(),
            options: FlagEvaluationOptions(hooks: [.boolean(hook)]))

        XCTAssertEqual(hook.beforeCalled, 1)
        XCTAssertEqual(hook.afterCalled, 0)
        XCTAssertEqual(hook.errorCalled, 1)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
    }

    func testHookEvaluationOrder() {
        var evalOrder: [String] = []
        let addEval: (String) -> Void = { eval in
            evalOrder.append(eval)
        }

        OpenFeatureAPI.shared.provider = NoOpProviderMock(hooks: [
            .boolean(BooleanHookMock(prefix: "provider", addEval: addEval))
        ])
        OpenFeatureAPI.shared.addHooks(hooks: .boolean(BooleanHookMock(prefix: "api", addEval: addEval)))
        let client = OpenFeatureAPI.shared.getClient()
        client.addHooks(.boolean(BooleanHookMock(prefix: "client", addEval: addEval)))
        let flagOptions = FlagEvaluationOptions(hooks: [
            .boolean(BooleanHookMock(prefix: "invocation", addEval: addEval))
        ])

        _ = client.getBooleanValue(key: "key", defaultValue: false, ctx: MutableContext(), options: flagOptions)

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
        init(hooks: [AnyHook]) {
            super.init()
            self.hooks.append(contentsOf: hooks)
        }
    }
}

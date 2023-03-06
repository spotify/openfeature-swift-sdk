import Foundation
import XCTest

@testable import OpenFeature

final class HookSupportTests: XCTestCase {
    func testShouldAlwaysCallGenericHook() throws {
        let metadata = OpenFeatureAPI.shared.getClient().metadata
        let hook = BooleanHookMock()
        let boolHook: AnyHook = .boolean(hook)
        let hookContext: HookContext<Bool> = HookContext(
            flagKey: "flagKey",
            type: .boolean,
            defaultValue: false,
            clientMetadata: metadata,
            providerMetadata: NoOpProvider().metadata)

        let hookSupport = HookSupport()

        hookSupport.beforeHooks(
            flagValueType: .boolean,
            hookCtx: hookContext,
            hooks: [boolHook],
            hints: [:])
        try hookSupport.afterHooks(
            flagValueType: .boolean,
            hookCtx: hookContext,
            details: FlagEvaluationDetails(flagKey: "", value: false),
            hooks: [boolHook],
            hints: [:])
        hookSupport.afterAllHooks(
            flagValueType: .boolean,
            hookCtx: hookContext,
            hooks: [boolHook],
            hints: [:])
        hookSupport.errorHooks(
            flagValueType: .boolean,
            hookCtx: hookContext,
            error: OpenFeatureError.invalidContextError,
            hooks: [boolHook],
            hints: [:])

        XCTAssertEqual(hook.beforeCalled, 1)
        XCTAssertEqual(hook.afterCalled, 1)
        XCTAssertEqual(hook.finallyAfterCalled, 1)
        XCTAssertEqual(hook.errorCalled, 1)
    }
}
extension HookSupportTests {
    class StringHookMock: StringHook {
        private var value: EvaluationContext

        init(key: String, value: String) {
            let ctx = MutableContext()
            ctx.add(key: key, value: .string(value))
            self.value = ctx
        }

        public func before(ctx: HookContext<String>, hints: [String: Any]) -> EvaluationContext? {
            return value
        }
    }
}

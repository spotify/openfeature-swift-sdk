import Foundation
import XCTest

@testable import OpenFeature

final class HookSupportTests: XCTestCase {
    func testShouldMergeEvaluationContextsOnBeforeHooks() {
        let metadata = OpenFeatureAPI.shared.getClient().metadata
        let baseContext = MutableContext()
        baseContext.add(key: "baseKey", value: .string("baseValue"))

        let hook1: AnyHook = .string(StringHookMock(key: "bla", value: "blubber"))
        let hook2: AnyHook = .string(StringHookMock(key: "foo", value: "bar"))

        let hookSupport = HookSupport()
        let hookContext: HookContext<String> = HookContext(
            flagKey: "flagKey",
            type: .string,
            defaultValue: "defaultValue",
            ctx: baseContext,
            clientMetadata: metadata,
            providerMetadata: NoOpProvider().metadata)

        let result = hookSupport.beforeHooks(
            flagValueType: .string, hookCtx: hookContext, hooks: [hook1, hook2], hints: [:])

        XCTAssertEqual(result.getValue(key: "bla")?.asString(), "blubber")
        XCTAssertEqual(result.getValue(key: "foo")?.asString(), "bar")
        XCTAssertEqual(result.getValue(key: "baseKey")?.asString(), "baseValue")
    }

    func testShouldAlwaysCallGenericHook() throws {
        let metadata = OpenFeatureAPI.shared.getClient().metadata
        let hook = BooleanHookMock()
        let boolHook: AnyHook = .boolean(hook)
        let hookContext: HookContext<Bool> = HookContext(
            flagKey: "flagKey",
            type: .boolean,
            defaultValue: false,
            ctx: MutableContext(),
            clientMetadata: metadata,
            providerMetadata: NoOpProvider().metadata)

        let hookSupport = HookSupport()

        _ = hookSupport.beforeHooks(
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

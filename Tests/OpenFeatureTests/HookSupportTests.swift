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
            ctx: MutableContext(),
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

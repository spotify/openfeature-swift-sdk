import Foundation

public protocol Hook {
    associatedtype HookValue: AllowedFlagValueType

    func before<HookValue>(ctx: HookContext<HookValue>, hints: [String: Any])

    func after<HookValue>(ctx: HookContext<HookValue>, details: FlagEvaluationDetails<HookValue>, hints: [String: Any])

    func error<HookValue>(ctx: HookContext<HookValue>, error: Error, hints: [String: Any])

    func finallyAfter<HookValue>(ctx: HookContext<HookValue>, hints: [String: Any])

    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool
}

extension Hook {
    public func before<HookValue>(ctx: HookContext<HookValue>, hints: [String: Any]) {
        // Default implementation
    }

    public func after<HookValue>(ctx: HookContext<HookValue>, details: FlagEvaluationDetails<HookValue>, hints: [String: Any]) {
        // Default implementation
    }

    public func error<HookValue>(ctx: HookContext<HookValue>, error: Error, hints: [String: Any]) {
        // Default implementation
    }

    public func finallyAfter<HookValue>(ctx: HookContext<HookValue>, hints: [String: Any]) {
        // Default implementation
    }

    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        // Default implementation
        return HookValue.flagValueType == flagValueType
    }
}

import Foundation

public protocol Hook {
    associatedtype HookValue: Equatable

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
        return true
    }
}

extension Hook where HookValue == Bool {
    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .boolean
    }
}

extension Hook where HookValue == String {
    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .string
    }
}

extension Hook where HookValue == Int64 {
    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .integer
    }
}

extension Hook where HookValue == Double {
    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .double
    }
}

extension Hook where HookValue == Value {
    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .object
    }
}

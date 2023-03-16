import Foundation

public protocol Hook {
    associatedtype HookValue: Equatable

    func before(ctx: HookContext<HookValue>, hints: [String: Any])

    func after(ctx: HookContext<HookValue>, details: FlagEvaluationDetails<HookValue>, hints: [String: Any])

    func error(ctx: HookContext<HookValue>, error: Error, hints: [String: Any])

    func finallyAfter(ctx: HookContext<HookValue>, hints: [String: Any])

    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool
}

extension Hook {
    func before(ctx: HookContext<HookValue>, hints: [String: Any]) {
    }

    func after(ctx: HookContext<HookValue>, details: FlagEvaluationDetails<HookValue>, hints: [String: Any]) {
    }

    func error(ctx: HookContext<HookValue>, error: Error, hints: [String: Any]) {
    }

    func finallyAfter(ctx: HookContext<HookValue>, hints: [String: Any]) {
    }

    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return true
    }
}

public protocol BooleanHook: Hook where HookValue == Bool {}
extension BooleanHook {
    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .boolean
    }
}

public protocol StringHook: Hook where HookValue == String {}
extension StringHook {
    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .string
    }
}

public protocol IntegerHook: Hook where HookValue == Int64 {}
extension IntegerHook {
    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .integer
    }
}

public protocol DoubleHook: Hook where HookValue == Double {}
extension DoubleHook {
    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .double
    }
}

public protocol ObjectHook: Hook where HookValue == Value {}
extension ObjectHook {
    func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        return flagValueType == .object
    }
}

public enum AnyHook {
    case boolean(any BooleanHook)
    case string(any StringHook)
    case integer(any IntegerHook)
    case double(any DoubleHook)
    case object(any ObjectHook)

    public func supportsFlagValueType(flagValueType: FlagValueType) -> Bool {
        switch self {
        case .boolean(let booleanHook):
            return booleanHook.supportsFlagValueType(flagValueType: flagValueType)
        case .string(let stringHook):
            return stringHook.supportsFlagValueType(flagValueType: flagValueType)
        case .integer(let integerHook):
            return integerHook.supportsFlagValueType(flagValueType: flagValueType)
        case .double(let doubleHook):
            return doubleHook.supportsFlagValueType(flagValueType: flagValueType)
        case .object(let objectHook):
            return objectHook.supportsFlagValueType(flagValueType: flagValueType)
        }
    }
}

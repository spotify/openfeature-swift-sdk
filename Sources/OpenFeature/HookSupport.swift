import Foundation
import os

class HookSupport {
    var logger = Logger()
    func errorHooks<T>(
        flagValueType: FlagValueType, hookCtx: HookContext<T>, error: Error, hooks: [AnyHook], hints: [String: Any]
    ) {
        hooks
            .filter { hook in hook.supportsFlagValueType(flagValueType: flagValueType) }
            .forEach { hook in
                switch hook {
                case .boolean(let booleanHook):
                    if let booleanCtx = hookCtx as? HookContext<Bool> {
                        booleanHook.error(ctx: booleanCtx, error: error, hints: hints)
                    }
                case .integer(let integerHook):
                    if let integerCtx = hookCtx as? HookContext<Int64> {
                        integerHook.error(ctx: integerCtx, error: error, hints: hints)
                    }
                case .double(let doubleHook):
                    if let doubleCtx = hookCtx as? HookContext<Double> {
                        doubleHook.error(ctx: doubleCtx, error: error, hints: hints)
                    }
                case .string(let stringHook):
                    if let stringCtx = hookCtx as? HookContext<String> {
                        stringHook.error(ctx: stringCtx, error: error, hints: hints)
                    }
                case .object(let objectHook):
                    if let objectCtx = hookCtx as? HookContext<Value> {
                        objectHook.error(ctx: objectCtx, error: error, hints: hints)
                    }
                }
            }
    }

    func afterAllHooks<T>(flagValueType: FlagValueType, hookCtx: HookContext<T>, hooks: [AnyHook], hints: [String: Any])
    {
        hooks
            .filter { hook in hook.supportsFlagValueType(flagValueType: flagValueType) }
            .forEach { hook in
                switch hook {
                case .boolean(let booleanHook):
                    if let booleanCtx = hookCtx as? HookContext<Bool> {
                        booleanHook.finallyAfter(ctx: booleanCtx, hints: hints)
                    }
                case .integer(let integerHook):
                    if let integerCtx = hookCtx as? HookContext<Int64> {
                        integerHook.finallyAfter(ctx: integerCtx, hints: hints)
                    }
                case .double(let doubleHook):
                    if let doubleCtx = hookCtx as? HookContext<Double> {
                        doubleHook.finallyAfter(ctx: doubleCtx, hints: hints)
                    }
                case .string(let stringHook):
                    if let stringCtx = hookCtx as? HookContext<String> {
                        stringHook.finallyAfter(ctx: stringCtx, hints: hints)
                    }
                case .object(let objectHook):
                    if let objectCtx = hookCtx as? HookContext<Value> {
                        objectHook.finallyAfter(ctx: objectCtx, hints: hints)
                    }
                }
            }
    }

    func afterHooks<T>(
        flagValueType: FlagValueType,
        hookCtx: HookContext<T>,
        details: FlagEvaluationDetails<T>,
        hooks: [AnyHook],
        hints: [String: Any]
    ) throws {
        hooks
            .filter { hook in hook.supportsFlagValueType(flagValueType: flagValueType) }
            .forEach { hook in
                switch hook {
                case .boolean(let booleanHook):
                    if let booleanCtx = hookCtx as? HookContext<Bool>,
                        let booleanDetails = details as? FlagEvaluationDetails<Bool>
                    {
                        booleanHook.after(ctx: booleanCtx, details: booleanDetails, hints: hints)
                    }
                case .integer(let integerHook):
                    if let integerCtx = hookCtx as? HookContext<Int64>,
                        let integerDetails = details as? FlagEvaluationDetails<Int64>
                    {
                        integerHook.after(ctx: integerCtx, details: integerDetails, hints: hints)
                    }
                case .double(let doubleHook):
                    if let doubleCtx = hookCtx as? HookContext<Double>,
                        let doubleDetails = details as? FlagEvaluationDetails<Double>
                    {
                        doubleHook.after(ctx: doubleCtx, details: doubleDetails, hints: hints)
                    }
                case .string(let stringHook):
                    if let stringCtx = hookCtx as? HookContext<String>,
                        let stringDetails = details as? FlagEvaluationDetails<String>
                    {
                        stringHook.after(ctx: stringCtx, details: stringDetails, hints: hints)
                    }
                case .object(let objectHook):
                    if let objectCtx = hookCtx as? HookContext<Value>,
                       let objectDetails = details as? FlagEvaluationDetails<Value>
                    {
                        objectHook.after(ctx: objectCtx, details: objectDetails, hints: hints)
                    }
                }
            }
    }

    func beforeHooks<T>(flagValueType: FlagValueType, hookCtx: HookContext<T>, hooks: [AnyHook], hints: [String: Any])
    {
        hooks
            .reversed()
            .filter { hook in hook.supportsFlagValueType(flagValueType: flagValueType) }
            .forEach { hook in
                switch hook {
                case .boolean(let booleanHook):
                    if let booleanCtx = hookCtx as? HookContext<Bool> {
                        booleanHook.before(ctx: booleanCtx, hints: hints)
                    }
                case .integer(let integerHook):
                    if let integerCtx = hookCtx as? HookContext<Int64> {
                        integerHook.before(ctx: integerCtx, hints: hints)
                    }
                case .double(let doubleHook):
                    if let doubleCtx = hookCtx as? HookContext<Double> {
                        doubleHook.before(ctx: doubleCtx, hints: hints)
                    }
                case .string(let stringHook):
                    if let stringCtx = hookCtx as? HookContext<String> {
                        stringHook.before(ctx: stringCtx, hints: hints)
                    }
                case .object(let objectHook):
                    if let objectCtx = hookCtx as? HookContext<Value> {
                        objectHook.before(ctx: objectCtx, hints: hints)
                    }
                }
            }
    }
}

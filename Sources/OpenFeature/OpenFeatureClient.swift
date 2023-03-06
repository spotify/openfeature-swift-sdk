import Foundation
import os

public class OpenFeatureClient: Client {
    // TODO: We use DispatchQueue here instead of being an actor to not lock into new versions of Swift
    private let hookQueue = DispatchQueue(label: "dev.openfeature.client.hook")
    private let contextQueue = DispatchQueue(label: "dev.openfeature.client.context")

    private var openFeatureApi: OpenFeatureAPI
    private(set) var name: String?
    private(set) var version: String?

    private var _metadata: Metadata
    public var metadata: Metadata {
        return _metadata
    }

    private var _hooks: [AnyHook] = []
    public var hooks: [AnyHook] {
        return _hooks
    }

    private var _evaluationContext: EvaluationContext?
    public var evaluationContext: EvaluationContext? {
        get {
            return _evaluationContext
        }
        set {
            contextQueue.sync {
                self._evaluationContext = newValue
            }
        }
    }

    private var hookSupport = HookSupport()
    private var logger = Logger()

    public init(openFeatureApi: OpenFeatureAPI, name: String?, version: String?) {
        self.openFeatureApi = openFeatureApi
        self.name = name
        self.version = version
        self._metadata = ClientMetadata(name: name)
    }

    public func addHooks(_ hooks: AnyHook...) {
        self.hookQueue.sync {
            self._hooks.append(contentsOf: hooks)
        }
    }
}

extension OpenFeatureClient {
    // MARK: Boolean
    public func getBooleanValue(key: String, defaultValue: Bool) -> Bool {
        return getBooleanDetails(key: key, defaultValue: defaultValue).value
    }

    public func getBooleanValue(key: String, defaultValue: Bool, ctx: EvaluationContext?) -> Bool {
        return getBooleanDetails(key: key, defaultValue: defaultValue, ctx: ctx).value
    }

    public func getBooleanValue(
        key: String, defaultValue: Bool, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> Bool
    {
        return getBooleanDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: options).value
    }

    public func getBooleanDetails(key: String, defaultValue: Bool) -> FlagEvaluationDetails<Bool> {
        return getBooleanDetails(key: key, defaultValue: defaultValue, ctx: nil)
    }

    public func getBooleanDetails(key: String, defaultValue: Bool, ctx: EvaluationContext?) -> FlagEvaluationDetails<
        Bool
    > {
        return getBooleanDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: FlagEvaluationOptions())
    }

    public func getBooleanDetails(
        key: String, defaultValue: Bool, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> FlagEvaluationDetails<Bool>
    {
        return evaluateFlag(
            flagValueType: .boolean, key: key, defaultValue: defaultValue, ctx: ctx, options: options
        )
    }
}

extension OpenFeatureClient {
    // MARK: String
    public func getStringValue(key: String, defaultValue: String) -> String {
        return getStringDetails(key: key, defaultValue: defaultValue).value
    }

    public func getStringValue(key: String, defaultValue: String, ctx: EvaluationContext?) -> String {
        return getStringDetails(key: key, defaultValue: defaultValue, ctx: ctx).value
    }

    public func getStringValue(
        key: String, defaultValue: String, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> String
    {
        return getStringDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: options).value
    }

    public func getStringDetails(key: String, defaultValue: String) -> FlagEvaluationDetails<String> {
        return getStringDetails(key: key, defaultValue: defaultValue, ctx: nil)
    }

    public func getStringDetails(key: String, defaultValue: String, ctx: EvaluationContext?) -> FlagEvaluationDetails<
        String
    > {
        return getStringDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: FlagEvaluationOptions())
    }

    public func getStringDetails(
        key: String, defaultValue: String, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> FlagEvaluationDetails<String>
    {
        return evaluateFlag(
            flagValueType: .string, key: key, defaultValue: defaultValue, ctx: ctx, options: options)
    }
}

extension OpenFeatureClient {
    // MARK: Integer
    public func getIntegerValue(key: String, defaultValue: Int64) -> Int64 {
        return getIntegerDetails(key: key, defaultValue: defaultValue).value
    }

    public func getIntegerValue(key: String, defaultValue: Int64, ctx: EvaluationContext?) -> Int64 {
        return getIntegerDetails(key: key, defaultValue: defaultValue, ctx: ctx).value
    }

    public func getIntegerValue(
        key: String, defaultValue: Int64, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> Int64
    {
        return getIntegerDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: options).value
    }

    public func getIntegerDetails(key: String, defaultValue: Int64) -> FlagEvaluationDetails<Int64> {
        return getIntegerDetails(key: key, defaultValue: defaultValue, ctx: nil)
    }

    public func getIntegerDetails(key: String, defaultValue: Int64, ctx: EvaluationContext?) -> FlagEvaluationDetails<
        Int64
    > {
        return getIntegerDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: FlagEvaluationOptions())
    }

    public func getIntegerDetails(
        key: String, defaultValue: Int64, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> FlagEvaluationDetails<Int64>
    {
        return evaluateFlag(
            flagValueType: .integer, key: key, defaultValue: defaultValue, ctx: ctx, options: options
        )
    }
}

extension OpenFeatureClient {
    // MARK: Double
    public func getDoubleValue(key: String, defaultValue: Double) -> Double {
        return getDoubleDetails(key: key, defaultValue: defaultValue).value
    }

    public func getDoubleValue(key: String, defaultValue: Double, ctx: EvaluationContext?) -> Double {
        return getDoubleDetails(key: key, defaultValue: defaultValue, ctx: ctx).value
    }

    public func getDoubleValue(
        key: String, defaultValue: Double, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> Double
    {
        return getDoubleDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: options).value
    }

    public func getDoubleDetails(key: String, defaultValue: Double) -> FlagEvaluationDetails<Double> {
        return getDoubleDetails(key: key, defaultValue: defaultValue, ctx: nil)
    }

    public func getDoubleDetails(key: String, defaultValue: Double, ctx: EvaluationContext?) -> FlagEvaluationDetails<
        Double
    > {
        return getDoubleDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: FlagEvaluationOptions())
    }

    public func getDoubleDetails(
        key: String, defaultValue: Double, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> FlagEvaluationDetails<Double>
    {
        return evaluateFlag(
            flagValueType: .double, key: key, defaultValue: defaultValue, ctx: ctx, options: options)
    }
}

extension OpenFeatureClient {
    // MARK: Object
    public func getObjectValue(key: String, defaultValue: Value) -> Value {
        return getObjectDetails(key: key, defaultValue: defaultValue).value
    }

    public func getObjectValue(key: String, defaultValue: Value, ctx: EvaluationContext?) -> Value {
        return getObjectDetails(key: key, defaultValue: defaultValue, ctx: ctx).value
    }

    public func getObjectValue(
        key: String, defaultValue: Value, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> Value
    {
        return getObjectDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: options).value
    }

    public func getObjectDetails(key: String, defaultValue: Value) -> FlagEvaluationDetails<Value> {
        return getObjectDetails(key: key, defaultValue: defaultValue, ctx: nil)
    }

    public func getObjectDetails(key: String, defaultValue: Value, ctx: EvaluationContext?) -> FlagEvaluationDetails<
        Value
    > {
        return getObjectDetails(key: key, defaultValue: defaultValue, ctx: ctx, options: FlagEvaluationOptions())
    }

    public func getObjectDetails(
        key: String, defaultValue: Value, ctx: EvaluationContext?, options: FlagEvaluationOptions
    )
        -> FlagEvaluationDetails<Value>
    {
        return evaluateFlag(
            flagValueType: .object, key: key, defaultValue: defaultValue, ctx: ctx, options: options)
    }
}

extension OpenFeatureClient {
    public struct ClientMetadata: Metadata {
        public var name: String?
    }
}

extension OpenFeatureClient {
    private func evaluateFlag<T>(
        flagValueType: FlagValueType,
        key: String,
        defaultValue: T,
        ctx: EvaluationContext?,
        options: FlagEvaluationOptions?
    ) -> FlagEvaluationDetails<T> {
        let options = options ?? FlagEvaluationOptions(hooks: [], hookHints: [:])
        let hints = options.hookHints

        let ctx = ctx ?? MutableContext()
        let apiContext = openFeatureApi.evaluationContext ?? MutableContext()
        let clientContext = self.evaluationContext ?? MutableContext()
        var mergedCtx = apiContext.merge(overridingContext: clientContext.merge(overridingContext: ctx))
        var details = FlagEvaluationDetails(flagKey: key, value: defaultValue)
        let provider = openFeatureApi.provider ?? NoOpProvider()
        let mergedHooks = provider.hooks + options.hooks + hooks + openFeatureApi.hooks
        let hookCtx = HookContext(
            flagKey: key,
            type: flagValueType,
            defaultValue: defaultValue,
            ctx: mergedCtx,
            clientMetadata: self.metadata,
            providerMetadata: provider.metadata)

        do {
            let ctxFromHook = hookSupport.beforeHooks(
                flagValueType: flagValueType, hookCtx: hookCtx, hooks: mergedHooks, hints: hints)
            mergedCtx = mergedCtx.merge(overridingContext: ctxFromHook)

            let providerEval = try createProviderEvaluation(
                flagValueType: flagValueType,
                key: key,
                defaultValue: defaultValue,
                provider: provider,
                invocationContext: mergedCtx)

            let evalDetails = FlagEvaluationDetails<T>.from(providerEval: providerEval, flagKey: key)
            details = evalDetails

            try hookSupport.afterHooks(
                flagValueType: flagValueType, hookCtx: hookCtx, details: evalDetails, hooks: mergedHooks, hints: hints)
        } catch {
            logger.error("Unable to correctly evaluate flag with key \(key) due to exception \(error)")

            if let error = error as? OpenFeatureError {
                details.errorCode = error.errorCode()
            } else {
                details.errorCode = .general
            }

            details.errorMessage = "\(error)"
            details.reason = Reason.error.rawValue

            hookSupport.errorHooks(
                flagValueType: flagValueType, hookCtx: hookCtx, error: error, hooks: mergedHooks, hints: hints)
        }

        hookSupport.afterAllHooks(
            flagValueType: flagValueType, hookCtx: hookCtx, hooks: mergedHooks, hints: hints)

        return details
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func createProviderEvaluation<V>(
        flagValueType: FlagValueType,
        key: String,
        defaultValue: V,
        provider: FeatureProvider,
        invocationContext: EvaluationContext
    ) throws -> ProviderEvaluation<V> {
        switch flagValueType {
        case .boolean:
            guard let defaultValue = defaultValue as? Bool else {
                break
            }

            if let evaluation = try provider.getBooleanEvaluation(
                key: key,
                defaultValue: defaultValue,
                ctx: invocationContext) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .string:
            guard let defaultValue = defaultValue as? String else {
                break
            }

            if let evaluation = try provider.getStringEvaluation(
                key: key,
                defaultValue: defaultValue,
                ctx: invocationContext) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .integer:
            guard let defaultValue = defaultValue as? Int64 else {
                break
            }

            if let evaluation = try provider.getIntegerEvaluation(
                key: key,
                defaultValue: defaultValue,
                ctx: invocationContext) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .double:
            guard let defaultValue = defaultValue as? Double else {
                break
            }

            if let evaluation = try provider.getDoubleEvaluation(
                key: key,
                defaultValue: defaultValue,
                ctx: invocationContext) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        case .object:
            guard let defaultValue = defaultValue as? Value else {
                break
            }

            if let evaluation = try provider.getObjectEvaluation(
                key: key,
                defaultValue: defaultValue,
                ctx: invocationContext) as? ProviderEvaluation<V>
            {
                return evaluation
            }
        }

        throw OpenFeatureError.generalError(message: "Unable to match default value type with flag value type")
    }
}

import Foundation

public protocol Features {
    // MARK: Bool
    func getBooleanValue(key: String, defaultValue: Bool) -> Bool

    func getBooleanValue(key: String, defaultValue: Bool, ctx: EvaluationContext?) -> Bool

    func getBooleanValue(key: String, defaultValue: Bool, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> Bool

    func getBooleanDetails(key: String, defaultValue: Bool) -> FlagEvaluationDetails<Bool>

    func getBooleanDetails(key: String, defaultValue: Bool, ctx: EvaluationContext?) -> FlagEvaluationDetails<Bool>

    func getBooleanDetails(key: String, defaultValue: Bool, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> FlagEvaluationDetails<Bool>

    // MARK: String
    func getStringValue(key: String, defaultValue: String) -> String

    func getStringValue(key: String, defaultValue: String, ctx: EvaluationContext?) -> String

    func getStringValue(key: String, defaultValue: String, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> String

    func getStringDetails(key: String, defaultValue: String) -> FlagEvaluationDetails<String>

    func getStringDetails(key: String, defaultValue: String, ctx: EvaluationContext?) -> FlagEvaluationDetails<String>

    func getStringDetails(key: String, defaultValue: String, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> FlagEvaluationDetails<String>

    // MARK: Int
    func getIntegerValue(key: String, defaultValue: Int64) -> Int64

    func getIntegerValue(key: String, defaultValue: Int64, ctx: EvaluationContext?) -> Int64

    func getIntegerValue(key: String, defaultValue: Int64, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> Int64

    func getIntegerDetails(key: String, defaultValue: Int64) -> FlagEvaluationDetails<Int64>

    func getIntegerDetails(key: String, defaultValue: Int64, ctx: EvaluationContext?) -> FlagEvaluationDetails<Int64>

    func getIntegerDetails(key: String, defaultValue: Int64, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> FlagEvaluationDetails<Int64>

    // MARK: Double
    func getDoubleValue(key: String, defaultValue: Double) -> Double

    func getDoubleValue(key: String, defaultValue: Double, ctx: EvaluationContext?) -> Double

    func getDoubleValue(key: String, defaultValue: Double, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> Double

    func getDoubleDetails(key: String, defaultValue: Double) -> FlagEvaluationDetails<Double>

    func getDoubleDetails(key: String, defaultValue: Double, ctx: EvaluationContext?) -> FlagEvaluationDetails<Double>

    func getDoubleDetails(key: String, defaultValue: Double, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> FlagEvaluationDetails<Double>

    // MARK: Object
    func getObjectValue(key: String, defaultValue: Value) -> Value

    func getObjectValue(key: String, defaultValue: Value, ctx: EvaluationContext?) -> Value

    func getObjectValue(key: String, defaultValue: Value, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> Value

    func getObjectDetails(key: String, defaultValue: Value) -> FlagEvaluationDetails<Value>

    func getObjectDetails(key: String, defaultValue: Value, ctx: EvaluationContext?) -> FlagEvaluationDetails<Value>

    func getObjectDetails(key: String, defaultValue: Value, ctx: EvaluationContext?, options: FlagEvaluationOptions)
        -> FlagEvaluationDetails<Value>
}

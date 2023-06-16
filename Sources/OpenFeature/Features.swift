import Foundation

public protocol Features {
    // MARK: Generics
    func getValue<T: AllowedFlagValueType>(key: String, defaultValue: T) -> T

    func getValue<T: AllowedFlagValueType>(
        key: String, defaultValue: T, options: FlagEvaluationOptions
    ) -> T

    func getDetails<T: AllowedFlagValueType>(key: String, defaultValue: T) -> FlagEvaluationDetails<T>

    func getDetails<T: AllowedFlagValueType>(
        key: String, defaultValue: T, options: FlagEvaluationOptions
    ) -> FlagEvaluationDetails<T>
}

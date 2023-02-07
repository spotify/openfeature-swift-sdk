import Foundation

public protocol Structure {
    func keySet() -> Set<String>
    func getValue(key: String) -> Value?
    func asMap() -> [String: Value]
    func asObjectMap() -> [String: AnyHashable?]
}

import Foundation

public enum Value: Equatable {
    case boolean(Bool)
    case string(String)
    case integer(Int64)
    case double(Double)
    case date(Date)
    case list([Value])
    case structure([String: Value])
    case null

    public static func of<T>(_ value: T) -> Value {
        if let value = value as? Bool {
            return .boolean(value)
        } else if let value = value as? String {
            return .string(value)
        } else if let value = value as? Int64 {
            return .integer(value)
        } else if let value = value as? Double {
            return .double(value)
        } else if let value = value as? Date {
            return .date(value)
        } else {
            return .null
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func getTyped<T>() -> T? {
        if let value = self as? T {
            return value
        }

        switch self {
        case .boolean(let value):
            if let value = value as? T {
                return value
            }
        case .string(let value):
            if let value = value as? T {
                return value
            }
        case .integer(let value):
            if let value = value as? T {
                return value
            }
        case .double(let value):
            if let value = value as? T {
                return value
            }
        case .date(let value):
            if let value = value as? T {
                return value
            }
        case .list(let value):
            if let value = value as? T {
                return value
            }
        case .structure(let value):
            if let value = value as? T {
                return value
            }
        case .null:
            return nil
        }

        return nil
    }

    public func asBoolean() -> Bool? {
        if case let .boolean(bool) = self {
            return bool
        }

        return nil
    }

    public func asString() -> String? {
        if case let .string(string) = self {
            return string
        }

        return nil
    }

    public func asInteger() -> Int64? {
        if case let .integer(int64) = self {
            return int64
        }

        return nil
    }

    public func asDouble() -> Double? {
        if case let .double(double) = self {
            return double
        }

        return nil
    }

    public func asDate() -> Date? {
        if case let .date(date) = self {
            return date
        }

        return nil
    }

    public func asList() -> [Value]? {
        if case let .list(values) = self {
            return values
        }

        return nil
    }

    public func asStructure() -> [String: Value]? {
        if case let .structure(values) = self {
            return values
        }

        return nil
    }

    public func isNull() -> Bool {
        if case .null = self {
            return true
        }

        return false
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .boolean(let value):
            return "\(value)"
        case .string(let value):
            return value
        case .integer(let value):
            return "\(value)"
        case .double(let value):
            return "\(value)"
        case .date(let value):
            return "\(value)"
        case .list(value: let values):
            return "\(values.map { value in value.description })"
        case .structure(value: let values):
            return "\(values.mapValues { value in value.description })"
        case .null:
            return "null"
        }
    }
}

extension Value: Codable {
    enum EncodedValueCodingKeys: String, CodingKey {
        case key
        case type
        case value
    }

    enum EncodedValueTypeCodingKeys: String, Codable {
        case boolean
        case string
        case integer
        case double
        case date
        case list
        case structure
        case null

        static func fromValue(_ value: Value) -> EncodedValueTypeCodingKeys {
            switch value {
            case .boolean:
                return .boolean
            case .string:
                return .string
            case .integer:
                return .integer
            case .double:
                return .double
            case .date:
                return .date
            case .list:
                return .list
            case .structure:
                return .structure
            case .null:
                return .null
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodedValueCodingKeys.self)

        try Value.encodeValue(value: self, container: &container)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EncodedValueCodingKeys.self)

        self = try Value.decodeValue(container: container)
    }

    static private func encodeValue(value: Value, container: inout KeyedEncodingContainer<EncodedValueCodingKeys>)
        throws
    {
        try container.encode(EncodedValueTypeCodingKeys.fromValue(value), forKey: .type)
        switch value {
        case .boolean(let bool):
            try container.encode(bool, forKey: .value)
        case .string(let string):
            try container.encode(string, forKey: .value)
        case .integer(let int64):
            try container.encode(int64, forKey: .value)
        case .double(let double):
            try container.encode(double, forKey: .value)
        case .date(let date):
            try container.encode(date, forKey: .value)
        case .list(let values):
            var listContainer = container.nestedUnkeyedContainer(forKey: .value)

            for (index, listValue) in values.enumerated() {
                var nestedContainer = listContainer.nestedContainer(keyedBy: EncodedValueCodingKeys.self)
                try nestedContainer.encode("\(index)", forKey: .key)
                try encodeValue(value: listValue, container: &nestedContainer)
            }
        case .structure(let values):
            var mapContainer = container.nestedUnkeyedContainer(forKey: .value)

            for (key, mapValue) in values {
                var nestedContainer = mapContainer.nestedContainer(keyedBy: EncodedValueCodingKeys.self)
                try nestedContainer.encode(key, forKey: .key)
                try encodeValue(value: mapValue, container: &nestedContainer)
            }
        case .null:
            try container.encodeNil(forKey: .value)
        }
    }

    static private func decodeValue(container: KeyedDecodingContainer<EncodedValueCodingKeys>) throws -> Value {
        let type = try container.decode(EncodedValueTypeCodingKeys.self, forKey: .type)
        switch type {
        case .boolean:
            let value = try container.decode(Bool.self, forKey: .value)
            return .boolean(value)
        case .string:
            let value = try container.decode(String.self, forKey: .value)
            return .string(value)
        case .integer:
            let value = try container.decode(Int64.self, forKey: .value)
            return .integer(value)
        case .double:
            let value = try container.decode(Double.self, forKey: .value)
            return .double(value)
        case .date:
            let value = try container.decode(Date.self, forKey: .value)
            return .date(value)
        case .list:
            var listContainer = try container.nestedUnkeyedContainer(forKey: .value)

            var values: [Value] = []
            while !listContainer.isAtEnd {
                let nestedContainer = try listContainer.nestedContainer(keyedBy: EncodedValueCodingKeys.self)

                let element = try decodeValue(container: nestedContainer)
                values.append(element)
            }

            return .list(values)
        case .structure:
            var mapContainer = try container.nestedUnkeyedContainer(forKey: .value)

            var values: [String: Value] = [:]
            while !mapContainer.isAtEnd {
                let nestedContainer = try mapContainer.nestedContainer(keyedBy: EncodedValueCodingKeys.self)

                let key = try nestedContainer.decode(String.self, forKey: .key)
                let element = try decodeValue(container: nestedContainer)
                values[key] = element
            }

            return .structure(values)
        case .null:
            return .null
        }
    }
}

extension Value {
    // swiftlint:disable:next identifier_name
    public func decode<T: Decodable>(to: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: toJson(value: self))

        return try JSONDecoder().decode(to, from: data)
    }

    func toJson(value: Value) -> Any {
        switch value {
        case .boolean(let bool):
            return bool
        case .string(let string):
            return string
        case .integer(let int64):
            return int64
        case .double(let double):
            return double
        case .date(let date):
            return date.timeIntervalSinceReferenceDate
        case .list(let list):
            return list.map(self.toJson)
        case .structure(let structure):
            return structure.mapValues(self.toJson)
        case .null:
            return NSNull()
        }
    }
}

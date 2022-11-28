//
//  ValidatedPropertyWrapper.swift
//  TestingTextField
//
//  Created by TI Digital on 23/11/22.
//

import Foundation

@propertyWrapper
struct Validated<Rule: ValidationRule> {
    
    // The value we want to validate
    var wrappedValue: Rule.Value
    
    // The rule we want the value to validate against
    private var rule: Rule
    
    // usage: @Validated(Rule()) var value: String = "initial value"
    init(wrappedValue: Rule.Value, _ rule: Rule) {
        self.rule = rule
        self.wrappedValue = wrappedValue
    }
}

// Provides default values for our rule & value
extension Validated {
    
    // usage: @Validated<Rule> var value: String = "initial value"
    init(wrappedValue: Rule.Value) {
        self.init(wrappedValue: wrappedValue, Rule.init())
    }
    
    // usage: @Validated<Rule> var value {
    init() {
        let rule = Rule.init()
        self.init(wrappedValue: rule.fallbackValue, rule)
    }
}

// Provides access to the validation result using $ notation
extension Validated {
    
    public var projectedValue: Rule.ValidationResult { rule.validate(wrappedValue) }
}

// Conformance to encodable
extension Validated: Encodable where Rule.Value: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch projectedValue {
        case .success(let validated):
            try container.encode(validated)
        case .failure(_):
            try container.encode(Rule().fallbackValue)
        }
    }
}

// Conformance to decodable
extension Validated: Decodable where Rule.Value: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Rule.Value.self)
        self.init(wrappedValue: value, Rule.init())
    }
}

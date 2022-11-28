//
//  FormValidation.swift
//  TestingTextField
//
//  Created by TI Digital on 23/11/22.
//

import Foundation

// MARK: - VALIDATION

/// Accepts a `Value` and returns a `Result`
protocol ValidationRule {
    associatedtype Value: Equatable
    associatedtype Failure: Error
    typealias ValidationResult = Result<Value, Failure>
    
    init()
    
    var fallbackValue: Value { get }
    func validate(_ value: Value) -> Result<Value, Failure>
}

extension ValidationRule where Value == String {
    var fallbackValue: Value { .init() } // returns empty String
}

extension ValidationRule where Value: ExpressibleByNilLiteral {
    var fallbackValue: Value { .init(nilLiteral: ()) } // returns nil
}

enum FormType: String {
    case firstName = "Nama Depan*"
    case lastName = "Nama Belakang*"
    case email = "Email*"
    case password = "Kata Sandi*"
}

struct NameRule: ValidationRule {
 
    let type: FormType
    init() { self.type = .firstName }
    init(_ formType: FormType) { self.type = formType }
    
    func validate(_ value: String) -> Result<String, ErrorMessage> {
        
        // value must be more than 0
        guard value.count > 0 else {
            return .failure("\(self.type.rawValue) tidak boleh kosong")
        }
        
        // can only be letters
        guard value.allSatisfy({ char in !char.isNumber }) else {
            return .failure("\(self.type.rawValue) hanya boleh huruf")
        }
      
        // successful validation
        return .success(value)
    }
}

struct EmailRule: ValidationRule {
    
    let type: FormType
    init() { self.type = .email }
    
    func validate(_ value: String) -> Result<String, ErrorMessage> {
        guard value.count <= 100 else {
            return .failure("Email tidak boleh lebih dari 100 character")
        }
        
        return .success(value)
    }
}

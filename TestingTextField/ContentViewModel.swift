//
//  ContentViewModel.swift
//  TestingTextField
//
//  Created by TI Digital on 23/11/22.
//

import SwiftUI



struct FormModel {
    var type: FormType
    var label: String
    var input: String
    var errorMessage: String
    
    init(type: FormType, input: String, errorMessage: String) {
        self.type = type
        self.label = type.rawValue
        self.input = input
        self.errorMessage = errorMessage
    }
}

class ContentVM: ObservableObject {
    
    @Published var firstName: FormModel = FormModel(type: .firstName, input: "", errorMessage: "")
    @Published var lastName: FormModel = FormModel(type: .lastName, input: "", errorMessage: "")
    @Published var email: FormModel = FormModel(type: .email, input: "", errorMessage: "")
    @Published var password: FormModel = FormModel(type: .password, input: "", errorMessage: "")
    
    func hitSomeAPIValidation() {
        self.firstName.errorMessage = "Error model first name dari api"
    }
}

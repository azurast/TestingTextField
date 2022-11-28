//
//  RegularTextField.swift
//  TestingTextField
//
//  Created by TI Digital on 23/11/22.
//

import SwiftUI

struct RegularTextField: View {
    @Binding var form: FormModel
    @State var isFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.isFocused || !form.input.isEmpty {
                withAnimation(.linear(duration: 2)) {
                    Text(form.label)
                        .foregroundColor(form.errorMessage.isEmpty ? .blue : .red)
                        .font(.caption)
                }
            }
            
            switch form.type {
            case .password:
                self.password
            default:
                self.name
            }
//            switch form.type {
//            case .password:
//                self.password
//            case .email:
//                self.email
//            default:
//                self.name
//            }
            
            if #available(iOS 15.0, *) {
                Divider()
                    .background(form.errorMessage.isEmpty ? .gray : .red)
            } else {
                // Fallback on earlier versions
                Rectangle()
                    .fill(form.errorMessage.isEmpty ? .gray : .red)
                    .frame(height: 1)
            }
            
            if !form.errorMessage.isEmpty {
                Text(form.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.5))
        .padding(.horizontal, 16)
    }
    
    
    var email: some View {
        if #available(iOS 15.0, *) {
            return TextField(self.isFocused ? "" : form.label, text: $form.input, onEditingChanged: { focused in
                if focused {
                    self.isFocused = true
                } else {
                    self.isFocused = false
                }
            }).autocorrectionDisabled(true)
            // Local Validation
            .validate($form.input, rule: EmailRule()) { result in
                switch result {
                case .success(_):
                    form.errorMessage = ""
                case .failure(let message):
                    form.errorMessage = message
                }
            }
        } else {
            // Fallback on earlier versions
            return TextField(self.isFocused ? "" : form.label, text: $form.input, onEditingChanged: { focused in
                if focused {
                    self.isFocused = true
                } else {
                    self.isFocused = false
                }
            }).autocorrectionDisabled(true)
        }
    }
    
    var password: some View {
        SecureField(self.isFocused ? "" : form.label, text: $form.input)
    }
    
    var name: some View {
        if #available(iOS 15.0, *) {
            return TextField(self.isFocused ? "" : form.label, text: $form.input, onEditingChanged: { focused in
                if focused {
                    self.isFocused = true
                } else {
                    self.isFocused = false
                }
            }).autocorrectionDisabled(true)
            // Local Validation
            .validate($form.input, rule: NameRule(form.type)) { result in
                switch result {
                case .success(_):
                    form.errorMessage = ""
                case .failure(let message):
                    form.errorMessage = message
                }
            }
        } else {
            // Fallback on earlier versions
            return TextField(self.isFocused ? "" : form.label, text: $form.input, onEditingChanged: { focused in
                if focused {
                    self.isFocused = true
                } else {
                    self.isFocused = false
                }
            }).autocorrectionDisabled(true)
        }
    }
}



extension View {
    @available(iOS 15.0, *)
    func validate<Rule>(_ value: Binding<Rule.Value>,
                        rule: Rule,
                        validation: @escaping (Rule.ValidationResult) -> Void) -> some View where Rule: ValidationRule {
          self
            // when value changes, the escaping function will fire
            .onChange(of: value.wrappedValue) { value in
                let result = rule.validate(value)
                validation(result) // fire escaping function
            }
            // when field is submitted, the value will be replaced with a valid value
            // this is important if any transformation was made to the value
            // within the validation rule
            .onSubmit {
                let result = rule.validate(value.wrappedValue)
                if case .success(let validated) = result {
                    if value.wrappedValue != validated {
                    value.wrappedValue = validated // update value
                    }
                }
            }
        }
}

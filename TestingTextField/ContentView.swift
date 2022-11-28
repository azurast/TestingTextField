//
//  ContentView.swift
//  TestingTextField
//
//  Created by TI Digital on 23/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var contentVM: ContentVM = ContentVM()
    
    var body: some View {
        VStack(spacing: 8) {
            RegularTextField(form: $contentVM.firstName)
            RegularTextField(form: $contentVM.lastName)
            RegularTextField(form: $contentVM.email)
            RegularTextField(form: $contentVM.password)
            
            Button(action: {
                // Validate ke BE
                self.contentVM.hitSomeAPIValidation()
            }, label: {
                Text("Validate")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12")
    }
}


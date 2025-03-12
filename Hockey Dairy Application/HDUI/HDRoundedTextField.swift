//
//  HDRoundedTextField.swift
//  Hockey Team Journal
//
//  Created by Den on 27/02/24.
//

import SwiftUI

struct HDRoundedTextField: View {
    @Binding var text: String
    @State var placeholder: String
    @State var numberMode: Bool = false
    @Binding var editMode: Bool
    @State var sheetOrPage: Bool = true
    @State private var firstTouch: Bool = false
    @State var completion: (String) -> Void = {_ in}
    var body: some View {
        HStack(spacing: 0) {
            if editMode {
                if sheetOrPage && text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
                if !sheetOrPage {
                    Text(placeholder)
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
            }
            
            TextField("", text: $text)
                .foregroundColor(Color.allWhite)
                .font(Font.system(size: 17, weight: .semibold))
                .disabled(!editMode)
                .onChange(of: text, perform: { value in
                    completion(value)
                })
            Spacer()
        }
        .onAppear {
            if editMode {
                firstTouch = true
            }
        }
        .onTapGesture {
            if editMode {
                firstTouch = true
            }
        }
        .frame(maxHeight: 30)
        .padding(16)
        .background(Color.active)
        .cornerRadius(10)
    }
}

#Preview {
    HDRoundedTextField(text: .constant(""), placeholder: "Name: ", editMode: .constant(false))
}

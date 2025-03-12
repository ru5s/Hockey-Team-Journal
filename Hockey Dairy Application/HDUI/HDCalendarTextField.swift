//
//  HDCalendarTextField.swift
//  Hockey Team Journal
//
//  Created by Den on 03/03/24.
//

import SwiftUI

struct HDCalendarTextField: View {
    @Binding var text: String
    @State var placeholder: String
    @Binding var editMode: Bool
    @State var completion: (String) -> Void = {_ in}
    var body: some View {
        HStack(spacing: 0) {
            Text(placeholder)
                .foregroundColor(Color.allWhite.opacity(0.5))
            
            TextField("", text: $text)
                .foregroundColor(Color.allWhite)
                .font(Font.system(size: 17, weight: .semibold))
                .disabled(!editMode)
                .onChange(of: text, perform: { value in
                    completion(value)
                })
            Spacer()
        }
        .frame(height: 30)
        .padding(16)
        .background(Color.active)
        .cornerRadius(10)
    }
}

#Preview {
    HDCalendarTextField(text: .constant("123"), placeholder: "Opponent: ", editMode: .constant(false))
}

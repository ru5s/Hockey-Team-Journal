//
//  HDCalendarAdditionalInfo.swift
//  Hockey Team Journal
//
//  Created by Den on 03/03/24.
//

import SwiftUI

struct HDCalendarAdditionalInfo: View {
    @Binding var editMode: Bool
    @Binding var text: String
    @State var completion: (String) -> Void = {_ in}
    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading, content: {
                if text.isEmpty {
                    Text("Write some information...")
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
                TextEditor(text: $text)
                    .textEditorBackground(Color.clear)
                    .foregroundColor(Color.allWhite)
                    .font(Font.system(size: 17, weight: .semibold))
                    .disabled(!editMode)
            })
            Spacer()
            if editMode {
                Button(action: {
                    completion(text)
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(Color.allWhite.opacity(0.5))
                })
            }
        }
        .padding(16)
        .background(Color.active)
        .cornerRadius(10)
    }
}

#Preview {
    HDCalendarAdditionalInfo(editMode: .constant(true), text: .constant(""))
}

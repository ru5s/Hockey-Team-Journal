//
//  HDSearchBar.swift
//  Hockey Team Journal
//
//  Created by Den on 28/02/24.
//

import SwiftUI

struct HDSearchBar: View {
    @Binding var text: String
    @State var completion: (String) -> Void
    @State private var showEraseButton: Bool?
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField("Search", text: $text)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: text, perform: { _ in
                        updateTextState()
                    })
                if !(showEraseButton ?? true) {
                    Button(action: {
                        text.removeAll()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17))
                            .foregroundColor(Color.gray)
                    })
                }
            }
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            Button(action: {
                completion(text)
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.top, 8)
    }
    
    private func updateTextState() {
        showEraseButton = text.isEmpty
    }
}

#Preview {
    HDSearchBar(text: .constant(""), completion: {_ in})
}

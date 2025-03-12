//
//  HDRoundedBtn.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDRoundedBtn: View {
    @State var nameButton: String
    @State var completion: () -> Void = {}
    @Binding var state: Bool
    @State var backgroundColor: Color?
    
    var body: some View {
        Button {
            completion()
        } label: {
            Text(nameButton)
                .frame(maxWidth: .infinity)
                .frame(height: 62)
        }
        .background(backgroundColor ?? Color.navigationBackground)
        .accentColor(state ? Color.allWhite : Color.allWhite.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .disabled(state ? false : true)
    }
}

#Preview {
    HDRoundedBtn(nameButton: "next", state: .constant(true))
}

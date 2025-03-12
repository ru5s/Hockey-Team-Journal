//
//  HDBaloonTag.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDBaloonTag: View {
    @State var titile: String
    var body: some View {
        Text(titile)
            .font(Font.system(size: 17, weight: .regular))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(Color.cellInventarChoosedBackground)
        .background(Color.allWhite)
        .accentColor(Color.allWhite)
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

#Preview {
    HDBaloonTag(titile: "basketball")
}

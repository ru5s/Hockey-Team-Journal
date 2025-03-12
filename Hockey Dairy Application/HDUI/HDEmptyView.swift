//
//  HDEmptyView.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDEmptyView: View {
    @State var title: String
    @State var subtitle: String
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .foregroundColor(Color.active)
                .font(Font.system(size: 28, weight: .bold))
            .padding(.bottom, 5)
        
            Text(subtitle)
                .foregroundColor(Color.secondaryText)
                .font(Font.system(size: 18, weight: .regular))
            Spacer()
        }
    }
}

#Preview {
    HDEmptyView(title: "Title", subtitle: "Subtitle")
}

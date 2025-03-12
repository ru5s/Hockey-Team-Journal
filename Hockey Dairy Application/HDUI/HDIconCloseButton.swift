//
//  HDCloseButton.swift
//  Hockey Team Journal
//
//  Created by Den on 27/02/24.
//

import SwiftUI

struct HDIconCloseButton: View {
    var body: some View {
        Circle()
            .foregroundColor(Color.active.opacity(0.16))
            .overlay(
                Image(systemName: "xmark")
                .resizable()
                .scaledToFill()
                .scaleEffect(0.5)
                .foregroundColor(Color.active), alignment: .center)
    }
}

#Preview {
    HDIconCloseButton()
}

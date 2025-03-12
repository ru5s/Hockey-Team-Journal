//
//  HDImageDots.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDImageDots: View {
    @Binding var count: Int
    @Binding var activeIndex: Int
    var body: some View {
        HStack {
            ForEach(0..<count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(index == activeIndex ? Color.navigationBackground : Color.allWhite.opacity(0.27))
                    .frame(width: 72, height: 6)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
    }
}

#Preview {
    HDImageDots(count: .constant(3), activeIndex: .constant(1))
}

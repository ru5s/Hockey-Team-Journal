//
//  HDInventoryAlert.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import SwiftUI

struct HDInventoryAlert: View {
    @Binding var dismis: Bool
    @State private var title: String = "Elements "
    @State var confirm: (HDInventoryType) -> Void
    var body: some View {
        ZStack {
            if dismis {
                GeometryReader(content: { geometry in
                    VStack {
                        Text(title)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                        
                        ForEach(HDInventoryType.allCases, id: \.id) {type in
                            Button(action: {
                                confirm(type)
                                dismis.toggle()
                            }, label: {
                                VStack {
                                    Divider()
                                    Text(type.description())
                                }
                            })
                        }
                    }
                    .padding(.vertical, 20)
                    .foregroundColor(Color.allWhite)
                    .frame(maxWidth: geometry.size.width - 200)
                    .background(Color.cellBorderBackground)
                    .cornerRadius(16)
                    .position(x: geometry.frame(in: .local).width / 2, y: geometry.frame(in: .local).height / 2)
                    .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0.0, y: 0.0)
                    
                })
                .onTapGesture {
                    dismis.toggle()
                }
            }
        }
        
    }
}

#Preview {
    HDInventoryAlert(dismis: .constant(false), confirm: {_ in})
}

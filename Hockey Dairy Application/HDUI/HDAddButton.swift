//
//  SwiftUIView.swift
//  Hockey Team Journal
//
//  Created by Den on 28/02/24.
//

import SwiftUI

struct HDAddButton: View {
    @Binding var touched: Bool
    @State var completion: (Bool) -> Void = {_ in}
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .foregroundColor(Color.navigationBackground)
                    .overlay(
                        Circle()
                            .foregroundColor(Color.allWhite)
                            .scaleEffect(0.9)
                            .overlay(
                                Button(action: {
                                    touched.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFill()
                                        .scaleEffect(0.5)
                                        .foregroundColor(Color.navigationBackground)
                                })
                            )
                    )
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 30)
            }
        }
        .onChange(of: touched, perform: { value in
            completion(touched)
        })
    }
}

#Preview {
    HDAddButton(touched: .constant(true))
}

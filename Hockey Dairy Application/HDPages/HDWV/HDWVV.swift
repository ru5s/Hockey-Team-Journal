//
//  HDWVV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDWVV: View {
    @State var urlString = ""
    var body: some View {
        ZStack {
            Color.allWhite
                .ignoresSafeArea()
            VStack {
                HDWVManager(urlString: urlString)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HDWVV()
}

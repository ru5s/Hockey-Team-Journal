//
//  HDSplashV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDSplashV: View {
    @ObservedObject var model = HDSplashVM()
    @State var sOnboarding: Bool
    var body: some View {
        NavigationView(content: {
            VStack {
                NavigationLink(destination: HDOnboardingV(mainAnswer: sOnboarding).navigationBarHidden(true), isActive: $model.isPresented) {EmptyView()}
                NavigationLink(destination: HDTabView().navigationBarHidden(true), isActive: $model.openTabview) {EmptyView()}
                Spacer()
                Image("loading logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230)
                Spacer()
                ProgressView(value: model.progressBar.rawValue, total: 1.0)
                    .accentColor(Color.navigationBackground)
                    .cornerRadius(3.0)
                    .scaleEffect(y: 2.0)
                    .padding(.horizontal, 100)
                    .padding(.bottom, 120)
            }
            .background(Image("onboarding background")
                .resizable()
                .scaledToFill())
            .ignoresSafeArea()
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.mainAnswer = sOnboarding
            model.starTtimer()
        }
    }
}

#Preview {
    HDSplashV (sOnboarding: true)
}

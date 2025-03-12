//
//  HDOnboardingV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI
import StoreKit

struct HDOnboardingV: View {
    @State var mainAnswer: Bool
    @ObservedObject var model = HDOnboardingVM()
    
    @State var activeTab: Int = 0
    @State var openWebview: Bool = false
    @State var openTabview: Bool = false
    @State var linkToWebview: String = "https://google.com"
    @State var activeNextButton: Bool = true
    
    var body: some View {
        NavigationView(content: {
            ZStack {
            NavigationLink(
                destination: HDTabView().navigationBarHidden(true),isActive: $openTabview,label: {EmptyView()})
                TabView(selection: $activeTab,
                        content:  {
                    ForEach(Array(model.onboardingStack.enumerated()), id: \.element) {index, data in
                        HDOnboardingCell(data: data, cellCount: model.onboardingStack.count, activeDot: $activeTab, state: $activeNextButton, completion: {
                            if activeTab < model.onboardingStack.count - 1 {
                                activeTab += 1
                            } else {
                                let defaults = UserDefaults.standard
                                defaults.set(true, forKey: "seen onboard")
                                DispatchQueue.main.async {
                                    openTabview.toggle()
                                }
                            }
                        }, mainAnswer: mainAnswer)
                        .tag(index)
                    }
                })
                .background(Image("onboarding background")
                    .resizable()
                    .scaledToFill())
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
            }
            .ignoresSafeArea()
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.mainAnswer(mainAnswer)
        }
    }
    
    private func rateApp() {
        DispatchQueue.main.async {
            let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive})
            SKStoreReviewController.requestReview(in: scene as! UIWindowScene)
            activeNextButton = true
        }
    }
}

#Preview {
    HDOnboardingV(mainAnswer: false)
}

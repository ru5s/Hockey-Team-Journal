//
//  HDOnboardingVM.swift
//  Hockey Team Journal
//
//  
//

import Foundation

class HDOnboardingVM: ObservableObject {
    @Published var onboardingStack: [HDOnboardingModel] = []
    private let onboarding: [HDOnboardingModel] = [
        .init(image: "onboarding 1", title: "Manage your team!", paragraph: "Be your own trainer!"),
        .init(image: "onboarding 2", title: "Explore your own inventory", paragraph: "Awesome function"),
        .init(image: "onboarding 3", title: "Be in focus with games", paragraph: "Fill out the game calendar!")
    ]
    func mainAnswer(_ state: Bool) {
        onboardingStack = onboarding
    }
}

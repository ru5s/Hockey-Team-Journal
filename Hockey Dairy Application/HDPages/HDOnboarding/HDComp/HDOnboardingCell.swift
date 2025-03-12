//
//  HDOnboardingCell.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDOnboardingCell: View {
    @State var data: HDOnboardingModel
    @State var cellCount: Int
    @Binding var activeDot: Int
    @Binding var state: Bool
    @State var completion: () -> Void = {}
    @State var backgroundImage: String = "onboarding background"
    @State var mainAnswer: Bool
    var body: some View {
        VStack {
            HDImageDots(count: $cellCount, activeIndex: $activeDot)
            Text(data.title)
                .foregroundColor(Color.allWhite)
                .font(Font.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            Text(data.paragraph)
                .foregroundColor(Color.allWhite.opacity(0.7))
                .font(Font.system(size: 17, weight: .regular))
            Spacer()
            ZStack(alignment: .bottom) {
                Image(data.image)
                    .resizable()
                    .scaledToFit()
                Image("onboardingBottom")
                    .resizable()
                    .scaledToFit()
                HDRoundedBtn(nameButton: "Next", completion:  {
                    completion()
                }, state: $state)
                .padding(.bottom, 40)
                .padding(.horizontal, 16)
            }
        }
        .accentColor(Color.allWhite)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    HDOnboardingCell(data: .init(image: "onboarding 1", title: "Manage your team!", paragraph: "Be your own trainer!"), cellCount: 3, activeDot: .constant(1), state: .constant(true), mainAnswer: true)
}

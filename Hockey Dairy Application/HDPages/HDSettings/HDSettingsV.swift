//
//  HDSettingsV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI
import Combine

struct HDSettingsV: View {
    @ObservedObject var model: HDSettingsVM = HDSettingsVM()
    var cancellables = Set<AnyCancellable>()
    @State var openUsagePolicy: Bool = false
    private let link: String = "https://www.google.com"
    var body: some View {
        VStack {
            HDPageWr(content: {
                VStack {
                    NavigationLink(isActive: $openUsagePolicy, destination: {
                        HDWVManager(urlString: link)
                            .navigationBarTitleDisplayMode(.inline)
                    }, label: {EmptyView()})
                    VStack(spacing: 0, content: {
                        Button {
                            openUsagePolicy.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                ZStack(alignment: .bottom) {
                                    HStack {
                                        Text("Usage Policy")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                            }
                        }
                        .padding(15)
                        .background(Color.active)
                        
                        HStack {
                            HStack {}
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .background(Color.cellBorderBackground)
                        }
                        .padding(.leading, 40)
                        .background(Color.active)
                        
                        Button {
                            model.sharedApp()
                        } label: {
                            HStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                                Image(systemName: "square.and.arrow.up.fill")
                                ZStack(alignment: .bottom) {
                                    HStack {
                                        Text("Share App")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                            })
                        }
                        .padding(15)
                        .background(Color.active)
                        HStack {
                            HStack {}
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .background(Color.cellBorderBackground)
                        }
                        .padding(.leading, 40)
                        .background(Color.active)
                        Button {
                            model.rateApp()
                        } label: {
                            Image(systemName: "star.fill")
                            ZStack(alignment: .bottom) {
                                HStack {
                                    Text("Rate Us")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        .padding(15)
                        .background(Color.active)
                    })
                    .foregroundColor(Color.allWhite)
                    .cornerRadiusWithBorder(radius: 10, borderLineWidth: 0.5, borderColor: Color.cellBorderBackground, antialiased: true)
                    .padding(.top, 25)
                    Spacer()
                    HDRoundedBtn(nameButton: "Reset progress", completion: {
                        HDCombineManager.shared.value.send(true)
                        HDCombineManager.shared.value.send(false)
                    }, state: .constant(true), backgroundColor: Color.active)
                    .padding(.bottom, 20)
                }
            }, title: "Settings", showCreatNewToolbarItem: false)
        }
    }
}

#Preview {
    HDSettingsV()
}

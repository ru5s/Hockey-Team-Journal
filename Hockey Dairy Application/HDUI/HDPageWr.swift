//
//  HDPageWr.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDPageWr <Content: View>: View {
    @State var content: () -> Content
    @State var startChangeCompletion: () -> Void
    @State var changedCompletion: () -> Void
    @State var title: String
    @State var showChangesButton: Bool
    @State var deleteCompletion: () -> Void
    @State var changeData: Bool = false
    
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init(@ViewBuilder content: @escaping () -> Content, startChangeCompletion: @escaping () -> Void = {}, changedCompletion: @escaping () -> Void = {}, title: String, showCreatNewToolbarItem: Bool = true, deleteCompletion: @escaping () -> Void = {}) {
        self.content = content
        self.startChangeCompletion = startChangeCompletion
        self.changedCompletion = changedCompletion
        self.title = title
        self.showChangesButton = showCreatNewToolbarItem
        self.deleteCompletion = deleteCompletion
        
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.navigationBackground
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.allWhite]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.allWhite]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.allWhite
                    .ignoresSafeArea(.all, edges: [.trailing, .leading])
                content()
                    .padding(.horizontal, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showChangesButton {
                        if changeData {
                            HStack {
                                Button {
                                    changedCompletion()
                                    changeData.toggle()
                                } label: {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.active)
                                }
                                
                                Button {
                                    deleteCompletion()
                                    changeData.toggle()
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(Color.active)
                                }
                            }
                        } else {
                            Button {
                                startChangeCompletion()
                                changeData.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(Color.active)
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

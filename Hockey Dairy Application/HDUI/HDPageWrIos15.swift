//
//  HDPageWrIos15.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct HDPageWrIos15 <Content: View>: View {
    @State var content: () -> Content
    @State var startChangeCompletion: () -> Void
    @State var changedCompletion: () -> Void
    @State var title: String
    @State var showChangesButton: Bool
    @State var deleteCompletion: () -> Void
    @State var changeData: Bool = false
    @State var searchText: (String) -> Void
    let coloredNavAppearance = UINavigationBarAppearance()
    @Binding var bindsearchText: String
    init(@ViewBuilder content: @escaping () -> Content, startChangeCompletion: @escaping () -> Void = {}, changedCompletion: @escaping () -> Void = {}, title: String, showCreatNewToolbarItem: Bool = true, deleteCompletion: @escaping () -> Void = {}, searchText:@escaping (String) -> Void = {_ in}, bindsearchText: Binding<String>) {
        self.content = content
        self.startChangeCompletion = startChangeCompletion
        self.changedCompletion = changedCompletion
        self.title = title
        self.showChangesButton = showCreatNewToolbarItem
        self.deleteCompletion = deleteCompletion
        self.searchText = searchText
        _bindsearchText = bindsearchText
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.navigationBackground
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.allWhite]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.allWhite]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }

    var body: some View {
        NavigationView(content: {
            ZStack {
                Color.allWhite
                    .ignoresSafeArea()
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
            .onChange(of: bindsearchText, perform: { value in
                searchText(value)
            })
        })
        .searchable(text: $bindsearchText)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


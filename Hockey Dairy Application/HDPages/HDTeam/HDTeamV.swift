//
//  HDTeamV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDTeamV: View {
    @ObservedObject var model: HDTeamVM
    @State var blurBackground: Bool = false
    @State var playerType: HockeyPlayerTypeModel = .defence
    @State var addPlayer: Bool = false
    @State var openAboutPlayer: Bool = false
    @State var choosedPlayer: Player?
    @State var inventarType: HDInventoryType = .forEveryone
    var body: some View {
        ZStack {
            
            HDPageWr(content: {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HDTeamSection(title: "Forwards", type: .forward, completion: { type in
                            addPlayer.toggle()
                            playerType = .forward
                            blurBackground.toggle()
                        }, data: $model.forwards, updateData: {
                            DispatchQueue.main.async {
                                model.fetchData()
                            }
                        }, model: model, inventarType: $inventarType)
                        HDTeamSection(title: "Defence", type: .defence, completion: { type in
                            addPlayer.toggle()
                            playerType = .defence
                            blurBackground.toggle()
                        }, data: $model.defence, updateData: {
                            DispatchQueue.main.async {
                                model.fetchData()
                            }
                        }, model: model, inventarType: $inventarType)
                        HDTeamSection(title: "Goalie", type: .goalie, completion: { type in
                            addPlayer.toggle()
                            playerType = .goalie
                            blurBackground.toggle()
                        }, data: $model.goalie, updateData: {
                            DispatchQueue.main.async {
                                model.fetchData()
                            }
                        }, model: model, inventarType: $inventarType)
                    }
                }
            }, title: "Team", showCreatNewToolbarItem: false)
            .blur(radius: !blurBackground ? 0 : 3)
            
            if blurBackground {
                Rectangle()
                    .animation(.easeInOut(duration: 1.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.black.opacity(0.5))
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        blurBackground.toggle()
                    }
            }
        }
        .onChange(of: addPlayer, perform: { value in
            if value == false {
                blurBackground.toggle()
            }
        })
        .onAppear{
            DispatchQueue.main.async {
                model.fetchData()
            }
        }
        .sheet(isPresented: $addPlayer, content: {
            HDTeamAddPlayer(editMode: .constant(true), playerType: $playerType, dismiss: $addPlayer, playerCompletion: {
                DispatchQueue.main.async {
                    model.fetchData()
                }
            }, inventarType: inventarType, model: model)
            
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HDTeamV(model: HDTeamVM())
}

//
//  HDTeamInventoryAddV.swift
//  Hockey Team Journal
//
//  Created by Den on 04/03/24.
//

import SwiftUI

struct HDTeamInventoryAddV: View {
    @ObservedObject var model: HDTeamVM
    @State var choosedInventory = 0
    @State var player: Player
    @State private var forEvery: HDInventoryType = .forEveryone
    @State var typePlayer: HDInventoryType = .forDefence
    var body: some View {
        ZStack {
            if model.inventory.isEmpty {
                HDEmptyView(title: "Empty", subtitle: "You don’t have any inventory")
            } else {
                VStack {
                    ScrollView(showsIndicators: false, content: {
                        LazyVStack {
                            ForEach(Array(model.teamInventory.enumerated()), id: \.element.id) {index, inventory in
                                if (inventory.item.inventoryPosition == typePlayer.rawValue || inventory.item.inventoryPosition == forEvery.rawValue) {
                                    HDTeamInventoryCell(data: inventory.item, chooseInventory: $choosedInventory, currentIndex: index, choosed: {state in
                                        DispatchQueue.main.async {
                                            model.teamInventory[index].state.toggle()
                                            model.didSelectItem(item: inventory.item, player: player)
                                        }
                                    }, state: $model.teamInventory[index].state, havePlayerInventory: model.isItemInPlayerInventory(item: inventory.item, player: player))
                                }
                            }
                        }
                        .padding(.top, 20)
                    })
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.allWhite)
        .onAppear {
            model.getInventoryFetch(player: player)
            print("forEvery: \(forEvery), typePlayer: \(typePlayer)")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HDTeamInventoryAddV(model: HDTeamVM(), player: .init())
}

//
//  HDTeamInventoryForNewPlayer.swift
//  Hockey Team Journal
//
//  Created by Den on 05/03/24.
//

import SwiftUI

struct HDTeamInventoryForNewPlayer: View {
    @ObservedObject var model: HDTeamVM
    @State var choosedInventory = 0
    @State private var forEvery: HDInventoryType = .forEveryone
    @State var typePlayer: HDInventoryType = .forDefence
    @Binding var inventoryToPlayer: [Inventory?]
    var body: some View {
        ZStack {
            if model.inventory.isEmpty {
                    HDEmptyView(title: "Empty", subtitle: "You don’t have any inventory")
                } else {
                    VStack {
                        ScrollView(showsIndicators: false, content: {
                            LazyVStack {
                                ForEach(Array(model.teamInventory.enumerated()), id: \.element.id) {index, inventory in
                                    if inventory.item.inventoryPosition == typePlayer.rawValue || inventory.item.inventoryPosition == forEvery.rawValue {
                                        HDTeamInventoryCell(data: inventory.item, chooseInventory: $choosedInventory, currentIndex: index, choosed: {state in
                                            inventoryToPlayer.append(inventory.item)
                                            model.teamInventory[index].state.toggle()
                                        }, state: $model.teamInventory[index].state, havePlayerInventory: false)
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
            model.getInventoryFetch()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HDTeamInventoryForNewPlayer(model: HDTeamVM(), inventoryToPlayer: .constant([]))
}

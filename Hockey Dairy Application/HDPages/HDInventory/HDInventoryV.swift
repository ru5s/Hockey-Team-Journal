//
//  HDInventoryV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDInventoryV: View {
    @ObservedObject var model: HDInventoryVM
    @Binding var createNewInventory: Bool
    @Binding var openAboutInventory: Bool
    @Binding var choosedInventory: Inventory?
    var body: some View {
        if #available(iOS 15.0, *) {
            HDInventoryVNew(model: model, createNewInventory: $createNewInventory, openAboutInventory: $openAboutInventory, choosedInventory: $choosedInventory)
        } else {
            HDInventoryVOld(model: model, createNewInventory: $createNewInventory, openAboutInventory: $openAboutInventory, choosedInventory: $choosedInventory)
        }
    }
}

@available(iOS 15.0, *)
struct HDInventoryVNew: View {
    @ObservedObject var model: HDInventoryVM
    
    @State var searchText: String = ""
    @Binding var createNewInventory: Bool
    @Binding var openAboutInventory: Bool
    @Binding var choosedInventory: Inventory?
    var body: some View {
        HDPageWrIos15(content: {
            ZStack {
                if model.inventory.isEmpty {
                    HDEmptyView(title: "Empty", subtitle: "You don’t have any inventory")
                } else {
                    VStack {
                        ScrollView(showsIndicators: false, content: {
                            LazyVStack {
                                ForEach(model.searchInventory, id: \.invID) { inventory in
                                    HDInventoryCell(data: inventory, openAboutInventory: $openAboutInventory, choosed: {
                                        choosedInventory = inventory
                                    })
                                    .addButtonActions(leadingButtons: [], trailingButton: [.delete]) { button in
                                        withAnimation {
                                            HDCoreDataManager.shared.hdContainer.viewContext.delete(inventory)
                                            model.removeInventoryFromPlayers(inventoryItem: inventory)
                                            try? HDCoreDataManager.shared.save()
                                            model.getFetch()
                                        }
                                    }
                                }
                            }
                            .padding(.top, 30)
                        })
                        .padding(-16)
                    }
                }
                HDAddButton(touched: $createNewInventory, completion: { bool in
                })
            }
        }, title: "Inventory", showCreatNewToolbarItem: false, searchText: {text in
            withAnimation {
                model.search(text: text)
                if text.isEmpty {
                    model.searchInventory = model.inventory
                }
            }
        }, bindsearchText: $searchText)
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.getFetch()
            model.fetchPlayers()
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .lightGray
        }
        .onChange(of: searchText) { newValue in
        }
    }
}

//Old
struct HDInventoryVOld: View {
    @ObservedObject var model: HDInventoryVM
    
    @State var searchText: String = ""
    @Binding var createNewInventory: Bool
    @Binding var openAboutInventory: Bool
    @Binding var choosedInventory: Inventory?
    var body: some View {
        HDPageWr(content: {
            ZStack {
                if model.inventory.isEmpty {
                        HDEmptyView(title: "Empty", subtitle: "You don’t have any inventory")
                    } else {
                        VStack {
                            ScrollView(showsIndicators: false, content: {
                                HDSearchBar(text: $searchText, completion: {text in
                                    withAnimation {
                                        model.search(text: text)
                                        if text.isEmpty {
                                            model.searchInventory = model.inventory
                                        }
                                    }
                                })
                                .padding(.top, 15)
                                .padding(.horizontal, 16)
                                
                                LazyVStack {
                                    ForEach(model.searchInventory, id: \.invID) { inventory in
                                        HDInventoryCell(data: inventory, openAboutInventory: $openAboutInventory, choosed: {
                                            choosedInventory = inventory
                                        })
                                        .addButtonActions(leadingButtons: [], trailingButton: [.delete]) { button in
                                            withAnimation {
                                                HDCoreDataManager.shared.hdContainer.viewContext.delete(inventory)
                                                try? HDCoreDataManager.shared.save()
                                                model.getFetch()
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 10)
                            })
                            .padding(-16)
                        }
                    }
                    HDAddButton(touched: $createNewInventory, completion: { bool in
                    })
                }
        }, title: "Inventory", showCreatNewToolbarItem: false)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.getFetch()
        }
    }
}

#Preview {
    HDInventoryVOld(model: HDInventoryVM(), createNewInventory: .constant(false), openAboutInventory: .constant(false), choosedInventory: .constant(Inventory()))
}

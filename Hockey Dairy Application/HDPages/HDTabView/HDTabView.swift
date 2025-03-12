//
//  HDTabView.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDTabView: View {
    @ObservedObject var model: HDTabVM = HDTabVM()
    
    @State var updateData: Bool = false
    
    @ObservedObject var inventoryModel: HDInventoryVM = HDInventoryVM()
    @State var createNewInventory: Bool = false
    @State var openAboutInventory: Bool = false
    @State var choosedAboutInventory: Inventory?
    
    @ObservedObject var shopProductModel: HDShoppingListVM = HDShoppingListVM()
    @State var createNewShopProduct: Bool = false
    @State var openAboutShopProduct: Bool = false
    @State var choosedShopProduct: ShopProduct?
    
    @ObservedObject var playerModel: HDTeamVM = HDTeamVM()
    
    @ObservedObject var calendarModel: HDCalendarVM = HDCalendarVM()
    init() {
        UITabBar.appearance().backgroundColor = UIColor.navigationBackground
        UITabBar.appearance().barTintColor = UIColor.navigationBackground
        UITabBar.appearance().unselectedItemTintColor = UIColor.allWhite
        UITabBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        NavigationView(content: {
            ZStack {
                TabView {
                    HDTeamV(model: playerModel)
                        .tabItem {
                            Label("Team", systemImage: "person.3.fill")
                        }
                        .tag(0)
                    HDInventoryV(model: inventoryModel, createNewInventory: $createNewInventory, openAboutInventory: $openAboutInventory, choosedInventory: $choosedAboutInventory)
                        .tabItem {
                            Label("Inventory", systemImage: "backpack.fill")
                        }
                        .tag(1)
                    HDShoppingListV(model: shopProductModel, createNewShopProduct: $createNewShopProduct, openAboutShopProduct: $openAboutShopProduct, choosedShopProduct: $choosedShopProduct)
                        .tabItem {
                            Label("Shipping list", systemImage: "list.clipboard.fill")
                        }
                        .tag(2)
                    HDCalendarV(model: calendarModel)
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                        .tag(3)
                    HDSettingsV()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(4)
                }
                .accentColor(Color.active)
                .blur(radius:showBlurRectangle ? 3.0 : 0.0)
                
                if showBlurRectangle  {
                    Rectangle()
                        .animation(.easeInOut(duration: 1.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(Color.black.opacity(0.5))
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            createNewInventory = false
                            openAboutInventory = false
                            createNewShopProduct = false
                            openAboutShopProduct = false
                        }
                }
                HDCreateInventary(editMode: .constant(true), dismiss: $createNewInventory, updateData: {
                    inventoryModel.getFetch()
                }, choosedInventory: .constant(nil))
                .animation(.easeIn)
                
                HDCreateInventary(editMode: .constant(true), dismiss: $openAboutInventory, updateData: {
                    inventoryModel.getFetch()
                }, choosedInventory: $choosedAboutInventory)
                .animation(.easeIn)
                
                HDShoppingListItemV(editMode: .constant(true), dismiss:  $createNewShopProduct, updateData: {
                    shopProductModel.getFetch()
                }, choosedShopProduct: .constant(nil))
                .animation(.easeIn)
                HDShoppingListItemV(editMode: .constant(true), dismiss: $openAboutShopProduct, updateData: {
                    shopProductModel.getFetch()
                }, choosedShopProduct: $choosedShopProduct)
                .animation(.easeIn)
            }
            
            
        })
        .background(Color.green)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
 
            DispatchQueue.main.async {
                model.remoteDeletion(completion: {type in
                    switch type {
                    case .player:
                        playerModel.fetchData()
                    case .inventory:
                        inventoryModel.getFetch()
                    case .shop:
                        shopProductModel.getFetch()
                    case .calendar:
                        break
                    }
                })
            }
        })
    }
    private var showBlurRectangle: Bool {
        if createNewInventory || openAboutInventory || createNewShopProduct || openAboutShopProduct {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    HDTabView()
}

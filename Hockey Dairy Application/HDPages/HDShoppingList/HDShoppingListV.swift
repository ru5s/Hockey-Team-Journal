//
//  HDShoppingListV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDShoppingListV: View {
    @ObservedObject var model: HDShoppingListVM
    @Binding var createNewShopProduct: Bool
    @Binding var openAboutShopProduct: Bool
    @Binding var choosedShopProduct: ShopProduct?
    var body: some View {
        if #available(iOS 15.0, *) {
            HDShoppingListVNew(model: model, createShopProduct: $createNewShopProduct, openAboutShopProduct: $openAboutShopProduct, choosedShopProduct: $choosedShopProduct)
        } else {
            HDShoppingListVOld(model: model, createShopProduct: $createNewShopProduct, openAboutShopProduct: $openAboutShopProduct, choosedShopProduct: $choosedShopProduct)
        }
    }
}
@available(iOS 15.0, *)
struct HDShoppingListVNew: View {
    @ObservedObject var model: HDShoppingListVM

    @State var searchText: String = ""
    @Binding var createShopProduct: Bool
    @Binding var openAboutShopProduct: Bool
    @Binding var choosedShopProduct: ShopProduct?
    var body: some View {
        HDPageWrIos15(content: {
            ZStack {
                if model.shopProduct.isEmpty {
                    HDEmptyView(title: "Empty", subtitle: "You don’t have any shopping list")
                } else {
                    VStack {
                        ScrollView(showsIndicators: false, content: {
                            LazyVStack {
                                ForEach(model.searchShopProduct, id: \.id) { shopProduct in
                                    HDShoppintListCell(data: shopProduct, openAboutShopProduct: $openAboutShopProduct, choosed: {
                                        choosedShopProduct = shopProduct
                                    })
                                    .addButtonActions(leadingButtons: [], trailingButton: [.delete]) { button in
                                        withAnimation {
                                            HDCoreDataManager.shared.hdContainer.viewContext.delete(shopProduct)
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
                HDAddButton(touched: $createShopProduct, completion: { bool in
                })
            }
            
        }, title: "Shopping list", showCreatNewToolbarItem: false, searchText: {text in
            withAnimation {
                model.search(text: text)
                if text.isEmpty {
                    model.searchShopProduct = model.shopProduct
                }
            }
        }, bindsearchText: $searchText)
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.getFetch()
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .lightGray
        }
        .onChange(of: searchText) { newValue in
        }
    }
}
//Old
struct HDShoppingListVOld: View {
    @ObservedObject var model: HDShoppingListVM
    
    @State var searchText: String = ""
    @Binding var createShopProduct: Bool
    @Binding var openAboutShopProduct: Bool
    @Binding var choosedShopProduct: ShopProduct?
    var body: some View {
        HDPageWr(content: {
            ZStack {
                if model.shopProduct.isEmpty {
                        HDEmptyView(title: "Empty", subtitle: "You don’t have any shopping list")
                    } else {
                        VStack {
                            ScrollView(showsIndicators: false, content: {
                                HDSearchBar(text: $searchText, completion: {text in
                                    withAnimation {
                                        model.search(text: text)
                                        if text.isEmpty {
                                            model.searchShopProduct = model.shopProduct
                                        }
                                    }
                                })
                                .padding(.top, 15)
                                .padding(.horizontal, 16)
                                
                                LazyVStack {
                                    ForEach(model.searchShopProduct, id: \.id) { shopProduct in
                                        HDShoppintListCell(data: shopProduct, openAboutShopProduct: $openAboutShopProduct, choosed: {
                                            choosedShopProduct = shopProduct
                                        })
                                        .addButtonActions(leadingButtons: [], trailingButton: [.delete]) { button in
                                            withAnimation {
                                                HDCoreDataManager.shared.hdContainer.viewContext.delete(shopProduct)
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
                    HDAddButton(touched: $createShopProduct, completion: { bool in
                    })
                }
        }, title: "Shopping list", showCreatNewToolbarItem: false)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.getFetch()
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .lightGray
        }
    }
}

#Preview {
    HDShoppingListVOld(model: HDShoppingListVM(), createShopProduct: .constant(false), openAboutShopProduct: .constant(false), choosedShopProduct: .constant(ShopProduct()))
}

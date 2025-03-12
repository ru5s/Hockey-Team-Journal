//
//  HDShoppingListVM.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import Foundation
import CoreData
import Combine

class HDShoppingListVM: ObservableObject {
    @Published var shopProduct: [ShopProduct] = []
    @Published var searchShopProduct: [ShopProduct] = []
    @Published var coreError: String = "not error"
    func getFetch() {
        let fetchRequest: NSFetchRequest<ShopProduct> = ShopProduct.fetchRequest()
        do {
            let fetchShopProduct = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            shopProduct = fetchShopProduct
            searchShopProduct = fetchShopProduct
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    func search(text: String) {
        searchShopProduct = shopProduct.filter { inventoryItem in
            if let name = inventoryItem.name {
                return name.contains(text)
            }
            return false
        }
    }
}

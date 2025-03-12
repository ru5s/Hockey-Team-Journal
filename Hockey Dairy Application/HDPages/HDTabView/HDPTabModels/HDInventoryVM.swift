//
//  HDInventoryVM.swift
//  Hockey Team Journal
//
//  Created by Den on 28/02/24.
//

import Foundation
import CoreData
import Combine

class HDInventoryVM: ObservableObject {
    @Published var inventory: [Inventory] = []
    @Published var searchInventory: [Inventory] = []
    @Published var coreError: String = "not error"
    
    var players: [Player] = []
    
    func getFetch() {
        let fetchRequest: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        do {
            let fetchInventory = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            inventory = fetchInventory
            searchInventory = fetchInventory
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    func search(text: String) {
        searchInventory = inventory.filter { inventoryItem in
            if let name = inventoryItem.inventoryName {
                return name.contains(text)
            }
            return false
        }
    }
    
    func fetchPlayers() {
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            let fetchPlayer = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            players = fetchPlayer
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    
    func removeInventoryFromPlayers(inventoryItem: Inventory) {
        for player in players {
            if let playerInventory = player.inventar as? Set<Inventory>, playerInventory.contains(inventoryItem) {
                player.removeFromInventar(inventoryItem)
            }
        }
    }
}

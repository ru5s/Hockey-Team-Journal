//
//  HDTeamVM.swift
//  Hockey Team Journal
//
//  
//

import Foundation
import CoreData
import Combine

struct TeamInventoryModel: Hashable, Identifiable {
    var id: UUID = UUID()
    let item: Inventory
    var state: Bool
}

class HDTeamVM: ObservableObject {
    @Published var players: [Player] = []
    @Published var allEmptyType: Bool = true
    @Published var forwards: [Player] = []
    @Published var defence: [Player] = []
    @Published var goalie: [Player] = []
    @Published var inventory: [Inventory] = []
    @Published var coreError: String = "not error"
    
    @Published var teamInventory: [TeamInventoryModel] = []
    @Published var newPlayer: Player = .init(context: HDCoreDataManager.shared.hdContainer.viewContext)
    var itemsForNewPlayer: [Inventory] = []
    func checkAllType() {
        if forwards.isEmpty && defence.isEmpty && goalie.isEmpty {
            allEmptyType = true
        } else {
            allEmptyType = false
        }
    }

    func fetchData() {
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            let fetchPlayers = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            players = fetchPlayers
            
            forwards = players.filter({$0.position == 1})
            defence = players.filter({$0.position == 2})
            goalie = players.filter({$0.position == 3})
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    
    func getInventoryFetch() {
        let fetchRequest: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        do {
            let fetchInventory = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            inventory = fetchInventory
            self.teamInventory = []
            DispatchQueue.main.async {
                for inv in self.inventory {
                    self.teamInventory.append(.init(item: inv, state: false))
                }
            }
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    
    func getInventoryFetch(player: Player) {
        guard let playerInventory = player.inventar else {
            return
        }
        let fetchRequest: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        do {
            let fetchInventory = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            inventory = fetchInventory
            self.teamInventory = []
            DispatchQueue.main.async {
                for inv in self.inventory {
                    if playerInventory.contains(inv) {
                        self.teamInventory.append(.init(item: inv, state: true))
                    } else {
                        self.teamInventory.append(.init(item: inv, state: false))
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    
    func isItemInPlayerInventory(item: Inventory, player: Player) -> Bool {
        guard let playerInventory = player.inventar else {
            return false
        }
        if playerInventory.contains(item) {
            return true
        } else {
            return false
        }
    }
    
    func didSelectItem(item: Inventory, player: Player) {
            if let inventar = player.inventar {
                if inventar.contains(item) {
                    player.removeFromInventar(item)
                } else {
                    player.addToInventar(item)
                }
            }
        try? HDCoreDataManager.shared.save()
    }
    
    func didSelectItem(items: [Inventory?], player: Player) {
        if !items.isEmpty {
            for item in items {
                if let item = item {
                    if let inventar = player.inventar {
                        if inventar.contains(item) {
                            player.removeFromInventar(item)
                        } else {
                            player.addToInventar(item)
                        }
                    }
                }
            }
        }
    }
    
    func entityPlayer() {
        newPlayer = Player(context: HDCoreDataManager.shared.hdContainer.viewContext)
    }
    
    func addItemToNewPlayer(item: Inventory) {
        newPlayer.addToInventar(item)
    }
    
    func saveNewPlayer() {
        try? HDCoreDataManager.shared.save()
    }
}

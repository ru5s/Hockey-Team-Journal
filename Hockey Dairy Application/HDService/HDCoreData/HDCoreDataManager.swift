//
//  HDCoreDataManager.swift
//  Hockey Team Journal
//
//  
//

import CoreData
import UIKit

class HDCoreDataManager {
    static let shared = HDCoreDataManager()
    
    let hdContainer: NSPersistentCloudKitContainer = {
        return NSPersistentCloudKitContainer(name: "Hockey_Dairy_Application")
    }()
    
    init(inMemory: Bool = false) {
        
        if inMemory {
            hdContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        hdContainer.viewContext.automaticallyMergesChangesFromParent = true
        hdContainer.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory")
        }
        let dbURL = documentDirectory.appendingPathComponent("Hockey_Dairy_Application.sqlite")
        print("Path to database: \(dbURL.path)")
    }
    
    func save() throws {
        let context = hdContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func addInventoryToCore(image: UIImage?, name: String, position: Int16) {
        let invetory = Inventory(context: hdContainer.viewContext)
        invetory.invID = UUID()
        invetory.inventoryName = name
        invetory.inventoryPosition = position
        invetory.inventoryPhoto = image?.pngData()
        try? save()
    }
    func addPlayerToCore(image: UIImage?, name: String, birthDay: String, position: Int16) {
        let player = Player(context: hdContainer.viewContext)
        player.id = UUID()
        player.name = name
        player.dateOfBirth = birthDay
        player.photo = image?.pngData()
        player.position = position
        try? save()
    }
    func addPlayerToCore(_ pl: Player) {
        let player = Player(context: hdContainer.viewContext)
        player.id = UUID()
        player.name = pl.name
        player.dateOfBirth = pl.dateOfBirth
        player.photo = pl.photo
        player.position = pl.position
        player.inventar = pl.inventar
        try? save()
    }
    func addShopProductToCore(image: UIImage?, name: String, price: String, position: Int16) {
        let shopProduct = ShopProduct(context: hdContainer.viewContext)
        shopProduct.id = UUID()
        shopProduct.name = name
        shopProduct.price = price
        shopProduct.photo = image?.pngData()
        shopProduct.position = position
        try? save()
        
    }
    func addGameCalendar(date: Date, notes: [AdditionalInfo], opponent: String, photo: UIImage?, place: String, time: String, completion: @escaping (UUID) -> Void) {
        let calendar = GameCalendar(context: hdContainer.viewContext)
        calendar.id = UUID()
        calendar.date = date
        calendar.notes = []
        var temp: [String] = []
        for note in notes {
            temp.append(note.text)
        }
        print("core notes \(temp.count)")
        calendar.notes = temp
        calendar.opponent = opponent
        calendar.photo = photo?.pngData()
        calendar.place = place
        calendar.time = time
        try? save()
        completion(calendar.id ?? UUID())
    }
    func eraseData( entityName: String) {
        print("erase data in \(entityName)")
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try hdContainer.viewContext.execute(batchDeleteRequest)
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    func removeItemFromCoreData(id: UUID, type: HDEntityType) {
        switch type {
        case .player:
            if let findItem = searchPlayer(forUUID: id) {
                let context = hdContainer.viewContext
                context.delete(findItem)
                try? save()
            }
        case .inventory:
            if let findItem = searchInventory(forUUID: id) {
                let context = hdContainer.viewContext
                context.delete(findItem)
                try? save()
            }
        case .shopProduct:
            if let findItem = searchShoppingProduct(forUUID: id) {
                let context = hdContainer.viewContext
                context.delete(findItem)
                try? save()
            }
        case .calendar:
            if let findItem = searchCalendar(forUUID: id) {
                let context = hdContainer.viewContext
                context.delete(findItem)
                try? save()
            }
        }
    }

}

//search items
extension HDCoreDataManager {
    
    func searchPlayer (forUUID uuid: UUID) -> Player? {
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let results = try hdContainer.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func searchInventory (forUUID uuid: UUID) -> Inventory? {
        let fetchRequest: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let results = try hdContainer.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func searchShoppingProduct (forUUID uuid: UUID) -> ShopProduct? {
        let fetchRequest: NSFetchRequest<ShopProduct> = ShopProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let results = try hdContainer.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func searchCalendar (forUUID uuid: UUID) -> GameCalendar? {
        let fetchRequest: NSFetchRequest<GameCalendar> = GameCalendar.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let results = try hdContainer.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
}

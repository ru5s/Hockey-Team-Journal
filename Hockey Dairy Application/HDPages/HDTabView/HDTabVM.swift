//
//  HDTabVM.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import Foundation
import Combine

enum AllEntitiesInDelete {
    case player
    case inventory
    case shop
    case calendar
}

class HDTabVM: ObservableObject {
    
    var cancellable = Set<AnyCancellable>()
    
    func remoteDeletion(completion: @escaping (AllEntitiesInDelete) -> Void) {
        HDCombineManager.shared.value.sink { bool in
            if bool {
                HDCoreDataManager.shared.eraseData(entityName: HDEntityType.inventory.rawValue)
                completion(.inventory)
            }
        }
        .store(in: &cancellable)
        
        HDCombineManager.shared.value.sink { bool in
            if bool {
                HDCoreDataManager.shared.eraseData(entityName: HDEntityType.player.rawValue)
                completion(.player)
            }
        }
        .store(in: &cancellable)
        
        HDCombineManager.shared.value.sink { bool in
            if bool {
                HDCoreDataManager.shared.eraseData(entityName: HDEntityType.shopProduct.rawValue)
                completion(.shop)
            }
        }
        .store(in: &cancellable)
        HDCombineManager.shared.value.sink { bool in
            if bool {
                HDCoreDataManager.shared.eraseData(entityName: HDEntityType.calendar.rawValue)
                completion(.calendar)
            }
        }
        .store(in: &cancellable)
    }
}

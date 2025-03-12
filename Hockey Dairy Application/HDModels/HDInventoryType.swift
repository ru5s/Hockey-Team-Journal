//
//  HDInventoryType.swift
//  Hockey Team Journal
//
//  Created by Den on 28/02/24.
//

import Foundation

enum HDInventoryType: Int16, CaseIterable, Identifiable {
    case forForward
    case forDefence
    case forGoalie
    case forEveryone
    var id: HDInventoryType { self }
    func description() -> String {
        switch self {
        case .forForward:
            return "For forwards"
        case .forDefence:
            return "For defence"
        case .forGoalie:
            return "For goalie"
        case .forEveryone:
            return "For everyone"
        }
    }
}

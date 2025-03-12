//
//  HockeyPlayerTypeModel.swift
//  Hockey Team Journal
//
//  
//

import Foundation

enum HockeyPlayerTypeModel: Int16, CaseIterable, Identifiable {
    case all
    case forward
    case defence
    case goalie
    var id: HockeyPlayerTypeModel { self }
    func description() -> String {
        switch self {
        case .all:
            return "All players"
        case .forward:
            return "Forwards"
        case .defence:
            return "Defence"
        case .goalie:
            return "Goalie"
        }
    }
}

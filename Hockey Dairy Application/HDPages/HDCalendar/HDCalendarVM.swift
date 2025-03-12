//
//  HDCalendarVM.swift
//  Hockey Team Journal
//
//  Created by Den on 01/03/24.
//

import Foundation
import UIKit
import CoreData

struct AdditionalInfo: Identifiable, Hashable {
    let id: UUID = UUID()
    var text: String
}

struct Day : Identifiable, Hashable {
    var id = UUID()
    var date : String
    var month : String
    var special: Bool = false
    var itemId: UUID
    var until1970date: Date
}

class HDCalendarVM: ObservableObject {
    
    @Published var choosedBaner: GameCalendar?
    @Published var allDays : [Day] = []
    
    @Published var gameCalendar: [GameCalendar] = []
    @Published var coreError: String = "not error"
    let semaphore = DispatchSemaphore(value: 1)
    
    func getFetch() {
        let fetchRequest: NSFetchRequest<GameCalendar> = GameCalendar.fetchRequest()
        do {
            let fetchGameCalendar = try HDCoreDataManager.shared.hdContainer.viewContext.fetch(fetchRequest)
            gameCalendar = fetchGameCalendar
        } catch {
            print("Error fetching data: \(error)")
            coreError = "Error fetching data: \(error)"
        }
    }
    
    func updateCalendarDays() {
        getFetch()
        for index in allDays.indices {
            allDays[index].special = false
        }
        let formatter = DateFormatter()
        for index in allDays.indices {
            for calendar in gameCalendar {
                if calendar.date?.nameOfMonth(withFormatter: formatter) == allDays[index].month {
                    if getDay(date: calendar.date ?? Date()) == Int(allDays[index].date) {
                        allDays[index].special = true
                        allDays[index].itemId = calendar.id ?? UUID()
                    }
                }
            }
        }
    }
    
    func generateDays(number: Int, completion: @escaping () -> Void){
        let today = Date(timeIntervalSince1970: 1706727600)
        let formatter = DateFormatter()
        self.allDays = (0..<number).map { index -> Day in
            let date = Calendar.current.date(byAdding: .day, value: index, to: today) ?? Date()
            var value = false
            var specialId: UUID?
            for calendar in gameCalendar {
                if calendar.date?.nameOfMonth(withFormatter: formatter) == date.nameOfMonth(withFormatter: formatter) {
                    if getDay(date: calendar.date ?? Date()) == Calendar.current.component(.day, from: date) {
                        value = true
                        specialId = calendar.id
                    }
                }
            }
            return Day(
                date: "\(Calendar.current.component(.day, from: date))",
                month: date.nameOfMonth(withFormatter: formatter) ?? "",
                special: value,
                itemId: specialId ?? UUID(),
                until1970date: date)
        }
        completion()
    }
    
    private func getDay(date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        return Int(day) ?? 0
    }
}

//
//  HDCalendarV.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDCalendarV: View {
    @ObservedObject var model: HDCalendarVM
    @State private var selectedIndex: Int = 0
    @State var touchedAddButton: Bool = false
    @State var openCurrenBaner: Bool = false
    @State var choosedBaner: GameCalendar?
    @State var currentDayIndex: Int?
    let date = Date()
    @State var choosedIndex = 0
    @State var choosedUUID: UUID?
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State var additionalInfo: [AdditionalInfo]?
    var body: some View {
        HDPageWr(content: {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        ZStack(alignment: .top) {
                            ScrollViewReader { proxy in
                                ScrollView(.horizontal, showsIndicators: false, content: {
                                    
                                    LazyHStack(spacing: 0 ,content: {
                                        ForEach(Array(model.allDays.enumerated()), id:\.element.id) { index, element in
                                            HDCalendarCell(haveDate: $model.allDays[index].special, activeTab: $choosedIndex, currentIndex: index, day: element.date, mounth: element.month, completion: {chooseIndex in
                                                withAnimation {
                                                    choosedIndex = chooseIndex
                                                    scrollProxy?.scrollTo(chooseIndex, anchor: .center)
                                                    choosedUUID = element.id
                                                    DispatchQueue.main.async {
                                                        model.choosedBaner =  HDCoreDataManager.shared.searchCalendar(forUUID: model.allDays[choosedIndex].itemId)
                                                    }
                                                }
                                            })
                                            .onAppear {
                                                scrollProxy = proxy
                                            }
                                            .id(index)
                                        }
                                        .onAppear {
                                            DispatchQueue.main.async {
                                                choosedIndex = currentDayIndex ?? 0
                                                scrollProxy?.scrollTo(currentDayIndex, anchor: .center)
                                            }
                                        }
                                        .id("ScrollContent")
                                        .onChange(of: choosedIndex, perform: { _ in })
                                        .onChange(of: choosedBaner) { _ in }
                                    })
                                    .background(Color.navigationBackground)
                                })
                            }
                            .background(Color.navigationBackground)
                            .padding(.horizontal, -16)
                            .frame(height: 80)
                            
                            Rectangle()
                                .foregroundColor(Color.allWhite.opacity(0.5))
                                .frame(height: 1)
                                .padding(.horizontal, -16)
                        }
                        .padding(.bottom, 10)
                        HDBigBanner(choosedElement: $model.choosedBaner, completion: {choosedItem in
                            openCurrenBaner.toggle()
                        })
                        .frame(maxWidth: 600)
                        Spacer()
                    }
                    HDAddButton(touched: $touchedAddButton, completion: {_ in })
                }
                //new data
                .fullScreenCover(isPresented: $touchedAddButton, content: {
                    HDCalendarAbout(editMode: true, additionalInfo: [], data: .constant(nil), dismiss: $touchedAddButton, updateData: { state in
                        model.updateCalendarDays()
                    }, onDelete: {
                        model.allDays[choosedIndex].special = false
                        model.choosedBaner = nil
                    }, sendUUID: {uuid in
                        model.allDays[choosedIndex].special = true
                        model.choosedBaner =  HDCoreDataManager.shared.searchCalendar(forUUID: uuid)
                    })
                })
                //have data
                .fullScreenCover(isPresented: $openCurrenBaner, content: {
                    HDCalendarAbout(editMode: false, additionalInfo: additionalInfo ?? [], data: $model.choosedBaner, dismiss: $openCurrenBaner, updateData: { state in
                        if state {
                            model.allDays[choosedIndex].special = false
                            model.choosedBaner = nil
                        } else {
                            model.choosedBaner =  HDCoreDataManager.shared.searchCalendar(forUUID: model.allDays[choosedIndex].itemId)
                            model.updateCalendarDays()
                        }
                    }, onDelete: {
                        model.allDays[choosedIndex].special = false
                        model.choosedBaner = nil
                        model.updateCalendarDays()
                    }, sendUUID: {uuid in
                        choosedUUID = uuid
                        model.allDays[choosedIndex].special = true
                        model.choosedBaner =  HDCoreDataManager.shared.searchCalendar(forUUID: uuid)
                        model.updateCalendarDays()
                    })
                })
                .onAppear {
                    DispatchQueue.main.async {
                        model.getFetch()
                        model.generateDays(number: 365, completion: {})
                        currentDayFunc()
                        if model.choosedBaner != nil {
                            for note in model.choosedBaner?.notes ?? []{
                                additionalInfo?.append(.init(text: note))
                            }
                        }
                    }
                }
            }
        }, title: "Game calendar", showCreatNewToolbarItem: false)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        return day
    }
    
    private func getMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let monthAbbreviation = dateFormatter.string(from: date)
        return monthAbbreviation
    }
    
    func currentDayFunc(){
        let formatter = DateFormatter()
        
        let day = "\(Calendar.current.component(.day, from: date))"
        let month = date.nameOfMonth(withFormatter: formatter)
        for (index, item) in model.allDays.enumerated() {
            if item.date == day && item.month == month {
                currentDayIndex = index
                DispatchQueue.main.async {
                    model.choosedBaner = model.gameCalendar.first(where: {$0.id == item.itemId})
                }
            }
        }
    }
}

#Preview {
    HDCalendarV(model: HDCalendarVM())
}

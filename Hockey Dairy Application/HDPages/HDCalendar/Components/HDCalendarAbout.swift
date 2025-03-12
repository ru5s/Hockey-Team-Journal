//
//  HDCalendarAbout.swift
//  Hockey Team Journal
//
//  Created by Den on 01/03/24.
//

import SwiftUI

struct HDCalendarAbout: View {
    let coloredNavAppearance = UINavigationBarAppearance()
    @State var title: String = "Game vs Toronto"
    @State var editMode: Bool = false
    @State var stringDate: String = ""
    @State var date: Date = Date()
    @State var stringTime: String = ""
    @State var opponent: String = ""
    @State var place: String = ""
    @State var additionalInfo: [AdditionalInfo]
    @Binding var data: GameCalendar?
    @State var isShowingImagePicker: Bool = false
    @State private var image: UIImage?
    @Binding var dismiss: Bool
    @State var updateData: (Bool) -> Void = {_ in}
    @State var onDelete: () -> Void = {}
    @State var sendUUID: (UUID) -> Void = {_ in}
    @State var changeDate: Bool = false
    @State private var uuid: UUID?
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160, alignment: .center)
                            .background(Color.allWhite)
                            .cornerRadius(10)
                            .padding(.vertical, 20)
                    } else {
                        Image("emptyImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160, alignment: .center)
                            .background(Color.allWhite)
                            .cornerRadius(10)
                            .padding(.vertical, 20)
                    }
                    if editMode {
                        Text("set new photo")
                            .foregroundColor(Color.navigationBackground)
                            .padding(.top, -20)
                            .padding(.bottom, 10)
                            .onTapGesture {
                                isShowingImagePicker.toggle()
                            }
                    }
                    VStack(spacing: 0) {
                        HDCalendarDatePicker(date: $stringDate, completion: {value in
                            date = value
                            let oldDate = stringDate
                            let lastValue = fullDate(date: value)
                            if oldDate != lastValue {
                                changeDate = true
                            }
                        }, incomeDate: data?.date, editMode: $editMode)
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(Color.allWhite.opacity(0.5))
                        HDCalendarTimePicker(time: $stringTime, completion: {time in
                            stringTime = time
                        }, editMode: $editMode)
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(Color.allWhite.opacity(0.5))
                        HDCalendarTextField(text: $opponent, placeholder: "Opponent: ", editMode: $editMode, completion: {editedOpponent in
                            opponent = editedOpponent
                        })
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(Color.allWhite.opacity(0.5))
                        HDCalendarTextField(text: $place, placeholder: "Location: ", editMode: $editMode, completion: {editedPlace in
                            place = editedPlace
                        })
                    }
                    .background(Color.active)
                    .cornerRadius(10)
                    
                    HStack {
                        Text("Additional Info")
                            .font(Font.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.active)
                        Spacer()
                        if editMode {
                            Button {
                                let newItem: AdditionalInfo = .init(text: "")
                                additionalInfo.append(newItem)
                            } label: {
                                Image(systemName: "plus.app")
                                    .foregroundColor(Color.active)
                                    .scaleEffect(1.3)
                            }
                        }
                    }
                    .padding(.top, 15)
                    VStack(content: {
                        ForEach($additionalInfo, id: \.id) {text in
                            HDCalendarAdditionalInfo(editMode: $editMode, text: text.text, completion: { newText in
                                additionalInfo.removeAll(where: {$0.text == newText})
                            })
                        }
                    })
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle(title)
            .background(Color.allWhite)
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(Color.navigationBackground)
            .sheet(isPresented: $isShowingImagePicker, onDismiss: loadPicture, content: {
                ImagePicker(image: $image)
                    .preferredColorScheme(.light)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    
                    Button {
                        dismiss.toggle()
                        updateData(false)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.active)
                        Text("Back")
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if editMode {
                            Button {
                                editMode.toggle()
                                if data == nil {
                                    HDCoreDataManager.shared.addGameCalendar(date: date, notes: additionalInfo, opponent: opponent, photo: image, place: place, time: stringTime, completion: {uuidCore in
                                        sendUUID(uuidCore)
                                        updateData(false)
                                    })
                                } else {
                                    data?.date = date
                                    data?.notes = []
                                    data?.notes?.append(contentsOf: additionalInfo.map({$0.text}))
                                    data?.opponent = opponent
                                    data?.photo = image?.pngData()
                                    data?.place = place
                                    data?.time = stringTime
                                    
                                    try? HDCoreDataManager.shared.save()
                                }
                                
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.green)
                            }
                        } else {
                            Button {
                                editMode.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(Color.active)
                            }
                        }
                        Button {
                            if let item = data, data != nil {
                                HDCoreDataManager.shared.removeItemFromCoreData(id: item.id ?? UUID(), type: .calendar)
                            }
                            dismiss.toggle()
                            onDelete()
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.red)
                        }
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            onApperPage()
            title = "Game vs " + (data?.opponent ?? "")
            stringDate = fullDate(date: data?.date ?? Date())
            stringTime = data?.time ?? ""
            opponent = data?.opponent ?? ""
            place = data?.place ?? ""
            additionalInfo.removeAll()
            for note in data?.notes ?? [] {
                print("note \(note)")
                additionalInfo.append(.init(text: note))
            }
            image = UIImage(data: (data?.photo ?? UIImage(named: "emptyImage")?.pngData()) ?? Data())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private func onApperPage() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.navigationBackground
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.allWhite]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.allWhite]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    private func time(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
    private func fullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    func loadPicture() {
        
    }
}

#Preview {
    HDCalendarAbout(additionalInfo: [], data: .constant(.init(context: HDCoreDataManager.shared.hdContainer.viewContext)), dismiss: .constant(false))
}

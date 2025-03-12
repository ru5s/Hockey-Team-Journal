//
//  HDAboutPlayer.swift
//  Hockey Team Journal
//
//  Created by Den on 27/02/24.
//

import SwiftUI

struct HDAboutPlayer: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var editMode: Bool = false
    @State private var image: UIImage?
    @State private var isShowingImagePicker: Bool = false
    @State private var name: String = ""
    @State private var date: String = ""
    @State private var openTypeAlert: Bool = false
    @State var playerType: HockeyPlayerTypeModel
    @State private var playerTypeChoosed: Bool = false
    @State private var allFilled: Bool = false
    @Binding var dismiss: Bool
    @State var playerCompletion: (Player) -> Void
    @State var data: Player
    @State var updateData: () -> Void
    @State var openInventoryList: Bool = false
    @ObservedObject var model: HDTeamVM
    @State var inventarType: HDInventoryType = .forEveryone
    var body: some View {
        GeometryReader(content: { geometry in
            
            ZStack(alignment: .top) {
                NavigationLink(isActive: $openInventoryList, destination: {
                    HDTeamInventoryAddV(model: model, player: data, typePlayer: inventarType)
                }, label: {EmptyView()})
                VStack {
                    let frameWidth = geometry.size.width / 2.5
                    VStack {
                        if let image = data.photo {
                            if let uiImage = UIImage(data: image) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: frameWidth, height: frameWidth, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        } else {
                            Image("emptyImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameWidth, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        if editMode {
                            Text("set new photo")
                                .foregroundColor(Color.navigationBackground)
                                .onTapGesture {
                                    isShowingImagePicker.toggle()
                                }
                        }
                    }
                    .padding(20)
                    .background(Color.active)
                    .cornerRadius(12)
                    Spacer()
                    HDRoundedTextField(text: $name, placeholder: "Name: ", editMode: $editMode, sheetOrPage: false, completion: {text in
                        name = text
                        data.name = text
                        checkFild()
                    })
                    .padding(.top, 10)
                    
                    HDRoundedDatePicker(date: $date, completion: {value in
                        date = value
                        data.dateOfBirth = value
                        checkFild()
                    }, editMode: $editMode, sheetOfPage: false)
                    
                    HDRoundedPositionField(position: $playerType, openAlert: $openTypeAlert, editMode: $editMode, completion: { type in
                        playerTypeChoosed = true
                        playerType = type
                        data.position = type.rawValue
                        checkFild()
                    }, sheetOrPage: false)
                    .padding(.bottom, 20)
                    
                    Button {
                        openInventoryList.toggle()
                    } label: {
                        HStack {
                            Group {
                                Text("Inventory")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(Color.allWhite)
                        }
                        .frame(maxHeight: 30)
                        .padding(16)
                        .background(Color.active)
                        .cornerRadius(10)
                    }
                    Spacer()
                    
                }
                .padding(16)
                .background(Color.allWhite)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage, content: {
                    ImagePicker(image: $image)
                        .preferredColorScheme(.light)
                })
                HDPositionAlert(dismis: $openTypeAlert) { type in
                    playerType = type
                }
                .animation(.easeIn)
            }
            
        })
        .onAppear {
            name = data.name ?? ""
            date = data.dateOfBirth ?? ""
            playerType = HockeyPlayerTypeModel(rawValue: data.position) ?? .forward
            checkFild()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if editMode {
                    HStack {
                        Button {
                            editMode.toggle()
                            dismiss.toggle()
                            DispatchQueue.main.async {
                                try? HDCoreDataManager.shared.save()
                                self.updateData()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.green)
                        }
                        Button {
                            DispatchQueue.main.async {
                                editMode.toggle()
                                dismiss.toggle()
                                HDCoreDataManager.shared.removeItemFromCoreData(id: data.id ?? UUID(), type: .player)
                                self.updateData()
                            }
                            
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.red)
                        }
                    }
                } else {
                    Button {
                        editMode.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Color.active)
                    }
                }
            }
        }
    }
    
    func loadImage() {
        data.photo = image?.pngData()
        updateData()
    }
    
    private func checkFild() {
        if !name.isEmpty && !date.isEmpty {
            allFilled = true
        } else {
            allFilled = false
        }
        
    }
}




#Preview {
    HDAboutPlayer(playerType: .defence, dismiss: .constant(false), playerCompletion: {_ in}, data: .init(), updateData: {}, model: HDTeamVM())
}

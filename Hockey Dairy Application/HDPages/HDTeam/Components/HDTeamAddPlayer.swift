//
//  HDTeamAddPlayer.swift
//  Hockey Team Journal
//
//  Created by Den on 27/02/24.
//

import SwiftUI

struct HDTeamAddPlayer: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var image: UIImage?
    @State private var isShowingImagePicker: Bool = false
    @State private var name: String = ""
    @Binding var editMode: Bool
    @State private var date: String = ""
    @State private var openTypeAlert: Bool = false
    @Binding var playerType: HockeyPlayerTypeModel
    @State private var playerTypeChoosed: Bool = false
    @State private var allFilled: Bool = false
    @Binding var dismiss: Bool
    @State var playerCompletion: () -> Void
    @State var openInventoryList: Bool = false
    @State var inventarType: HDInventoryType = .forEveryone
    @ObservedObject var model: HDTeamVM
    
    @State var bindingInventary: [Inventory?] = []
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .top) {
                VStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 36, height: 5, alignment: .center)
                        .foregroundColor(Color.active.opacity(0.16))
                    ZStack {
                        HStack {
                            Button {
                                dismiss.toggle()
                            } label: {
                                HDIconCloseButton()
                                    .frame(width: 24, height: 24, alignment: .center)
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Add player")
                                .foregroundColor(Color.active)
                                .font(Font.system(size: 17, weight: .semibold))
                            Spacer()
                        }
                    }
                    let frameWidth = geometry.size.width / 2.5
                    VStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: frameWidth, height: frameWidth, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
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
                    HDRoundedTextField(text: $name, placeholder: "Name: ", editMode: $editMode, sheetOrPage: true, completion: {text in
                        name = text
                        checkFild()
                    })
                        .padding(.top, 10)

                    HDRoundedDatePicker(date: $date, completion: {value in
                        date = value
                        checkFild()
                    }, editMode: $editMode, sheetOfPage: true)
                    
                    HDRoundedPositionField(position: $playerType, openAlert: $openTypeAlert, editMode: $editMode, completion: { type in
                        playerTypeChoosed = true
                        playerType = type
                        checkFild()
                    }, sheetOrPage: true)
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
                    
                    HDRoundedBtn(nameButton: "Save", completion: {
                        
                        model.newPlayer.id = UUID()
                        model.didSelectItem(items: bindingInventary, player: model.newPlayer)
                        model.newPlayer.photo = image?.pngData()
                        model.newPlayer.name = name
                        model.newPlayer.dateOfBirth = date
                        model.newPlayer.position = playerType.rawValue
                        model.saveNewPlayer()
                        playerCompletion()
                        dismiss.toggle()
                    }, state: $allFilled)
                        .padding(.top, 130)
                }
                .padding(16)
                .background(Color.allWhite)
                .ignoresSafeArea(.all, edges: .bottom)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage, content: {
                    ImagePicker(image: $image)
                        .preferredColorScheme(.light)
                })
                .gesture(DragGesture()
                    .onChanged { value in
                        if value.startLocation.y < value.location.y {
                            dismiss = false
                        }
                    }
                )
                
                HDPositionAlert(dismis: $openTypeAlert) { type in
                    playerType = type
                }
                .animation(.easeIn)
            }
            
        })
        .onAppear {
            checkFild()
            model.entityPlayer()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .sheet(isPresented: $openInventoryList, content: {
            HDTeamInventoryForNewPlayer(model: model,typePlayer: inventarType, inventoryToPlayer: $bindingInventary)
        })
    }
    
    func loadImage() {
        
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
    HDTeamAddPlayer(editMode: .constant(true), playerType: .constant(.defence), dismiss: .constant(false), playerCompletion: {}, model: HDTeamVM())
}

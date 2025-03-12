//
//  HDCreateInventary.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import SwiftUI

struct HDCreateInventary: View {
    @State private var image: UIImage?
    @State private var isShowingImagePicker: Bool = false
    @State private var name: String = ""
    @Binding var editMode: Bool
    @State private var openTypeAlert: Bool = false
    @State var inventoryType: HDInventoryType?
    @State private var playerTypeChoosed: Bool = false
    @State private var allFilled: Bool = false
    @Binding var dismiss: Bool
    @State var updateData: () -> Void
    @Binding var choosedInventory: Inventory?
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
                            Text("Add element")
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
                    
                    HDRoundedTextField(text: $name, placeholder: "What element: ", editMode: $editMode, sheetOrPage: true, completion: {text in
                        name = text
                        checkFild()
                    })
                        .padding(.top, 10)

                    HDInventoryTypeField(position: $inventoryType, openAlert: $openTypeAlert, editMode: $editMode, completion: { type in
                        playerTypeChoosed = true
                        inventoryType = type
                        checkFild()
                    }, sheetOrPage: true)
                    .padding(.bottom, 20)
                    
                    HDRoundedBtn(nameButton: "Save", completion: {
                        if choosedInventory == nil {
                            DispatchQueue.main.async {
                                HDCoreDataManager.shared.addInventoryToCore(image: image, name: name, position: inventoryType?.rawValue ?? 3)
                                name = ""
                                inventoryType = nil
                                image = UIImage(named: "emptyImage")
                                updateData()
                            }
                        } else {
                            DispatchQueue.main.async {
                                choosedInventory?.inventoryName = name
                                choosedInventory?.inventoryPosition = inventoryType?.rawValue ?? 3
                                choosedInventory?.inventoryPhoto = image?.pngData()
                                try? HDCoreDataManager.shared.save()
                                updateData()
                            }
                        }
                        dismiss.toggle()
                        
                    }, state: $allFilled)
                        .padding(.top, 50)
                    Spacer()
                }
                .padding(16)
                .background(Color.allWhite)
                .cornerRadius(20)
                .ignoresSafeArea(.all, edges: .bottom)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage, content: {
                    ImagePicker(image: $image)
                        .preferredColorScheme(.light)
                })
                .gesture(DragGesture()
                    .onChanged { value in
                        if value.startLocation.y < value.location.y {
                            dismiss = false
                            name = ""
                            inventoryType = nil
                            image = UIImage(named: "emptyImage")
                        }
                    }
                )
                
                HDInventoryAlert(dismis: $openTypeAlert) { type in
                    inventoryType = type
                }
                .animation(.easeIn)
            }
        })
        .offset(y: dismiss ? 100 : 1000)
        .frame(maxHeight: 700)
        .onAppear {
            checkFild()
        }
        .onChange(of: choosedInventory, perform: { value in
            if choosedInventory != nil {
                if let dataImage = choosedInventory?.inventoryPhoto {
                    image = UIImage(data: dataImage)
                }
                name = choosedInventory?.inventoryName ?? ""
                inventoryType = HDInventoryType(rawValue: choosedInventory?.inventoryPosition ?? 3)
            }
            checkFild()
        })
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    }
    
    func loadImage() {
        
    }
    
    private func checkFild() {
        if !name.isEmpty && (inventoryType != nil) {
            allFilled = true
        } else {
            allFilled = false
        }
    }
}

#Preview {
    HDCreateInventary(editMode: .constant(true), dismiss: .constant(false), updateData: {}, choosedInventory: .constant(Inventory()))
}

//
//  HDShoppingListItemV.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import SwiftUI

struct HDShoppingListItemV: View {
    @State private var image: UIImage?
    @State private var isShowingImagePicker: Bool = false
    @State private var name: String = ""
    @State private var price: String = ""
    @Binding var editMode: Bool
    @State private var openTypeAlert: Bool = false
    @State var shopItemType: HDInventoryType?
    @State private var playerTypeChoosed: Bool = false
    @State private var allFilled: Bool = false
    @Binding var dismiss: Bool
    @State var updateData: () -> Void
    @Binding var choosedShopProduct: ShopProduct?
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
                    .padding(.top, 24)
                    
                    HDInventoryTypeField(position: $shopItemType, openAlert: $openTypeAlert, editMode: $editMode, completion: { type in
                        playerTypeChoosed = true
                        shopItemType = type
                        checkFild()
                    }, sheetOrPage: true)
                    .padding(.top, 10)
                    
                    HDRoundedTextField(text: $price, placeholder: "Price: ", numberMode: true, editMode: $editMode, sheetOrPage: true, completion: {text in
                        price = text
                        checkFild()
                    })
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    HDRoundedBtn(nameButton: "Save", completion: {
                        if choosedShopProduct == nil {
                            DispatchQueue.main.async {
                                HDCoreDataManager.shared.addShopProductToCore(image: image, name: name, price: price, position: shopItemType?.rawValue ?? 3)
                                name = ""
                                shopItemType = nil
                                image = UIImage(named: "emptyImage")
                                price = ""
                                updateData()
                            }
                        } else {
                            DispatchQueue.main.async {
                                choosedShopProduct?.name = name
                                choosedShopProduct?.position = shopItemType?.rawValue ?? 3
                                choosedShopProduct?.photo = image?.pngData()
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
                            shopItemType = nil
                            image = UIImage(named: "emptyImage")
                            price = ""
                        }
                    }
                )
                HDInventoryAlert(dismis: $openTypeAlert) { type in
                    shopItemType = type
                }
                .animation(.easeIn)
            }
            
        })
        .offset(y: dismiss ? 50 : 1100)
        .frame(maxHeight: 800)
        .onAppear {
            checkFild()
        }
        .onChange(of: choosedShopProduct, perform: { value in
            if choosedShopProduct != nil {
                if let dataImage = choosedShopProduct?.photo {
                    image = UIImage(data: dataImage)
                }
                name = choosedShopProduct?.name ?? ""
                shopItemType = HDInventoryType(rawValue: choosedShopProduct?.position ?? 3)
                price = choosedShopProduct?.price ?? ""
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
        if !name.isEmpty && (shopItemType != nil) && !price.isEmpty {
            allFilled = true
        } else {
            allFilled = false
        }
    }
}

#Preview {
    HDShoppingListItemV(editMode: .constant(true), dismiss: .constant(false), updateData: {}, choosedShopProduct: .constant(ShopProduct()))
}

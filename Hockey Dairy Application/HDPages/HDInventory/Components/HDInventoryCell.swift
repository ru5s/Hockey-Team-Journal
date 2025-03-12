//
//  HDInventoryCell.swift
//  Hockey Team Journal
//
//  Created by Den on 28/02/24.
//

import SwiftUI

struct HDInventoryCell: View {
    @State var data: Inventory?
    @Binding var openAboutInventory: Bool
    @State var choosed: () -> Void = {}
    var body: some View {
            VStack {
                HStack {
                    Image(uiImage: convertImage())
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 80, maxHeight: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        HDBaloonTag(titile: HDInventoryType(rawValue: data?.inventoryPosition ?? 0)?.description() ?? "")
                        Spacer()
                        Text(data?.inventoryName ?? "No name")
                            .foregroundColor(Color.allWhite)
                            .font(Font.system(size: 25, weight: .semibold))
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    
                }
                .padding(16)
            }
            .frame(maxHeight: 120)
            .background(Color.active)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            
        .onTapGesture {
            openAboutInventory.toggle()
            choosed()
        }
    }
    
    private func convertImage() -> UIImage {
        if let imageData = data?.inventoryPhoto {
            return UIImage(data: imageData) ?? UIImage()
        } else {
            return UIImage(named: "emptyImage") ?? UIImage()
        }
    }
}

#Preview {
    HDInventoryCell(openAboutInventory: .constant(false))
}

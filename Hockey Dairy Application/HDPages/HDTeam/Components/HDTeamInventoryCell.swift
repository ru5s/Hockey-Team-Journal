//
//  HDTeamInventoryCell.swift
//  Hockey Team Journal
//
//  Created by Den on 04/03/24.
//

import SwiftUI

struct HDTeamInventoryCell: View {
    @State var data: Inventory?
    @Binding var chooseInventory: Int
    @State var currentIndex: Int = 0
    @State var choosed: (Bool) -> Void = {_ in}
    @Binding var state: Bool
    @State var havePlayerInventory: Bool = false
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
                Circle()
                    .frame(width: 22, height: 22, alignment: .center)
                    .foregroundColor(Color.allWhite)
                    .overlay(
                        Circle()
                            .scaleEffect(0.9)
                            .foregroundColor(state  ? Color.navigationBackground : Color.active)
                    )
            }
            .padding(16)
        }
        .frame(maxHeight: 120)
        .background(state  ? Color.cellInventarChoosedBackground : Color.active)
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .onTapGesture {
            choosed(state)
        }
        .onAppear {
            print("item have \(havePlayerInventory)")
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
    HDTeamInventoryCell(chooseInventory: .constant(0), state: .constant(true))
}

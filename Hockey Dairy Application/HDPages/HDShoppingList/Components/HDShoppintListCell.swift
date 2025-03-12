//
//  HDShoppintListCell.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import SwiftUI

struct HDShoppintListCell: View {
    @State var data: ShopProduct?
    @Binding var openAboutShopProduct: Bool
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
                    HDBaloonTag(titile: HDInventoryType(rawValue: data?.position ?? 0)?.description() ?? "")
                    Spacer()
                    Text(data?.name ?? "No name")
                        .foregroundColor(Color.allWhite)
                        .font(Font.system(size: 25, weight: .semibold))
                        .padding(.bottom, 5)
                }
                Spacer()
                Text("$" + (data?.price ?? "0"))
                    .foregroundColor(Color.allWhite)
                    .font(Font.system(size: 20, weight: .semibold))
                    .padding(.bottom, 5)
            }
            .padding(16)
        }
        .frame(maxHeight: 120)
        .background(Color.active)
        .cornerRadius(10)
        .padding(.horizontal, 16)
        
        .onTapGesture {
            openAboutShopProduct.toggle()
            choosed()
        }
    }
    
    private func convertImage() -> UIImage {
        if let imageData = data?.photo {
            return UIImage(data: imageData) ?? UIImage()
        } else {
            return UIImage(named: "emptyImage") ?? UIImage()
        }
    }
}

#Preview {
    HDShoppintListCell(openAboutShopProduct: .constant(false))
}

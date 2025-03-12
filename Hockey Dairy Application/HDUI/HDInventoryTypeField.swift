//
//  HDInventoryType.swift
//  Hockey Team Journal
//
//  Created by Den on 29/02/24.
//

import SwiftUI

struct HDInventoryTypeField: View {
    @Binding var position: HDInventoryType?
    @State var placeholder: String = "Which position: "
    @Binding var openAlert: Bool
    @Binding var editMode: Bool
    @State var completion: (HDInventoryType) -> Void
    @State var sheetOrPage: Bool = false
    var body: some View {
        HStack(spacing: 0) {
            if editMode {
                if !sheetOrPage {
                    Text(placeholder)
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
            }
            if let type = position {
                Text(type.description())
                    .foregroundColor(Color.allWhite)
                    .font(Font.system(size: 17, weight: .semibold))
            } else {
                Text(placeholder)
                    .foregroundColor(Color.allWhite.opacity(0.5))
            }
            Spacer()
        }
        .frame(maxHeight: 30)
        .padding(16)
        .background(Color.active)
        .cornerRadius(10)
        .onTapGesture {
            if editMode {
                openAlert.toggle()
            }
        }
        .onChange(of: openAlert, perform: { value in
            if let type = position {
                completion(type)
            }
        })
    }
}

#Preview {
    HDInventoryTypeField(position: .constant(.forEveryone), openAlert: .constant(false), editMode: .constant(true), completion: {_ in})
}

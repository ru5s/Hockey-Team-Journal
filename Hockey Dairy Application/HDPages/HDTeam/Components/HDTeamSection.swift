//
//  HDTeamSection.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDTeamSection: View {
    @State var title: String
    @State var type: HockeyPlayerTypeModel
    @State var completion: (HockeyPlayerTypeModel) -> Void
    @Binding var data: [Player]
    @State var updateData: () -> Void
    @ObservedObject var model: HDTeamVM
    @Binding var inventarType: HDInventoryType
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(Color.active)
                    .font(Font.system(size: 25, weight: .semibold))
                    .padding(.bottom, 5)
                Spacer()
                Button {
                    
                    switch type {
                    case .forward:
                        inventarType = .forForward
                    case .defence:
                        inventarType = .forDefence
                    case .goalie:
                        inventarType = .forGoalie
                    case .all:
                        break
                    }
                    completion(type)
                    
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(Color.active)
                }
            }
            .padding(.top, 25)
            
            LazyVStack(spacing: 0, content: {
                ForEach(data, id: \.self) { item in
                    HDTeamVCell(data: item, updateData: {
                        updateData()
                    }, model: model, inventarType: inventarType)
                }
            })
            .cornerRadiusWithBorder(radius: 10, borderLineWidth: 0.5, borderColor: Color.cellBorderBackground, antialiased: true)
        }
        .onAppear {
            
        }
    }
}

#Preview {
    HDTeamSection(title: "Title", type: .defence, completion: {_ in}, data: .constant([]), updateData: {}, model: HDTeamVM(), inventarType: .constant(.forEveryone))
}

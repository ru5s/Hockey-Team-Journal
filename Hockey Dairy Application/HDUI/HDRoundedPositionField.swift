//
//  HDRoundedPositionField.swift
//  Hockey Team Journal
//
//  Created by Den on 27/02/24.
//

import SwiftUI

struct HDRoundedPositionField: View {
    @Binding var position: HockeyPlayerTypeModel
    @State var placeholder: String = "Position: "
    @Binding var openAlert: Bool
    @Binding var editMode: Bool
    @State var completion: (HockeyPlayerTypeModel) -> Void
    @State var sheetOrPage: Bool = true
    var body: some View {
        HStack(spacing: 0) {
            if editMode {
                if !sheetOrPage {
                    Text(placeholder)
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
            }
            Text(position.description())
                .foregroundColor(Color.allWhite)
                .font(Font.system(size: 17, weight: .semibold))
            
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
            completion(position)
        })
    }
}

#Preview {
    HDRoundedPositionField(position: .constant(.goalie), openAlert: .constant(true), editMode: .constant(true), completion: {_ in})
}

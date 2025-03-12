//
//  HDCalendarCell.swift
//  Hockey Team Journal
//
//  Created by Den on 01/03/24.
//

import SwiftUI

struct HDCalendarCell: View {
    @Binding var haveDate: Bool
    @Binding var activeTab: Int
    @State var currentIndex: Int
    @State var day: String
    @State var mounth: String
    @State var completion: (Int) -> Void = {_ in}
    var body: some View {
        VStack{
            Circle()
                .foregroundColor(haveDate ? Color.allWhite : Color.clear)
                .frame(width: 6, height: 6, alignment: .center)
            HStack {
                Rectangle()
                    .frame(maxHeight: .infinity)
                    .frame(width: 0.5, height: 30)
                    .foregroundColor(currentIndex == activeTab ? Color.allWhite : Color.allWhite.opacity(0.2))
                Spacer()
                VStack {
                    Text(day)
                        .font(Font.system(size: 20, weight: .semibold))
                        .foregroundColor( currentIndex == activeTab  ? Color.allWhite : Color.allWhite.opacity(0.2))
                    Text(mounth)
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(currentIndex == activeTab  ? Color.allWhite : Color.allWhite.opacity(0.2))
                }
                Spacer()
                Rectangle()
                    .frame(maxHeight: .infinity)
                    .frame(width: 0.5, height: 30)
                    .foregroundColor(currentIndex == activeTab ? Color.allWhite : Color.allWhite.opacity(0.2))
            }
        }
        .frame(width: 80, height: 75)
        .background(Color.navigationBackground)
        .onTapGesture {
            completion(currentIndex)
        }
    }
}

#Preview {
    HDCalendarCell(haveDate: .constant(true), activeTab: .constant(0), currentIndex: 0, day: "1", mounth: "May")
}

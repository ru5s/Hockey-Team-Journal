//
//  HDCalendarTimePicker.swift
//  Hockey Team Journal
//
//  Created by Den on 03/03/24.
//

import SwiftUI

struct HDCalendarTimePicker: View {
    @Binding var time: String
    @State var completion: (String) -> Void = {_ in}
    @State private  var placeholder: String = "Time: "
    @State private var selectedDate: Date = Date()
    @State var incomeDate: Date?
    @Binding var editMode: Bool
    var body: some View {
        HStack {
            Text(placeholder)
                .foregroundColor(Color.allWhite.opacity(0.5))
            HStack {
                ZStack(alignment: .leading) {
                    Text(time(date: selectedDate))
                        .foregroundColor(Color.allWhite)
    
                    DatePicker("",
                               selection: $selectedDate,
                               displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .blendMode(.color)
                    .opacity(0.9)
                    .disabled(!editMode)
                }
            }
            Spacer()
        }
        .frame(height: 30)
        .padding(16)
        .background(Color.active)
        .cornerRadius(10)
        .onChange(of: selectedDate, perform: { value in
            completion(time(date: selectedDate))
        })
        .onAppear {
            time = time(date: selectedDate)
        }
    }
    
    private func time(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
}

#Preview {
    HDCalendarTimePicker(time: .constant(""), editMode: .constant(true))
}

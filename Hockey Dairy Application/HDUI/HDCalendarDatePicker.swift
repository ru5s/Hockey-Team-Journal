//
//  HDCalendarDatePicker.swift
//  Hockey Team Journal
//
//  Created by Den on 03/03/24.
//

import SwiftUI

struct HDCalendarDatePicker: View {
    @Binding var date: String
    @State var completion: (Date) -> Void = {_ in}
    @State private  var placeholder: String = "Date: "
    @State private var selectedDate: Date = Date()
    @State var incomeDate: Date?
    @Binding var editMode: Bool
    var body: some View {
        HStack {
            Text(placeholder)
                .foregroundColor(Color.allWhite.opacity(0.5))
            HStack {
                ZStack(alignment: .leading) {
                    Text(formattedDate)
                        .foregroundColor(Color.allWhite)
                    
                    DatePicker("",
                               selection: $selectedDate,
                               displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .blendMode(.color)
                    .opacity(0.1)
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
            completion(selectedDate)
        })
        .onAppear {
            if incomeDate != nil {
                selectedDate = incomeDate ?? Date()
            }
        }
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        return dateFormatter.string(from: selectedDate)
    }
}

#Preview {
    HDCalendarDatePicker(date: .constant("Saturday, February 15, 2024"), editMode: .constant(false))
}

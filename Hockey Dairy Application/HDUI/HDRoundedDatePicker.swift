//
//  HDRoundedDatePicker.swift
//  Hockey Team Journal
//
//  Created by Den on 27/02/24.
//

import SwiftUI

struct HDRoundedDatePicker: View {
    @Binding var date: String
    @State private var openDatePicker: Bool = false
    @State var completion: (String) -> Void = {_ in}
    @State private  var placeholder: String = "Date of birth: "
    @State private var selectedDate: Date = Date()
    @Binding var editMode: Bool
    @State private  var firstTouch: Bool = false
    @State var sheetOfPage: Bool = false
    var body: some View {
        HStack {
            if editMode {
                if sheetOfPage && date.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
                if !sheetOfPage {
                    Text(placeholder)
                        .foregroundColor(Color.allWhite.opacity(0.5))
                }
            }
            if openDatePicker {
                    HStack {
                        ZStack(alignment: .leading) {
                            Text(!editMode ? date : formattedDate)
                                .foregroundColor(Color.allWhite)
                            
                            DatePicker("",
                                       selection: $selectedDate,
                                       displayedComponents: .date)
                            .environment(\.locale, .init(identifier: "en"))
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .blendMode(.color)
                            .opacity(0.1)
                            .disabled(!editMode)
                            .onTapGesture {
                                firstTouch = true
                            }
                        }
                    }
            } else {
                HStack {
                    
                    Text(!editMode ? date : formattedDate)
                        .foregroundColor(Color.allWhite)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxHeight: 30)
        .padding(16)
        .background(Color.active)
        .cornerRadius(10)
        .onChange(of: selectedDate, perform: { value in
            completion(formattedDate)
        })
        .onTapGesture {
            if editMode && !firstTouch {
                firstTouch = true
                openDatePicker.toggle()
                completion(formattedDate)
            }
        }
    }
    
    private var formattedDate: String {
        if firstTouch {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: selectedDate)
        } else {
            return date
        }
    }
}

#Preview {
    HDRoundedDatePicker(date: .constant(""), editMode: .constant(true))
}

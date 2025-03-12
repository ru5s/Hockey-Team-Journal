//
//  HDBigBanner.swift
//  Hockey Team Journal
//
//  Created by Den on 02/03/24.
//

import SwiftUI

struct HDBigBanner: View {
    @Binding var choosedElement: GameCalendar?
    @State var completion: (GameCalendar) -> Void
    var body: some View {
        if let choosedElement = choosedElement {
            VStack {
                Text("Game vs " + (choosedElement.opponent ?? ""))
                    .font(Font.system(size: 20, weight: .semibold))
                Image(uiImage: convertImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .cornerRadius(14)
                    .padding(.bottom, 20)
                VStack {
                    HStack {
                        Text("Date: ")
                        Text(fullDate(data: choosedElement))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.5))
                    HStack {
                        Text("Time: ")
                        Text(choosedElement.time ?? "")
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.5))
                    HStack {
                        Text("Opponent: ")
                        Text(choosedElement.opponent ?? "")
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.5))
                    HStack {
                        Text("Location: ")
                        Text(choosedElement.place ?? "")
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                .background(Color.allWhite)
                .foregroundColor(Color.active)
                .cornerRadius(14)
            }
            .onTapGesture {
                completion(choosedElement)
            }
            .foregroundColor(Color.allWhite)
            .padding(20)
            .background(Color.active)
            .cornerRadius(14)
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            HDEmptyView(title: "Empty", subtitle: "You don’t have any games this day")
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    private func convertImage() -> UIImage {
        return UIImage(data: choosedElement?.photo ?? Data()) ?? UIImage()
    }
    private func fullDate(data: GameCalendar) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: data.date ?? Date())
        return formattedDate
    }
    private func time(data: GameCalendar) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: data.date ?? Date())
        return formattedTime
    }
}

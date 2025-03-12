//
//  HDTeamVCell.swift
//  Hockey Team Journal
//
//  
//

import SwiftUI

struct HDTeamVCell: View {
    @State var data: Player
    @State var openAboutPlayer: Bool = false
    @State var updateData: () -> Void
    @ObservedObject var model: HDTeamVM
    @State var inventarType: HDInventoryType
    @State var positionPlayer: HockeyPlayerTypeModel = .forward
    var body: some View {
            VStack {
                NavigationLink(isActive: $openAboutPlayer, destination: {
                    HDAboutPlayer(playerType: HockeyPlayerTypeModel(rawValue: data.position) ?? .defence, dismiss: $openAboutPlayer, playerCompletion: ({player in
                        
                    }), data: data, updateData: {
                        updateData()
                    }, model: model, inventarType: inventarType)
                }, label: {
                    EmptyView()
                })
                HStack {
                    VStack(alignment: .leading) {
                        HDBaloonTag(titile: data.dateOfBirth ?? "00.00.0000")
                        Spacer()
                        Text(data.name ?? "No name")
                            .foregroundColor(Color.allWhite)
                            .font(Font.system(size: 25, weight: .semibold))
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    Image(uiImage: convertImage())
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 80, maxHeight: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(16)
                HStack {}
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .background(Color.cellBorderBackground)
            }
            .frame(maxHeight: 120)
            .background(Color.active)
        .onTapGesture {
            positionPlayer = HockeyPlayerTypeModel(rawValue: data.position) ?? .forward
            
            switch positionPlayer {
            case .forward:
                inventarType = .forForward
            case .defence:
                inventarType = .forDefence
            case .goalie:
                inventarType = .forGoalie
            case .all:
                break
            }
            openAboutPlayer.toggle()
        }
    }
    
    private func convertImage() -> UIImage {
        if let imageData = data.photo {
            return UIImage(data: imageData) ?? UIImage()
        } else {
            return UIImage(named: "emptyImage") ?? UIImage()
        }
    }
}

#Preview {
    HDTeamVCell(data: .init(), updateData: {}, model: HDTeamVM(), inventarType: .forEveryone)
}

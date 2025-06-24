//
//  SideMenuView.swift
//  Radio City
//
//  Created by praveen hiremath on 24/06/25.
//

import SwiftUI

struct SideMenuView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color.white
                )
            }
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
            HStack{
                Spacer()
                Image("profile-image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.purple.opacity(0.5), lineWidth: 10)
                    )
                    .cornerRadius(50)
                Spacer()
            }
            
            Text("Muhammad Abbas")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Text("IOS Developer")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    Rectangle()
                        .fill(isSelected ? .purple : .white)
                        .frame(width: 5)
                    
                    ZStack{
                        Image(systemName: imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 30, height: 30)
                    }
                    .frame(width: 40, height: 40)
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 60)
        .background(
            LinearGradient(colors: [isSelected ? .purple.opacity(0.5) : .white, .white], startPoint: .leading, endPoint: .trailing)
        )
    }
}
//  SideMenuRowType.swift
enum SideMenuRowType: Int, CaseIterable {
    case home = 0
    case login
    case favorite
    case chat
    case profile
    case settings
    case about
    case logout
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .chat:
            return "Chat"
        case .profile:
            return "Profile"
        case .login:
            return "Log In"
        case .settings:
            return "Settings"
        case .about:
            return "About"
        case .logout:
            return "Log Out"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .favorite:
            return "heart"
        case .chat:
            return "message.badge.waveform"
        case .profile:
            return "person.crop.circle"
        case .login:
            return "square.and.arrow.down"
        case .settings:
            return "gearshape"
        case .about:
            return "person.crop.circle"
        case .logout:
            return "square.and.arrow.up"
        }
    }
}


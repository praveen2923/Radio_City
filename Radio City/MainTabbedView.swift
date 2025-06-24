//
//  MainTabbedView.swift
//  Radio City
//
//  Created by praveen hiremath on 24/06/25.
//

import SwiftUI

struct MainTabbedView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedSideMenuTab) {
                RadioPlayerView(presentSideMenu: $presentSideMenu)
                    .tag(0)
                FavoriteView(presentSideMenu: $presentSideMenu)
                    .tag(1)
                ChatView(presentSideMenu: $presentSideMenu)
                    .tag(2)
                ProfileView(presentSideMenu: $presentSideMenu)
                    .tag(3)
            }
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
}

#Preview {
    MainTabbedView()
}

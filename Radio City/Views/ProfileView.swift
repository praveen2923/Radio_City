//
//  ProfileView.swift
//  Radio City
//
//  Created by praveen hiremath on 24/06/25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var presentSideMenu: Bool
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 10) {
                HStack {
                    Button {
                        presentSideMenu.toggle()
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20) // Adjust as needed for status bar
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProfileView(presentSideMenu: .constant(false))
}

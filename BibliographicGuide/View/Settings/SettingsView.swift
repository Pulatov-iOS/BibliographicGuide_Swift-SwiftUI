//
//  SettingsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 29.03.23.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {

        VStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 5) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100, alignment: .center)
                    .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                Text("1")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                Button{
                    settingsViewModel.createUser()
                } label:{
                    Image(systemName: "square.and.arrow.down.on.square")
                        .foregroundColor(.black)
                        .padding(2)
                }
            }
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

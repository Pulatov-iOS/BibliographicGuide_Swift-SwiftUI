//
//  SettingsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 29.03.23.
//

import SwiftUI

struct SettingsView: View {
    
    let appName: String = Bundle.main.infoDictionary?["CFBundleName"] as! String
    let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    @ObservedObject var userInformationListViewModel = UserInformationListViewModel()
    
    @State private var newNickname = ""
    @State private var alertTitle: String = "Успешно"
    @State private var alertMessage: String = "Настройки успешно изменены."
    @State private var showAlertCreate: Bool = false
    @State private var showKeywordsWindow: Bool = false
    @State private var showUserEditingWindow: Bool = false
    
    var body: some View {

        VStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 5) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100, alignment: .center)
                    .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                Text(appName.uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
            }
            .padding()
            
            Form {
                Section(header: Text("Настройки")) {
                    HStack {
                        Text("Название:")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text(appName)
                    }
                    HStack {
                        Text("Версия:")
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text(appVersion)
                    }
                    HStack {
                        Text("Имя пользователя:")
                            .foregroundColor(Color.gray)
                        Spacer()
                        TextField(userInformationListViewModel.getСurrentUserInformation().userName, text: $newNickname).multilineTextAlignment(TextAlignment.trailing)
                    }
                }
            }.padding(.top, -12)
            
            VStack{
                let role = userInformationListViewModel.getСurrentUserInformation().role
                HStack{
                    if(role == "admin" || role == "editor"){
                        Button{
                            self.showKeywordsWindow = true
                        } label: {
                            Text("Кл. слова").foregroundColor(.black).frame(width: UIScreen.main.bounds.width*0.25).padding()
                        }
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                        .padding(.bottom, 25)
                    }
                    if(role == "admin"){
                        Button{
                            self.showUserEditingWindow = true
                        } label: {
                            Text("Изм. польз.").foregroundColor(.black).frame(width: UIScreen.main.bounds.width*0.25).padding()
                        }
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                        .padding(.bottom, 25)
                    }
                }
                Button("Сохранить"){
                    userInformationListViewModel.updateUserInformation(newNickname){
                        (verified, status) in
                        if !verified {
                            alertTitle = "Ошибка"
                            alertMessage = status
                        }
                        else{
                            alertTitle = "Успешно"
                            alertMessage = status
                        }
                    }
                    showAlertCreate.toggle()
                }
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width - 160)
                .padding()
                .alert(isPresented: $showAlertCreate) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Ок"))
                    )
                }
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    .clipShape(Capsule())
                    .padding(.bottom, 25)
            }
            
            VStack{
                Button(action: {
                    userInformationListViewModel.exitOfAccount()
                }){
                    Text("Выйти").foregroundColor(.black).frame(width: UIScreen.main.bounds.width - 160).padding(.bottom, 25)
                }
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .sheet(isPresented: self.$showKeywordsWindow) {
            KeywordsView()
        }
        .sheet(isPresented: self.$showUserEditingWindow) {
            UsersRightsView(userInformationListViewModel: userInformationListViewModel)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

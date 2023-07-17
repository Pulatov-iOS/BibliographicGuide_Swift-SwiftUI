//
//  SettingsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 29.03.23.
//

import SwiftUI
import SDWebImageSwiftUI

enum language: String, CaseIterable, Identifiable {
    case english
    case spanish
    case russian
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .english:
            return "Английский"
        case .spanish:
            return "Испанский"
        case .russian:
            return "Русский"
        }
    }
}

struct SettingsView: View {
    
    let appName: String = Bundle.main.infoDictionary?["CFBundleName"] as! String
    let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    @EnvironmentObject var userInformationListViewModel: UserInformationListViewModel
    
    @State private var languageSelectedItem: language = currentLanguage(UserDefaults.standard.value(forKey: "language") as? String ?? "english")
    
    @State private var userName = ""
    @State private var imageAccount = UIImage()
    @State private var newImageAccount = UIImage()
    @State private var selectedNewImageAccount = false
    @State private var defaultImageAccount = false
    @State private var imageUrl = URL(string: "")
    @State private var showImagePicker = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlertCreate = false
    @State private var showLanguageWindow = false
    @State private var showKeywordsWindow = false
    @State private var showUserEditingWindow = false
    
    @FocusState private var keyboardIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
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
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                Form {
                    Section(header: Text("Настройки")) {
                        HStack {
                            Text("Приложение:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            Text(appName)
                        }
                        HStack {
                            Text("Версия:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            Text("V\(appVersion)")
                        }
                        HStack {
                            Text("Язык:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            HStack{
                                Text(languageSelectedItem.title)
                                VStack(spacing: 2){
                                    Image(systemName: "chevron.up")
                                        .resizable()
                                        .frame(width: 10, height: 5)
                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .frame(width: 10, height: 5)
                                }
                            }
                            .onChange(of: userInformationListViewModel.getСurrentUserInformation().language){ Value in
                                userInformationListViewModel.saveCurrentLanguage(Value)
                                languageSelectedItem = currentLanguage(Value)
                            }
                            .onChange(of: languageSelectedItem){ Value in
                                userInformationListViewModel.saveCurrentLanguage(Value.rawValue)
                                userInformationListViewModel.updateLanguage(Value.rawValue)
                            }
                            .onTapGesture {
                                showLanguageWindow = true
                            }
                        }
                        HStack {
                            Text("Имя пользователя:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            TextField("", text: $userName)
                                .multilineTextAlignment(TextAlignment.trailing)
                                .focused($keyboardIsFocused)
                        }
                        .onAppear(){
                            userName = userInformationListViewModel.getСurrentUserInformation().userName
                        }
                        HStack {
                            Text("Изображение учетной \nзаписи:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            HStack{
                                HStack{
                                    if(defaultImageAccount == true){
                                        Image(uiImage: self.imageAccount)
                                            .resizable()
                                            .cornerRadius(50)
                                            .frame(width: 60, height: 60)
                                            .background(Color.black.opacity(0.2))
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                showImagePicker = true
                                            }
                                    }
                                    else{
                                        WebImage(url: imageUrl)
                                            .resizable()
                                            .cornerRadius(50)
                                            .frame(width: 60, height: 60)
                                            .background(Color.white)
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                showImagePicker = true
                                            }
                                    }
                                }
                                .onAppear{
                                    userInformationListViewModel.getImageUrl(pathImage: "ImageAccount"){ (verified, status) in
                                        if !verified  {
                                            defaultImageAccount = true
                                            imageUrl = status
                                        }
                                        else{
                                            defaultImageAccount = false
                                            imageUrl = status
                                        }
                                    }
                                }
                                .onChange(of: imageAccount){ Value in
                                    if(newImageAccount != imageAccount){
                                        defaultImageAccount = true
                                        newImageAccount = imageAccount
                                        selectedNewImageAccount = true
                                    }
                                }
                                .sheet(isPresented: $showImagePicker) {
                                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageAccount)
                                }
                            }
                            .onAppear(){
                                imageAccount = UIImage(named: "default-create-record") ?? UIImage()
                                newImageAccount = UIImage(named: "default-create-record") ?? UIImage()
                            }
                        }
                    }
                }
                .scrollDisabled(true)
                .frame(height: 310)
                .padding(.top, -12)
                
                VStack{
                    let role = userInformationListViewModel.getСurrentUserInformation().role
                    HStack(spacing: 10){
                        if(role == "admin" || role == "editor"){
                            Button{
                                self.showKeywordsWindow = true
                            } label: {
                                Text("Кл. слова").foregroundColor(.black).frame(width: 120).padding()
                            }
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                        if(role == "admin"){
                            Button{
                                self.showUserEditingWindow = true
                            } label: {
                                Text("Изм. польз.").foregroundColor(.black).frame(width: 120).padding()
                            }
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                    }
                }

                VStack{
                    Button("Сохранить"){
                        let imageData = newImageAccount.jpegData(compressionQuality: 0.1)
                        
                        userInformationListViewModel.updateUserInformation(newUserName: userName, imageAccount: imageData ?? Data(), newImageAccount: selectedNewImageAccount){
                            (verified, status) in
                            if !verified {
                                alertTitle = "Ошибка"
                                alertMessage = status
                                showAlertCreate.toggle()
                            }
                            else{
                                alertTitle = "Успешно"
                                alertMessage = status
                                showAlertCreate.toggle()
                            }
                        }
                        selectedNewImageAccount = false
                    }
                    .foregroundColor(.black)
                    .frame(width: 180)
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
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        userInformationListViewModel.exitOfAccount()
                    }){
                        Text("Выйти").foregroundColor(.black).frame(width: 180)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.top, UIScreen.screenHeight * 0.04)
            }
        }
        .onTapGesture {
            keyboardIsFocused = false // закрытие клавиатуры при нажатии на экран
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .sheet(isPresented: self.$showLanguageWindow) {
            LanguageView(languageSelectedItem: $languageSelectedItem)
        }
        .sheet(isPresented: self.$showKeywordsWindow) {
            KeywordsView()
                .environmentObject(userInformationListViewModel)
        }
        .sheet(isPresented: self.$showUserEditingWindow) {
            UsersRightsView()
                .environmentObject(userInformationListViewModel)
        }
    }
}

func currentLanguage(_ language: String) -> language {
    switch language {
    case "english":
        return .english
    case "spanish":
        return .spanish
    case "russian":
        return .russian
    default:
        return .english
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}

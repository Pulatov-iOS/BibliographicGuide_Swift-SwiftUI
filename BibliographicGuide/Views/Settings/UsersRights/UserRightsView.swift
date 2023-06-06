//
//  UserRightsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

enum userRole: String, CaseIterable, Identifiable {
    case reader
    case editor
    case admin
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .reader:
            return "Читатель"
        case .editor:
            return "Редактор"
        case .admin:
            return "Администратор"
        }
    }
}

struct UserRightsView: View {
    
    @EnvironmentObject var userInformationListViewModel: UserInformationListViewModel
    @Binding var selectedUser: UserInformation
    
    @State private var userRoleSelectedItem: userRole = .reader
    @State private var blockingChat = false
    @State private var isChangeBlockingChat = false
    @State private var blockingAccount = false
    @State private var isChangeBlockingAccount = false
    @State private var newReasonBlockingAccount = ""
    @State private var userName = ""
    @State private var newUserName = ""
    
    @State private var showAlertUpdateUserInformation = false
    @State private var alertTextUpdateUserInformationTitle = ""
    @State private var alertTextUpdateUserInformationMessage = ""
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        List{
                            ZStack{
                                HStack{
                                    Text("Роль:")
                                    Spacer()
                                }
                                VStack{
                                    Picker("", selection: $userRoleSelectedItem){
                                        ForEach(userRole.allCases){ userRole in
                                            Text(userRole.title)
                                                .tag(userRole)
                                        }
                                    }
                                    .pickerStyle(.automatic)
                                    .tint(.black)
                                }
                            }
                            HStack{
                                Text("Блокировка чата:")
                                Spacer()
                                Toggle("", isOn: $blockingChat)
                                    .onTapGesture {
                                        isChangeBlockingChat = true
                                    }
                            }
                            .onChange(of: blockingChat){ Value in
                                if isChangeBlockingChat {
                                    userInformationListViewModel.updateChatLock(idUser: selectedUser.id ?? "", blockingChat: blockingChat){ (verified, status) in
                                        if !verified {
                                            alertTextUpdateUserInformationTitle = "Ошибка!"
                                            alertTextUpdateUserInformationMessage = "Проверьте подключение к сети и повторите попытку"
                                            showAlertUpdateUserInformation.toggle()
                                        }
                                        else{
                                            if(Value){
                                                alertTextUpdateUserInformationTitle = "Успешно!"
                                                alertTextUpdateUserInformationMessage = "Функция общего чата успешно заблокирована"
                                            }
                                            else{
                                                alertTextUpdateUserInformationTitle = "Успешно!"
                                                alertTextUpdateUserInformationMessage = "Функция общего чата успешно разблокирована"
                                            }
                                            showAlertUpdateUserInformation.toggle()
                                        }
                                    }
                                    isChangeBlockingChat = false
                                }
                            }
                            if(selectedUser.id != userInformationListViewModel.getСurrentIdUser()){
                                HStack{
                                    Text("Блокировка учетной записи:")
                                    Spacer()
                                    Toggle("", isOn: $blockingAccount)
                                        .onTapGesture {
                                            isChangeBlockingAccount = true
                                        }
                                }
                                .onChange(of: blockingAccount){ Value in
                                    if isChangeBlockingAccount {
                                        userInformationListViewModel.updateAccountLock(idUser: selectedUser.id ?? "", blockingAccount: blockingAccount){ (verified, status) in
                                            if !verified {
                                                alertTextUpdateUserInformationTitle = "Ошибка!"
                                                alertTextUpdateUserInformationMessage = "Данный пользователь не заблокирован. Проверьте подключение к сети и повторите попытку"
                                                showAlertUpdateUserInformation.toggle()
                                            }
                                            else{
                                                if(Value){
                                                    alertTextUpdateUserInformationTitle = "Успешно!"
                                                    alertTextUpdateUserInformationMessage = "Данный пользователь успешно заблокирован"
                                                }
                                                else{
                                                    alertTextUpdateUserInformationTitle = "Успешно!"
                                                    alertTextUpdateUserInformationMessage = "Данный пользователь успешно разблокирован"
                                                }
                                                showAlertUpdateUserInformation.toggle()
                                            }
                                        }
                                        isChangeBlockingAccount = false
                                    }
                                }
                                HStack{
                                    VStack(spacing: 8){
                                        HStack{
                                            Text("Причина блокировки учетной записи:")
                                            Spacer()
                                        }
                                        TextField("Причина", text: $newReasonBlockingAccount, prompt: Text("Отсутствует"), axis: .vertical)
                                            .foregroundColor(.red)
                                            .lineLimit(2...2)
                                    }
                                }
                            }
                            HStack{
                                VStack(spacing: 8){
                                    HStack{
                                        Text("Новое имя пользователя:")
                                        Spacer()
                                    }
                                    TextField(userName, text: $newUserName)
                                }
                            }
                        }
                        .scrollDisabled(true)
                        .frame(height: 375)
                        .padding(.top, 40)
                        
                        VStack{
                            Spacer()
                            Button("Сохранить"){
                                userInformationListViewModel.updateRoleReasonBlockingUserName(idUser: selectedUser.id ?? "", role: userRoleSelectedItem.rawValue, reasonBlocking: newReasonBlockingAccount, newUserName: newUserName){ (verified, status) in
                                    if !verified {
                                        alertTextUpdateUserInformationTitle = "Ошибка!"
                                        alertTextUpdateUserInformationMessage = status
                                        showAlertUpdateUserInformation.toggle()
                                    }
                                    else{
                                        alertTextUpdateUserInformationTitle = "Успешно!"
                                        alertTextUpdateUserInformationMessage = "Данные пользователя успешно обновлены."
                                        showAlertUpdateUserInformation.toggle()
                                    }
                                }
                            }
                            .foregroundColor(.black)
                            .frame(width: 180)
                            .padding()
                            .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                            .clipShape(Capsule())
                            .padding(.bottom, 35)
                        }
                    }
                }
                
                VStack{
                    HStack{
                        Text(selectedUser.userName)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 25, leading: 0, bottom: 5, trailing: 0))
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                    Spacer()
                }
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .onAppear{
            switch selectedUser.role {
            case "reader":
                userRoleSelectedItem = .reader
            case "editor":
                userRoleSelectedItem = .editor
            case "admin":
                userRoleSelectedItem = .admin
            default:
                userRoleSelectedItem = .reader
            }
            blockingChat = selectedUser.blockingChat
            blockingAccount = selectedUser.blockingAccount
            if(selectedUser.reasonBlockingAccount == ""){
                newReasonBlockingAccount = ""
            }
            else{
                newReasonBlockingAccount = selectedUser.reasonBlockingAccount
            }
            userName = selectedUser.userName
        }
        .onChange(of: selectedUser){ Value in
            switch selectedUser.role {
            case "reader":
                userRoleSelectedItem = .reader
            case "editor":
                userRoleSelectedItem = .editor
            case "admin":
                userRoleSelectedItem = .admin
            default:
                userRoleSelectedItem = .reader
            }
            blockingChat = selectedUser.blockingChat
            blockingAccount = selectedUser.blockingAccount
            if(selectedUser.reasonBlockingAccount == ""){
                newReasonBlockingAccount = ""
            }
            else{
                newReasonBlockingAccount = selectedUser.reasonBlockingAccount
            }
            userName = selectedUser.userName
        }
        .alert(isPresented: $showAlertUpdateUserInformation) {
            Alert(
                title: Text(alertTextUpdateUserInformationTitle),
                message: Text(alertTextUpdateUserInformationMessage),
                dismissButton: .default(Text("Ок")))
        }
    }
}

//struct UserRightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRightsView()
//    }
//}

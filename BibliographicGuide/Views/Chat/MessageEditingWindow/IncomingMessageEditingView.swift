//
//  IncomingMessageEditingWindow.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.04.23.
//

import SwiftUI

struct IncomingMessageEditingView: View {
    
    @State var messageListViewModel: MessageListViewModel
    @State var userName: String
    @State var userNameResponseMessage: String
    @State var textResponseMessage: String
    
    @Binding var replyIdMessage: String
    @Binding var changeWindowShow: Bool
    @Binding var ChangeableMessage: Message?
    @Binding var textNewMessage: String
    @Binding var editingWindowShow: Bool
    @Binding var replyWindowShow: Bool
    @Binding var changeKeyboardIsFocused: Bool
    @Binding var newMessageId: String
    
    @Binding var selectedMessage: Message?
    @Binding var selectedImage: Int
    @Binding  var openFullSizeImage: Bool
    
    @Binding var showAlert: Bool
    @Binding var alertTextTitle: String
    @Binding var alertTextMessage: String
    
    var body: some View {
        VStack(alignment: .leading){
            IncomingMessageView(messageListViewModel: messageListViewModel, messageViewModel: messageListViewModel.MessageToMessageViewModel(ChangeableMessage?.id ?? ""), userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage, editingWindowShow: $editingWindowShow, isEditingWindow: false)
            VStack(spacing: 0){
                HStack{
                    Text("Ответить")
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 0))
                    Spacer()
                    Image(systemName: "arrowshape.turn.up.left")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 20))
                }
                .background(Color.white)
                .onTapGesture {
                    editingWindowShow.toggle()
                    replyWindowShow = true
                    changeWindowShow = false
                    changeKeyboardIsFocused.toggle() // Открытие клавиатуры
                    replyIdMessage = ChangeableMessage?.id ?? "" // сохраняем id сообщения к которому прикрепляется сообщение
                }
                if(messageListViewModel.getСurrentUserInformation().role == "admin"){
                    if(messageListViewModel.getUserInformation(idUser: ChangeableMessage?.idUser ?? "").blockingChat == false){
                        HStack{
                            Text("Заблокировать")
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 15, trailing: 0))
                            Spacer()
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 12, height: 15)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 15, trailing: 20))
                        }
                        .foregroundColor(.red)
                        .background(Color.white)
                        .onTapGesture {
                            messageListViewModel.updateChatLock(idUser: ChangeableMessage?.idUser ?? "", blockingChat: true){ (verified, status) in
                                if !verified {
                                    alertTextTitle = "Ошибка!"
                                    alertTextMessage = "Данный пользователь не заблокирован. Проверьте подключение к сети"
                                    showAlert.toggle()
                                }
                            }
                            editingWindowShow.toggle()
                        }
                    }
                    else{
                        HStack{
                            Text("Разблокировать")
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 15, trailing: 0))
                            Spacer()
                            Image(systemName: "lock.open")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 15, trailing: 20))
                        }
                        .foregroundColor(.green)
                        .background(Color.white)
                        .onTapGesture {
                            messageListViewModel.updateChatLock(idUser: ChangeableMessage?.idUser ?? "", blockingChat: false){ (verified, status) in
                                if !verified {
                                    alertTextTitle = "Ошибка!"
                                    alertTextMessage = "Данный пользователь не разблокирован. Проверьте подключение к сети"
                                    showAlert.toggle()
                                }
                            }
                            editingWindowShow.toggle()
                        }
                    }
                }
            }
            .frame(width: UIScreen.screenWidth * 0.5)
            .background(Color.white)
            .cornerRadius(25)
            .onDisappear(){ // убрать окно редактирования сообщения, если оно открыто и мы перешли в другое окно
                editingWindowShow = false
            }.padding(.leading, 50)
        }
    }
}

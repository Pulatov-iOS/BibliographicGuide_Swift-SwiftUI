//
//  MessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import SwiftUI

struct MessageListView: View {
    
    @ObservedObject var messageListViewModel: MessageListViewModel
    
    @State private var textNewMessage = ""
    @State private var replyIdMessage = ""
    @State private var editingWindowShow = false
    @State private var replyWindowShow = false
    @State private var changeWindowShow = false
    @State private var changeableMessage: Message?
    
    @State private var changeKeyboardIsFocused = false
    @FocusState private var keyboardIsFocused: Bool
    
    @State var showAlert: Bool = false
    @State var alertTextTitle = ""
    @State var alertTextMessage = ""
    
    var body: some View {
        ZStack(alignment: .trailing){
            VStack(spacing: 0){
                ZStack{
                    VStack{
                        Text("Общий чат")
                            .font(.headline)
                        Text(messageListViewModel.stringCountUsers(countUsers: messageListViewModel.usersInformation.count))
                            .padding(.bottom, 5)
                            .font(.footnote)
                    }.padding(0)
                    HStack{
                        Spacer()
                        Image("logo-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 10)
                            .padding(.bottom, 8)
                            .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                    }
                }
                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                
                VStack{
                    ScrollView(.vertical, showsIndicators: true, content: {
                        VStack {
                            ForEach(messageListViewModel.messageViewModels) { messages in
                                MessageView(messageViewModel: messages, userName: messageListViewModel.getUserName(messages.message), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(messages.message.replyIdMessage), textResponseMessage: messageListViewModel.getTextResponseMessage(messages.message.replyIdMessage), outgoingOrIncomingMessage: messageListViewModel.OutgoingOrIncomingMessage(messages.message), messageListViewModel: messageListViewModel)
                                    .onLongPressGesture(minimumDuration: 0.5){
                                        changeableMessage = messages.message
                                        editingWindowShow.toggle()
                                    }
                            }
                        }.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                            .padding(.top, 15)
                                }).rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                }
                .onChange(of: changeKeyboardIsFocused){ value in
                    keyboardIsFocused = true // открытие клавиатуры при ответе и изменении сообщения
                }
                .onTapGesture {
                    keyboardIsFocused = false // закрытие клавиатуры при нажатии на экран
                }
                
                if(replyWindowShow == true){
                    MessageReplyView(messageListViewModel: messageListViewModel, changeableMessage: $changeableMessage, replyWindowShow: $replyWindowShow)
                }
                if(changeWindowShow == true){
                    MessageChangeView(changeableMessage: $changeableMessage, changeWindowShow: $changeWindowShow, textNewMessage: $textNewMessage)
                }
                
                HStack(spacing: 4){
                    Button{
                        
                    } label: {
                        Image(systemName: "paperclip")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                    }
                    .padding(8)
                    TextField("Comment", text: $textNewMessage, prompt: Text("Сообщение"), axis: .vertical)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...5)
                        .focused($keyboardIsFocused)
                    if(changeWindowShow != true){
                        Button{
                            if(textNewMessage != ""){ // если текст есть, то отправляем сообщение
                                if(!messageListViewModel.getСurrentUserInformation().blockingChat){
                                    var mes = Message(idUser: messageListViewModel.userId, typeMessage: "text", date: nil, text: textNewMessage, idFiles: [""], replyIdMessage: replyIdMessage, editing: false)
                                    messageListViewModel.addMessage(mes)
                                    replyWindowShow = false
                                    textNewMessage = ""
                                    replyIdMessage = ""
                                }
                                else{
                                    alertTextTitle = "Отказано!"
                                    alertTextMessage = "Функция отправки сообщений заблокирована"
                                    showAlert.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        }
                        .padding(8)
                    }
                    else{
                        Button{
                            if(!messageListViewModel.getСurrentUserInformation().blockingChat){
                                changeWindowShow = false
                                if(changeableMessage?.text != textNewMessage){
                                    changeableMessage?.editing = true
                                    changeableMessage?.text = textNewMessage
                                    messageListViewModel.updateMessage(changeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))
                                }
                                textNewMessage = ""
                            }
                            else{
                                alertTextTitle = "Отказано!"
                                alertTextMessage = "Функция отправки сообщений заблокирована"
                                showAlert.toggle()
                            }
                        }  label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 33, height: 32)
                                .foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        }
                        .padding(8)
                    }
                }
                .padding(4)
                .background(Color(white: 0.97))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertTextTitle),
                        message: Text(alertTextMessage),
                        dismissButton: .default(Text("Ок"))
                    )
                }
            }
            .padding(0)
            
            if(editingWindowShow == true){
                VStack{}
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                  )
                .background(.ultraThinMaterial)
                .onTapGesture {
                    editingWindowShow = false
                }
                
                if(messageListViewModel.OutgoingOrIncomingMessage(changeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))){
                    OutgoingMessageEditingView(messageListViewModel: messageListViewModel, userName: messageListViewModel.getUserName(changeableMessage ??  Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(changeableMessage?.replyIdMessage ?? ""), textResponseMessage: messageListViewModel.getTextResponseMessage(changeableMessage?.replyIdMessage ?? ""), replyIdMessage: $replyIdMessage, changeWindowShow: $changeWindowShow, ChangeableMessage: $changeableMessage, textNewMessage: $textNewMessage, editingWindowShow: $editingWindowShow, replyWindowShow: $replyWindowShow, changeKeyboardIsFocused: $changeKeyboardIsFocused)
                }
                else{
                    IncomingMessageEditingView(messageListViewModel: messageListViewModel, userName: messageListViewModel.getUserName(changeableMessage ??  Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(changeableMessage?.replyIdMessage ?? ""), textResponseMessage: messageListViewModel.getTextResponseMessage(changeableMessage?.replyIdMessage ?? ""), replyIdMessage: $replyIdMessage, changeWindowShow: $changeWindowShow, ChangeableMessage: $changeableMessage, textNewMessage: $textNewMessage, editingWindowShow: $editingWindowShow, replyWindowShow: $replyWindowShow, changeKeyboardIsFocused: $changeKeyboardIsFocused, showAlert: $showAlert, alertTextTitle: $alertTextTitle, alertTextMessage: $alertTextMessage)
                }
            }
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(messageListViewModel: MessageListViewModel())
    }
}

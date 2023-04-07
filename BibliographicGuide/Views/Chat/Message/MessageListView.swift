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
    @State private var editingMessage = false
    @State private var ChangeableMessage: Message?
    
    var body: some View {
        ZStack{
            VStack{
                ForEach(messageListViewModel.messageViewModels) { messages in
                    MessageView(messageViewModel: messages, userName: messageListViewModel.getUserName(messages.message))
                        .onLongPressGesture(minimumDuration: 0.5){
                            ChangeableMessage = messages.message
                            editingWindowShow.toggle()
                        }
                }
                
                HStack{
                    TextField(textNewMessage, text: $textNewMessage)
                    Spacer()
                    if(editingMessage != true){
                        Button("Send"){
                            var mes = Message(idUser: "pQSIzTiRzIe2djMB5VHBPES9Nk72", typeMessage: "text", date: Date(), text: textNewMessage, idFiles: [""], replyIdMessage: replyIdMessage, editing: false)
                            messageListViewModel.addMessage(mes)
                            textNewMessage = ""
                            replyIdMessage = ""
                        }
                    }
                    else{
                        Button("Cancel"){
                            editingMessage = false
                            textNewMessage = ""
                        }
                        Button("Save"){
                            editingMessage = false
                            if(ChangeableMessage?.text != textNewMessage){
                                ChangeableMessage?.editing = true
                                ChangeableMessage?.text = textNewMessage
                                messageListViewModel.updateMessage(ChangeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))
                            }
                            textNewMessage = ""
                        }
                    }
                }
            }
            if(editingWindowShow == true){
                
                VStack{}
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                  )
                .background(Color.gray.blur(radius: 200))
                .onTapGesture {
                    editingWindowShow = false
                }
                
                VStack{
                    HStack{
                        Button("Ответить"){
                            editingWindowShow.toggle()
                            replyIdMessage = ChangeableMessage?.id ?? "" // сохраняем id сообщения к которому прикрепляется сообщение
                        }
                        .foregroundColor(.black)
                        Button("Редактировать"){
                            editingMessage = true
                            editingWindowShow.toggle()
                            textNewMessage = ChangeableMessage?.text ?? ""
                        }
                        .foregroundColor(.black)
                        Button("Удалить"){
                            messageListViewModel.removeMessage(ChangeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))
                            editingWindowShow.toggle()
                        }
                        .foregroundColor(.red)
                    }
                }
                .frame(width:150, height: 100)
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .onDisappear(){ // убрать окно редактирования сообщения, если оно открыто и мы перешли в другое окно
                    editingWindowShow = false
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

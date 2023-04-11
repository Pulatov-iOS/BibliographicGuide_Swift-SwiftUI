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
                VStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                ScrollViewReader{ value in
                                    VStack {
                                        ForEach(messageListViewModel.messageViewModels) { messages in
                                            MessageView(messageViewModel: messages, userName: messageListViewModel.getUserName(messages.message), OutgoingOrIncomingMessage: messageListViewModel.OutgoingOrIncomingMessage(messages.message))
                                                .id(messages.id)
                                                .onLongPressGesture(minimumDuration: 0.5){
                                                    ChangeableMessage = messages.message
                                                    editingWindowShow.toggle()
                                                }
                                        }
                                    }.onChange(of: messageListViewModel.messageViewModels.count) { count in
                                        withAnimation {
                                            value.scrollTo(messageListViewModel.messageViewModels.last?.id)
                                        }
                                    }
                                    .padding(.bottom, 5)
                                }
                            }
                }
                HStack(spacing: 4){
                    Button{
                        
                    } label: {
                        Image(systemName: "paperclip.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                    TextField("Write your message", text: $textNewMessage)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if(editingMessage != true){
                        Button{
                            if(textNewMessage != ""){ // если текст есть, то отправляем сообщение
                                var mes = Message(idUser: "0y1kzDU4QxMqjxDSeTupTOmWbDl2", typeMessage: "text", date: Date(), text: textNewMessage, idFiles: [""], replyIdMessage: replyIdMessage, editing: false)
                                messageListViewModel.addMessage(mes)
                            }
                            textNewMessage = ""
                            replyIdMessage = ""
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        }
                        .padding(8)
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
                .padding(4)
                .background(Color(white: 0.97))
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

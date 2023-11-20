//
//  OutgoingMessageEditingWindow.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.04.23.
//

import SwiftUI

struct OutgoingMessageEditingView: View {
    
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
    
    var body: some View {
        VStack(alignment: .trailing){
            OutgoingMessageView(messageListViewModel: messageListViewModel, messageViewModel: messageListViewModel.MessageToMessageViewModel(ChangeableMessage?.id ?? ""), userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage, editingWindowShow: $editingWindowShow, isEditingWindow: false)
            VStack(spacing: 0){
                HStack{
                    Text("Ответить")
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                    Spacer()
                    Image(systemName: "arrowshape.turn.up.left")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 20))
                }
                .background(Color.white)
                .onTapGesture {
                    editingWindowShow.toggle()
                    replyWindowShow = true
                    changeWindowShow = false
                    changeKeyboardIsFocused.toggle() // Открытие клавиатуры
                    replyIdMessage = ChangeableMessage?.id ?? "" // сохраняем id сообщения к которому прикрепляется сообщение
                }
                HStack{
                    Text("Изменить")
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 20))
                }
                .background(Color.white)
                .onTapGesture {
                    replyWindowShow = false
                    changeWindowShow = true
                    editingWindowShow.toggle()
                    changeKeyboardIsFocused.toggle() // Открытие клавиатуры
                    textNewMessage = ChangeableMessage?.text ?? ""
                }
                HStack{
                    Text("Удалить")
                        .foregroundColor(.red)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 0))
                    Spacer()
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.red)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 20))
                }
                .background(Color.white)
                .onTapGesture {
                    messageListViewModel.removeMessage(ChangeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", countImages: 0, replyIdMessage: "", editing: false))
                    editingWindowShow.toggle()
                }
            }
            .frame(width: UIScreen.screenWidth * 0.5)
            .background(Color.white)
            .cornerRadius(25)
            .onDisappear(){ // убрать окно редактирования сообщения, если оно открыто и мы перешли в другое окно
                editingWindowShow = false
            }.padding(.trailing, 8)
        }
    }
}


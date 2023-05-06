//
//  OutgoingMessageEditingWindow.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.04.23.
//

import SwiftUI

struct OutgoingMessageEditingWindow: View {
    
    @State var messageListViewModel: MessageListViewModel
    @State var userName: String
    @State var userNameResponseMessage: String
    @State var textResponseMessage: String
    @Binding var replyIdMessage: String
    @Binding var editingMessage: Bool
    @Binding var ChangeableMessage: Message?
    @Binding var textNewMessage: String
    @Binding var editingWindowShow: Bool
    @Binding var replyWindowShow: Bool
    
    var body: some View {
        VStack(alignment: .trailing){
            OutgoingMessageView(messageViewModel: messageListViewModel.MessageToMessageViewModel(ChangeableMessage?.id ?? ""), userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage)
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
                    editingMessage = true
                    editingWindowShow.toggle()
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
                    messageListViewModel.removeMessage(ChangeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))
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

//struct OutgoingMessageEditingWindow_Previews: PreviewProvider {
//    static var previews: some View {
//        OutgoingMessageEditingWindow()
//    }
//}

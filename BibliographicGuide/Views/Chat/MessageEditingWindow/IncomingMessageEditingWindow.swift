//
//  IncomingMessageEditingWindow.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.04.23.
//

import SwiftUI

struct IncomingMessageEditingWindow: View {
    
    var messageListViewModel: MessageListViewModel
    var userName: String
    var userNameResponseMessage: String
    var textResponseMessage: String
    @Binding var replyIdMessage: String
    @Binding var editingMessage: Bool
    @Binding var ChangeableMessage: Message?
    @Binding var textNewMessage: String
    @Binding var editingWindowShow: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            IncomingMessageView(messageViewModel: messageListViewModel.MessageToMessageViewModel(ChangeableMessage?.id ?? ""), userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage)
            VStack(spacing: 0){
                HStack{
                    Text("Ответить")
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 10, trailing: 0))
                    Spacer()
                    Image(systemName: "arrowshape.turn.up.left")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 20))
                }
                .background(Color.white)
                .onTapGesture {
                    editingWindowShow.toggle()
                    replyIdMessage = ChangeableMessage?.id ?? "" // сохраняем id сообщения к которому прикрепляется сообщение
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

//struct IncomingMessageEditingWindow_Previews: PreviewProvider {
//    static var previews: some View {
//        IncomingMessageEditingWindow()
//    }
//}

//
//  MessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import SwiftUI

struct MessageView: View {
    
    
    var messageViewModel: MessageViewModel
    var userName: String
    var userNameResponseMessage: String
    var textResponseMessage: String
    var outgoingOrIncomingMessage: Bool
    var messageListViewModel: MessageListViewModel
    
    var body: some View {
        VStack{
            if(messageListViewModel.showDateMessage(messageViewModel.message) == true){
                Text(messageViewModel.dateMessage(messageViewModel.message.date))
                    .font(.system(size: 16))
                    .font(.caption)
                    .foregroundColor(Color(white: 0.6))
                    .padding(.top, 15)
            }
            if(outgoingOrIncomingMessage == true){
                OutgoingMessageView(messageViewModel: messageViewModel, userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage)
            }
            else{
                IncomingMessageView(messageViewModel: messageViewModel, userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage)
            }
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(messageViewModel: MessageViewModel(message: Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)))
//    }
//}

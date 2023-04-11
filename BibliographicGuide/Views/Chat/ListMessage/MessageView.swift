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
    var OutgoingOrIncomingMessage: Bool
    
    var body: some View {
        VStack{
            if(OutgoingOrIncomingMessage == true){
                OutgoingMessageView(messageViewModel: messageViewModel, userName: userName)
            }
            else{
                IncomingMessageView(messageViewModel: messageViewModel, userName: userName)
            }
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(messageViewModel: MessageViewModel(message: Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)))
//    }
//}

//
//  MessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import SwiftUI

struct MessageView: View {
    
    var messageListViewModel: MessageListViewModel
    var messageViewModel: MessageViewModel
    var userName: String
    var userNameResponseMessage: String
    var textResponseMessage: String
    var outgoingOrIncomingMessage: Bool
    @Binding var newMessageId: String
    
    @Binding var selectedMessage: Message?
    @Binding var selectedImage: Int
    @Binding  var openFullSizeImage: Bool
    @Binding var editingWindowShow: Bool
    
    var body: some View {
        VStack{
            if(messageListViewModel.showDateMessage(messageViewModel.message) == true){
                Text(messageViewModel.dateMessage(messageViewModel.message.date ?? Date()))
                    .font(.system(size: 15))
                    .font(.caption)
                    .foregroundColor(Color(white: 0.6))
                    .padding(.top, 15)
            }
            if(outgoingOrIncomingMessage == true){
                OutgoingMessageView(messageListViewModel: messageListViewModel, messageViewModel: messageViewModel, userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage, editingWindowShow: $editingWindowShow, isEditingWindow: true)
                    .padding(.top, 6)
            }
            else{
                IncomingMessageView(messageListViewModel: messageListViewModel, messageViewModel: messageViewModel, userName: userName, userNameResponseMessage: userNameResponseMessage, textResponseMessage: textResponseMessage, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage, editingWindowShow: $editingWindowShow, isEditingWindow: true)
                    .padding(.top, 6)
            }
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(messageViewModel: MessageViewModel(message: Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)))
//    }
//}

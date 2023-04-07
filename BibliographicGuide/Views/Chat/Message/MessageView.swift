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
    
    var body: some View {
        VStack{
            VStack{
//                ForEach(hh) { information in
//                    if(messageViewModel.message.idUser == information.id){
//                        Text(information.userName)
//                    }
//                }
                Text(userName)
                
                if(messageViewModel.message.replyIdMessage != ""){ // отображаем текст ответа на сообщение
                    Text(messageViewModel.message.replyIdMessage)
                }
                Text(messageViewModel.message.text)
            }
            HStack{
                if(messageViewModel.message.editing == true){
                    Text("Ред.")
                }
                Text(messageViewModel.timeMessage(messageViewModel.message.date))
            }
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(messageViewModel: MessageViewModel(message: Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)))
//    }
//}

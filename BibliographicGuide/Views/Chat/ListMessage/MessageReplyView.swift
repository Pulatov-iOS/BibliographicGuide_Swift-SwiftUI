//
//  MessageReplyView.swift
//  BibliographicGuide
//
//  Created by Alexander on 7.05.23.
//

import SwiftUI

struct MessageReplyView: View {
    
    @State var messageListViewModel: MessageListViewModel
    @Binding var changeableMessage: Message?
    @Binding var replyWindowShow: Bool
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "arrowshape.turn.up.left")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.blue)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 10))
                RoundedRectangle(cornerRadius: 1)
                    .fill(.blue)
                    .frame(width: 3, height: 33)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                VStack(alignment: .leading){
                    Text(messageListViewModel.getUserName(changeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)))
                        .lineLimit(1)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                    Text(changeableMessage?.text ?? "")
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "multiply")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color.blue)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 16))
                    .onTapGesture {
                        replyWindowShow = false
                    }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
        }.background(Color(white: 0.97))
    }
}

//struct MessageReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageReplyView()
//    }
//}

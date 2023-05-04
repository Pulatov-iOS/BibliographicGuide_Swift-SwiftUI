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
    @State private var replyWindowShow = false
    @State private var editingMessage = false
    @State private var ChangeableMessage: Message?
    
    var body: some View {
        ZStack(alignment: .trailing){
            VStack(spacing: 0){
                VStack{
                    ScrollView(.vertical, showsIndicators: true, content: {
                        VStack {
                            ForEach(messageListViewModel.messageViewModels) { messages in
                                MessageView(messageViewModel: messages, userName: messageListViewModel.getUserName(messages.message), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(messages.message.replyIdMessage), textResponseMessage: messageListViewModel.getTextResponseMessage(messages.message.replyIdMessage), outgoingOrIncomingMessage: messageListViewModel.OutgoingOrIncomingMessage(messages.message), messageListViewModel: messageListViewModel)
                                    .onLongPressGesture(minimumDuration: 0.5){
                                        ChangeableMessage = messages.message
                                        editingWindowShow.toggle()
                                    }
                            }
                        }.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                            .padding(.top, 15)
                                }).rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                }
                
                if(replyWindowShow == true){
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
                                Text(messageListViewModel.getUserName(ChangeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)))
                                    .lineLimit(1)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                                Text(ChangeableMessage?.text ?? "")
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
                
                HStack(spacing: 4){
                    Button{
                        
                    } label: {
                        Image(systemName: "paperclip")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                    }
                    .padding(8)
                    TextField("Comment", text: $textNewMessage, prompt: Text("Сообщение"), axis: .vertical)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...5)
                        
                    if(editingMessage != true){
                        Button{
                            if(textNewMessage != ""){ // если текст есть, то отправляем сообщение
                                var mes = Message(idUser: "0y1kzDU4QxMqjxDSeTupTOmWbDl2", typeMessage: "text", date: Date(), text: textNewMessage, idFiles: [""], replyIdMessage: replyIdMessage, editing: false)
                                messageListViewModel.addMessage(mes)
                                replyWindowShow = false
                            }
                            textNewMessage = ""
                            replyIdMessage = ""
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
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
                .background(.ultraThinMaterial)
                .onTapGesture {
                    editingWindowShow = false
                }
                
                if(messageListViewModel.OutgoingOrIncomingMessage(ChangeableMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))){
                    OutgoingMessageEditingWindow(messageListViewModel: messageListViewModel, userName: messageListViewModel.getUserName(ChangeableMessage ??  Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(ChangeableMessage?.replyIdMessage ?? ""), textResponseMessage: messageListViewModel.getTextResponseMessage(ChangeableMessage?.replyIdMessage ?? ""), replyIdMessage: $replyIdMessage, editingMessage: $editingMessage, ChangeableMessage: $ChangeableMessage, textNewMessage: $textNewMessage, editingWindowShow: $editingWindowShow, replyWindowShow: $replyWindowShow)
                }
                else{
                    IncomingMessageEditingWindow(messageListViewModel: messageListViewModel, userName: messageListViewModel.getUserName(ChangeableMessage ??  Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false)), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(ChangeableMessage?.replyIdMessage ?? ""), textResponseMessage: messageListViewModel.getTextResponseMessage(ChangeableMessage?.replyIdMessage ?? ""), replyIdMessage: $replyIdMessage, editingMessage: $editingMessage, ChangeableMessage: $ChangeableMessage, textNewMessage: $textNewMessage, editingWindowShow: $editingWindowShow, replyWindowShow: $replyWindowShow)
                }
            }
        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                HStack {
//                    Text("Общий чат").font(.headline)
//                }
//            }
//        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(messageListViewModel: MessageListViewModel())
    }
}

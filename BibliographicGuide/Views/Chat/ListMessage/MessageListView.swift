//
//  MessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import SwiftUI
import PhotosUI

struct MessageListView: View {
    
    @ObservedObject var messageListViewModel: MessageListViewModel
    
    @State private var textNewMessage = ""
    @State private var replyIdMessage = ""
    @Binding var editingWindowShow: Bool
    @State private var replyWindowShow = false
    @State private var changeWindowShow = false
    @State private var imagesWindowShow = false
    @Binding var selectedMessage: Message?
    
    @State private var imagesPhotosPicker = [PhotosPickerItem]()
    @State private var imagesImage = [ImageModel]()
    @State private var imagesData = [Data]()
    @Binding var newMessageId: String
    @Binding var openFullSizeImage: Bool
    @Binding var selectedImage: Int
    
    @State private var changeKeyboardIsFocused = false
    @FocusState private var keyboardIsFocused: Bool
    
    @State var showAlert: Bool = false
    @State var alertTextTitle = ""
    @State var alertTextMessage = ""
    
    var body: some View {
        ZStack(alignment: .trailing){
            VStack(spacing: 0){
                ZStack{
                    VStack{
                        Text("Общий чат")
                            .font(.headline)
                        Text(messageListViewModel.stringCountUsers(countUsers: messageListViewModel.usersInformation.count))
                            .padding(.bottom, 5)
                            .font(.footnote)
                    }.padding(0)
                    HStack{
                        Spacer()
                        Image(systemName: "message")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 10)
                            .padding(.bottom, 8)
                            .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                    }
                }
                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                Divider()
                VStack{
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack(spacing: 0){
                            ForEach(messageListViewModel.messageViewModels) { messages in
                                MessageView(messageListViewModel: messageListViewModel, messageViewModel: messages, userName: messageListViewModel.getUserName(messages.message), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(messages.message.replyIdMessage), textResponseMessage: messageListViewModel.getTextResponseMessage(messages.message.replyIdMessage), outgoingOrIncomingMessage: messageListViewModel.OutgoingOrIncomingMessage(messages.message), newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage, editingWindowShow: $editingWindowShow)
                            }
                        }
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                            .padding(.top, 15)
                                }).rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        
                }
                .onChange(of: changeKeyboardIsFocused){ value in
                    keyboardIsFocused = true // открытие клавиатуры при ответе и изменении сообщения
                }
                .onTapGesture {
                    keyboardIsFocused = false // закрытие клавиатуры при нажатии на экран
                }
                
                if(replyWindowShow == true){
                    MessageReplyView(messageListViewModel: messageListViewModel, changeableMessage: $selectedMessage, replyWindowShow: $replyWindowShow)
                }
                if(changeWindowShow == true){
                    MessageChangeView(changeableMessage: $selectedMessage, changeWindowShow: $changeWindowShow, textNewMessage: $textNewMessage)
                }
                if(imagesWindowShow == true && imagesPhotosPicker.count > 0){
                    SelectedMessageImagesView(imagesPhotosPicker: $imagesPhotosPicker, imagesImage: $imagesImage, imagesData: $imagesData)
                }

                Divider()
                HStack(spacing: 4){
                    PhotosPicker(
                        selection: $imagesPhotosPicker,
                        maxSelectionCount: 6,
                        matching: .images
                    ){
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .background(Color(UIColor.init(hex: "#ffffff") ?? .white))
                            .cornerRadius(32)
                            .foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                            .padding(8)
                    }
                    .onChange(of: imagesPhotosPicker){ newValue in
                        var indexImage = 0
                        Task {
                            imagesImage.removeAll()
                            imagesData.removeAll()
                            for item in imagesPhotosPicker {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        imagesData.append(uiImage.jpegData(compressionQuality: 0.1) ?? Data())
                                        let image = Image(uiImage: uiImage)
                                        imagesImage.append(ImageModel(idInt: indexImage, image: image))
                                    }
                                }
                                indexImage += 1
                            }
                        }
                        imagesWindowShow = true
                    }
                        
                    TextField("Comment", text: $textNewMessage, prompt: Text("Сообщение"), axis: .vertical)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...5)
                        .focused($keyboardIsFocused)
                    if(changeWindowShow != true){
                        Button{
                            if(imagesImage.count == 0){
                                if(textNewMessage != ""){ // если текст есть, то отправляем сообщение
                                    if(!messageListViewModel.getСurrentUserInformation().blockingChat){
                                        var newMessage = Message(idUser: messageListViewModel.userId, typeMessage: "text", date: nil, text: textNewMessage, countImages: 0, replyIdMessage: replyIdMessage, editing: false)
                                        messageListViewModel.addMessage(newMessage, imageMessage: imagesData){ (verified, numberImage) in
                                            if !verified {
                                                
                                            }
                                            else{
                                                
                                            }
                                        }
                                        replyWindowShow = false
                                        textNewMessage = ""
                                        replyIdMessage = ""
                                    }
                                    else{
                                        alertTextTitle = "Отказано!"
                                        alertTextMessage = "Функция отправки сообщений заблокирована"
                                        showAlert.toggle()
                                    }
                                }
                            }
                            else{
                                if(!messageListViewModel.getСurrentUserInformation().blockingChat){
                                    let newMessage = Message(idUser: messageListViewModel.userId, typeMessage: "image", date: nil, text: textNewMessage, countImages: imagesImage.count, replyIdMessage: replyIdMessage, editing: false)
                                    messageListViewModel.addMessage(newMessage, imageMessage: imagesData){ (verified, idMessage) in
                                        if !verified {
                                        }
                                        else{
                                            newMessageId = idMessage
                                        }
                                    }
                                    imagesWindowShow = false
                                    imagesPhotosPicker.removeAll()
                                    replyWindowShow = false
                                    textNewMessage = ""
                                    replyIdMessage = ""
                                }
                                else{
                                    alertTextTitle = "Отказано!"
                                    alertTextMessage = "Функция отправки сообщений заблокирована"
                                    showAlert.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                .background(Color(UIColor.init(hex: "#ffffff") ?? .white))
                                .cornerRadius(32)
                        }
                        .padding(8)
                    }
                    else{
                        Button{
                            if(!messageListViewModel.getСurrentUserInformation().blockingChat){
                                changeWindowShow = false
                                if(selectedMessage?.text != textNewMessage){
                                    selectedMessage?.editing = true
                                    selectedMessage?.text = textNewMessage
                                    messageListViewModel.updateMessage(selectedMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", countImages: 0, replyIdMessage: "", editing: false))
                                }
                                textNewMessage = ""
                            }
                            else{
                                alertTextTitle = "Отказано!"
                                alertTextMessage = "Функция отправки сообщений заблокирована"
                                showAlert.toggle()
                            }
                        }  label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 33, height: 32)
                                .foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        }
                        .padding(8)
                    }
                }
                .padding(4)
                .background(Color(white: 0.97))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertTextTitle),
                        message: Text(alertTextMessage),
                        dismissButton: .default(Text("Ок"))
                    )
                }
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
                        openFullSizeImage = false
                    }
              
                if(messageListViewModel.OutgoingOrIncomingMessage(selectedMessage ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", countImages: 0, replyIdMessage: "", editing: false))){
                    OutgoingMessageEditingView(messageListViewModel: messageListViewModel, userName: messageListViewModel.getUserName(selectedMessage ??  Message(idUser: "", typeMessage: "", date: Date(), text: "", countImages: 0, replyIdMessage: "", editing: false)), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(selectedMessage?.replyIdMessage ?? ""), textResponseMessage: messageListViewModel.getTextResponseMessage(selectedMessage?.replyIdMessage ?? ""), replyIdMessage: $replyIdMessage, changeWindowShow: $changeWindowShow, ChangeableMessage: $selectedMessage, textNewMessage: $textNewMessage, editingWindowShow: $editingWindowShow, replyWindowShow: $replyWindowShow, changeKeyboardIsFocused: $changeKeyboardIsFocused, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage)
                }
                else{
                    IncomingMessageEditingView(messageListViewModel: messageListViewModel, userName: messageListViewModel.getUserName(selectedMessage ??  Message(idUser: "", typeMessage: "", date: Date(), text: "", countImages: 0, replyIdMessage: "", editing: false)), userNameResponseMessage: messageListViewModel.getUserNameResponseMessage(selectedMessage?.replyIdMessage ?? ""), textResponseMessage: messageListViewModel.getTextResponseMessage(selectedMessage?.replyIdMessage ?? ""), replyIdMessage: $replyIdMessage, changeWindowShow: $changeWindowShow, ChangeableMessage: $selectedMessage, textNewMessage: $textNewMessage, editingWindowShow: $editingWindowShow, replyWindowShow: $replyWindowShow, changeKeyboardIsFocused: $changeKeyboardIsFocused, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage, showAlert: $showAlert, alertTextTitle: $alertTextTitle, alertTextMessage: $alertTextMessage)
                }
            }
        }
    }
}

struct ImageModel: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let id = UUID()
    let idInt: Int
    let image: Image
}

//struct MessageListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageListView(messageListViewModel: MessageListViewModel())
//    }
//}

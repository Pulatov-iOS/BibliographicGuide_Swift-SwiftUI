//
//  OutgoingMessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 7.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct OutgoingMessageView: View {
    
    var messageListViewModel: MessageListViewModel
    var messageViewModel: MessageViewModel
    var userName: String
    var userNameResponseMessage: String
    var textResponseMessage: String
    @Binding var newMessageId: String
    
    @Binding var selectedMessage: Message?
    @Binding var selectedImage: Int
    @Binding  var openFullSizeImage: Bool
    @Binding var editingWindowShow: Bool
    @State var isEditingWindow = true
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .trailing) {
                VStack(alignment: .trailing, spacing: 0) {
                    if(messageViewModel.message.replyIdMessage != ""){ // отображаем текст ответа на сообщение
                        HStack(){
                            RoundedRectangle(cornerRadius: 1)
                                .fill(.green)
                                .frame(width: 3, height: 33)
                                .padding(EdgeInsets(top: 4, leading: 10, bottom: 0, trailing: 0))
                            VStack{
                                Text(userNameResponseMessage)
                                    .font(.system(size: 15))
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 4))
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if(textResponseMessage != ""){
                                    Text(textResponseMessage)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.trailing, 4)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                else{
                                    if(messageListViewModel.getCountImagesResponseMessage(messageViewModel.message.replyIdMessage) == 1){
                                        Text("[Фотография]")
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                            .padding(.trailing, 4)
                                            .lineLimit(1)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    else{
                                        Text("[Фотографии]")
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                            .padding(.trailing, 4)
                                            .lineLimit(1)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        if(messageViewModel.message.countImages > 0){
                            VStack{
                                
                            }.padding(.bottom, 5)
                        }
                    }
                    
                    ZStack{
                        HStack{
                            if(messageViewModel.message.countImages > 0){
                                MessageImages(messageListViewModel: messageListViewModel, messageViewModel: messageViewModel, newMessageId: $newMessageId, selectedMessage: $selectedMessage, selectedImage: $selectedImage, openFullSizeImage: $openFullSizeImage)
                            }
                        }
                        // Если изображение без текста
                        if(messageViewModel.message.text == ""){
                            VStack{
                                Spacer()
                                HStack{
                                    Spacer()
                                    if(messageViewModel.message.editing == true){
                                        Text("ред.")
                                            .font(.caption)
                                            .foregroundColor(Color(.white))
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                                    }
                                    Text(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))
                                        .font(.caption)
                                        .foregroundColor(Color(white: 0.9))
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                                }
                            }
                            .frame(maxWidth: UIScreen.screenWidth * 0.66, maxHeight: heightImageOutgoingMessage(messageViewModel))
                        }
                    }
                    
                    // Если изображение с текстом
                    if(messageViewModel.message.text != ""){
                        
                        // Если текст сообщения короткий, то время ставится сразу после него
                        if((messageViewModel.message.editing == true && labelSizeTimeOutgoing(textWithTime: ("\(messageViewModel.message.text)ред.\(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))")) < UIScreen.screenWidth * 0.66) || (messageViewModel.message.editing == false && labelSizeTimeOutgoing(textWithTime: ("\(messageViewModel.message.text)\(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))")) < UIScreen.screenWidth * 0.66)){
                            HStack{
                                HStack{
                                    Text(messageViewModel.message.text)
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                        .padding([.top, .leading, .trailing], 8)
                                        .padding(.bottom, 6)
                                        .lineLimit(nil)
                                    Spacer()
                                }
                                //.frame(maxWidth: .infinity, alignment: .leading)
                                HStack{
                                    if(messageViewModel.message.editing == true){
                                        Text("ред.")
                                            .font(.caption)
                                            .foregroundColor(Color(.white))
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                                    }
                                    Text(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))
                                        .font(.caption)
                                        .foregroundColor(Color(white: 0.9))
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                                }
                                .frame(maxHeight: 40, alignment: .bottom)
                            }
                        }
                        else{
                            HStack{
                                Text(messageViewModel.message.text)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding([.top, .leading, .trailing], 8)
                                    .padding(.bottom, 1)
                                    .lineLimit(nil)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                if(messageViewModel.message.editing == true){
                                    Text("ред.")
                                        .font(.caption)
                                        .foregroundColor(Color(.white))
                                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 0))
                                }
                                Text(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))
                                    .font(.caption)
                                    .foregroundColor(Color(white: 0.9))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .onTapGesture {

                }
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            if(isEditingWindow){
                                selectedMessage = messageViewModel.message
                                editingWindowShow.toggle()
                            }
                        }
                )
                .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                .cornerRadius(8)
            }
            .frame(maxWidth: widthOutgoingMessage(messageViewModel: self.messageViewModel, userName: userName, text: messageViewModel.message.text, time: messageViewModel.timeMessage(messageViewModel.message.date ?? Date()), editing: messageViewModel.message.editing), alignment: .trailing) // было 16
            .padding(.trailing, 8)
        }
    }
}

func widthOutgoingMessage(messageViewModel: MessageViewModel,userName: String, text: String, time: String, editing: Bool) -> CGFloat {
    var widthMessage: CGFloat
    if(messageViewModel.message.countImages > 0){
        widthMessage = UIScreen.screenWidth * 0.66
    }
    else{
        widthMessage = (labelSizeTextOutgoing(userName: userName, text: messageViewModel.message.text, time: messageViewModel.timeMessage(messageViewModel.message.date ?? Date()), editing: messageViewModel.message.editing)) + 18
    }
    return widthMessage
}

func heightImageOutgoingMessage(_ messageViewModel: MessageViewModel) -> CGFloat {
    switch messageViewModel.message.countImages {
    case 1:
        return UIScreen.screenWidth * 0.66
    case 2:
        return UIScreen.screenWidth * 0.33
    case 3:
        return UIScreen.screenWidth * 0.22
    case 4:
        return UIScreen.screenWidth * 0.66
    case 5:
        return UIScreen.screenWidth * 0.55
    case 6:
        return UIScreen.screenWidth * 0.44
    default:
        return UIScreen.screenWidth * 0.66
    }
}


// узнать ширину и высоту (имени и текста)
func labelSizeTextOutgoing(userName: String, text: String, time: String, editing: Bool) -> CGFloat { // CGSize
    let strArray = [userName, text, time, "ред." + time]
    var rect = [CGRect]()
    for index in 0...3 {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let attributedText = NSAttributedString(string: strArray[index], attributes: attributes)
        let constraintBox = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        rect.append(attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral)
    }
    var widthText: CGFloat
    
    // ширина сообщения, если оно в одну строку
    if((editing == true && (rect[1].size.width + rect[3].size.width) < UIScreen.screenWidth * 0.66) || (editing == false && (rect[1].size.width + rect[2].size.width) < UIScreen.screenWidth * 0.66)){
        
        if(editing == true){
            widthText = rect[1].size.width + rect[3].size.width + 10
        }
        else{
            widthText = rect[1].size.width + rect[2].size.width + 10
        }
    }
    else{
        // ограничение ширины сообщения в 0.8 от ширины экрана пользователя
        if(rect[1].size.width > UIScreen.screenWidth * 0.66){
            widthText = UIScreen.screenWidth * 0.66
        }
        else{
            widthText = rect[1].size.width
        }
    }
    return widthText // rect.size
}

// узнать ширину и высоту (текста и времени в одну строку)
func labelSizeTimeOutgoing(textWithTime: String) -> CGFloat { // CGSize
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16)
    ]
    let attributedText = NSAttributedString(string: textWithTime, attributes: attributes)
    let constraintBox = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
    return rect.size.width
}

//
//  IncomingMessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 7.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct IncomingMessageView: View {
    
    var messageViewModel: MessageViewModel
    var userName: String
    var userNameResponseMessage: String
    var textResponseMessage: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack{
                        WebImage(url: URL(string: "https://sun9-47.userapi.com/impg/pZPc4CkVZuBFxq5o8sLnqql1E5QAGv-duK110g/k65Itu6amGE.jpg?size=607x1080&quality=95&sign=98e693801965832b0f3daf57957f51bd&type=album"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                    .scaledToFit()
                    .padding(.leading, 6)
                }
            }
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(userName)
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding([.top, .leading, .trailing], 8)
                        .clipped()
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
                                Text(textResponseMessage)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.trailing, 4)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    // Если текст сообщения короткий, то время ставится сразу после него
                    if((messageViewModel.message.editing == true && labelSizeTimeIncoming(textWithTime: ("\(messageViewModel.message.text)ред.\(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))")) < UIScreen.screenWidth * 0.65) || (messageViewModel.message.editing == false && labelSizeTimeIncoming(textWithTime: ("\(messageViewModel.message.text)\(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))")) < UIScreen.screenWidth * 0.65)){
                        HStack{
                            Text(messageViewModel.message.text)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .padding([.leading, .trailing], 8)
                                .padding(.bottom, 6)
                                .lineLimit(nil)
                            HStack{
                                if(messageViewModel.message.editing == true){
                                    Text("ред.")
                                        .font(.caption)
                                        .foregroundColor(Color(white: 0.6))
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                                }
                                Text(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))
                                    .font(.caption)
                                    .foregroundColor(Color(white: 0.6))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                            }
                            .frame(maxHeight: 40, alignment: .bottom)
                        }
                    }
                    else{
                        Text(messageViewModel.message.text)
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .padding([.leading, .trailing], 8)
                            .padding(.bottom, 1)
                            .lineLimit(nil)
                        HStack{
                            if(messageViewModel.message.editing == true){
                                Text("ред.")
                                    
                                    .font(.caption)
                                    .foregroundColor(Color(.black))
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 0))
                            }
                            Text(messageViewModel.timeMessage(messageViewModel.message.date ?? Date()))
                                .font(.caption)
                                .foregroundColor(Color(white: 0.6))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .background(Color(white: 0.9))
                .cornerRadius(8)
            }
            .frame(maxWidth: (labelSizeTextIncoming(userName: userName, text: messageViewModel.message.text, time: messageViewModel.timeMessage(messageViewModel.message.date ?? Date()), editing: messageViewModel.message.editing))+24, alignment: .leading) // было 16
            //.background(Color(.blue))
            Spacer()
        }
    }
}

// узнать ширину и высоту (имени и текста)
func labelSizeTextIncoming(userName: String, text: String, time: String, editing: Bool) -> CGFloat { // CGSize
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
    if((editing == true && (rect[1].size.width + rect[3].size.width) < UIScreen.screenWidth * 0.65) || (editing == false && (rect[1].size.width + rect[2].size.width) < UIScreen.screenWidth * 0.65)){
        
        if((editing == true && rect[0].size.width > (rect[1].size.width + rect[3].size.width)) || (editing == false && rect[0].size.width > (rect[1].size.width + rect[2].size.width))){ // если имя пользователя больше длины сообщения
            widthText = rect[0].size.width
        }
        else{
            if(editing == true){
                widthText = rect[1].size.width + rect[3].size.width + 10
            }
            else{
                widthText = rect[1].size.width + rect[2].size.width + 10
            }
        }
    }
    else{
        if(rect[0].size.width > rect[1].size.width){ // если имя пользователя больше длины сообщения
            widthText = rect[0].size.width
        }
        else{
            // ограничение ширины сообщения в 0.8 от ширины экрана пользователя
            if(rect[1].size.width > UIScreen.screenWidth * 0.65){
                widthText = UIScreen.screenWidth * 0.65
            }
            else{
                widthText = rect[1].size.width
            }
        }
    }
    return widthText // rect.size
}

// узнать ширину и высоту (текста и времени в одну строку)
func labelSizeTimeIncoming(textWithTime: String) -> CGFloat { // CGSize
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16)
    ]
    let attributedText = NSAttributedString(string: textWithTime, attributes: attributes)
    let constraintBox = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
    return rect.size.width
}

// размеры экрана пользователя
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

//struct IncomingMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        IncomingMessageView()
//    }
//}

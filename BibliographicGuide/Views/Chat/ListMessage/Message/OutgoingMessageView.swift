//
//  OutgoingMessageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 7.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct OutgoingMessageView: View {
    
    var messageViewModel: MessageViewModel
    var userName: String
    var userNameResponseMessage: String
    var textResponseMessage: String
    
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
                    if((messageViewModel.message.editing == true && labelSizeTimeOutgoing(textWithTime: ("\(messageViewModel.message.text)ред.\(messageViewModel.timeMessage(messageViewModel.message.date))")) < UIScreen.screenWidth * 0.65) || (messageViewModel.message.editing == false && labelSizeTimeOutgoing(textWithTime: ("\(messageViewModel.message.text)\(messageViewModel.timeMessage(messageViewModel.message.date))")) < UIScreen.screenWidth * 0.65)){
                        HStack{
                            HStack{
                                Text(messageViewModel.message.text)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding([.top, .leading, .trailing], 8)
                                    .padding(.bottom, 6)
                                    .lineLimit(nil)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack{
                                if(messageViewModel.message.editing == true){
                                    Text("ред.")
                                        .font(.caption)
                                        .foregroundColor(Color(.white))
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                                }
                                Text(messageViewModel.timeMessage(messageViewModel.message.date))
                                    .font(.caption)
                                    .foregroundColor(Color(white: 0.9))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
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
                            Text(messageViewModel.timeMessage(messageViewModel.message.date))
                                .font(.caption)
                                .foregroundColor(Color(white: 0.9))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                .cornerRadius(8)
            }
            .frame(maxWidth: (labelSizeTextOutgoing(userName: userName, text: messageViewModel.message.text, time: messageViewModel.timeMessage(messageViewModel.message.date), editing: messageViewModel.message.editing))+24, alignment: .trailing) // было 16
            //.background(Color(.blue))
            .padding(.trailing, 8)
        }
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
                print(text)
                print(rect[1].size.width)
            }
            else{
                widthText = rect[1].size.width
            }
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




//struct OutgoingMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        OutgoingMessageView()
//    }
//}

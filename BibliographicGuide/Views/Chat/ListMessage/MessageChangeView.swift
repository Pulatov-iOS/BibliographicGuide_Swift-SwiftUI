//
//  MessageChangeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 7.05.23.
//

import SwiftUI

struct MessageChangeView: View {
    
    @Binding var changeableMessage: Message?
    @Binding var changeWindowShow: Bool
    @Binding var textNewMessage: String
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.blue)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 10))
                RoundedRectangle(cornerRadius: 1)
                    .fill(.blue)
                    .frame(width: 3, height: 33)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                VStack(alignment: .leading){
                    Text("Редактирование")
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
                        textNewMessage = ""
                        changeWindowShow = false
                    }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
        }.background(Color(white: 0.97))
    }
}

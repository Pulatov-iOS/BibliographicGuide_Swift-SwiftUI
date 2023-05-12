//
//  FullSizeImageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 8.05.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageFullSizeImageView: View {
    
    var selectedMessage: Message
    @Binding var selectedImage: Int
    @State private var imageUrl = URL(string: "")
    @Binding var newMessageId: String
    @Binding var openFullSizeImage: Bool
    
    var body: some View {
        HStack{
            VStack{
                ZStack{
                    HStack{
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 8, height: 15)
                        Text("Назад")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        openFullSizeImage = false
                    }
                    HStack{
                        Text("\(selectedImage + 1) из \(selectedMessage.countImages)")
                    }
                    .foregroundColor(Color.white)
                }
               
                WebImage(url: imageUrl)
                    .resizable()
                 //   .aspectRatio(contentMode: .fit)
                    .clipped()
            }
        }
        .scaledToFit()
        .onAppear{
            getImageUrl(pathImage: "ImageMessage", idImage: ("\(String(describing: selectedMessage.id!))_\(selectedImage)")){ (verified, status) in
                if !verified  {
                    imageUrl = status
                }
                else{
                    imageUrl = status
                }
            }
        }
        .onChange(of: newMessageId){ Value in
            if(newMessageId == selectedMessage.id){
                getImageUrl(pathImage: "ImageMessage", idImage: ("\(String(describing: selectedMessage.id!))_\(selectedImage)")){ (verified, status) in
                    if !verified  {
                        imageUrl = status
                    }
                    else{
                        imageUrl = status
                    }
                }
            }
        }
        .onChange(of: selectedImage){ Value in
            getImageUrl(pathImage: "ImageMessage", idImage: ("\(String(describing: selectedMessage.id!))_\(selectedImage)")){ (verified, status) in
                if !verified  {
                    imageUrl = status
                }
                else{
                    imageUrl = status
                }
            }
        }
    }
}

func getImageUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void){
    globalMessageRepository.getImageUrl(pathImage: pathImage, idImage: idImage){ (verified, status) in
        if !verified  {
            completion(false, URL(string: "https://turbok.by/public/img/no-photo--lg.png")!)
        }
        else{
            completion(true, status)
        }
    }
}

//struct MessageFullSizeImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageFullSizeImageView()
//    }
//}

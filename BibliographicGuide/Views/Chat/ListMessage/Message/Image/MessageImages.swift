//
//  MessageImages.swift
//  BibliographicGuide
//
//  Created by Alexander on 8.05.23.
//
import UIKit
import Combine
import SwiftUI
import SDWebImageSwiftUI


struct MessageImages: View {
    
    var messageListViewModel: MessageListViewModel
    @State var messageViewModel: MessageViewModel
    @State private var imagesUrl = [URL(string: ""), URL(string: ""), URL(string: ""), URL(string: ""), URL(string: ""), URL(string: "")]
    @Binding var newMessageId: String
    @State var isHideLoader: [Bool] = [false, false, false, false, false, false]
    
    @Binding var selectedMessage: Message?
    @Binding var selectedImage: Int
    @Binding var openFullSizeImage: Bool
    
    var body: some View {
        VStack(spacing: 0){
            
            // Если фотография 1
            if(messageViewModel.message.countImages == 1){
                HStack(spacing: 0){
                    ForEach(0...(messageViewModel.message.countImages - 1), id: \.self){ id in
                        VStack{
                            ZStack{
                                VStack{
                                    WebImage(url: imagesUrl[id]).centerCropped()
                                        .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                        .clipped()
                                }
                                .onTapGesture {
                                        selectedMessage = messageViewModel.message
                                        selectedImage = id
                                        openFullSizeImage = true
                                }
                                LoaderView(tintColor: .white, scaleSize: 1.5).hidden(isHideLoader[id])
                            }
                        }
                        .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                    }
                }
                .frame(width: widthImage(messageViewModel) * CGFloat(messageViewModel.message.countImages), height: heightImage(messageViewModel))
            }
            
            // Если фотографий 2
            if(messageViewModel.message.countImages == 2){
                HStack(spacing: 0){
                    ForEach(0...(messageViewModel.message.countImages - 1), id: \.self){ id in
                        VStack{
                            ZStack{
                                VStack{
                                    WebImage(url: imagesUrl[id]).centerCropped()
                                        .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                        .clipped()
                                }
                                .onTapGesture {
                                        selectedMessage = messageViewModel.message
                                        selectedImage = id
                                        openFullSizeImage = true
                                }
                                LoaderView(tintColor: .white, scaleSize: 1.2).hidden(isHideLoader[id])
                            }
                        }
                        .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                    }
                }
                .frame(width: widthImage(messageViewModel) * CGFloat(messageViewModel.message.countImages), height: heightImage(messageViewModel))
            }
            
            // Если фотографий 3
            if(messageViewModel.message.countImages == 3){
                HStack(spacing: 0){
                    ForEach(0...(messageViewModel.message.countImages - 1), id: \.self){ id in
                        VStack{
                            ZStack{
                                VStack{
                                    WebImage(url: imagesUrl[id]).centerCropped()
                                        .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                        .clipped()
                                }
                                .onTapGesture {
                                        selectedMessage = messageViewModel.message
                                        selectedImage = id
                                        openFullSizeImage = true
                                }
                                LoaderView(tintColor: .white, scaleSize: 1.0).hidden(isHideLoader[id])
                            }
                        }
                        .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                    }
                }
                .frame(width: widthImage(messageViewModel) * CGFloat(messageViewModel.message.countImages), height: heightImage(messageViewModel))
            }
            
            // Если фотографий 4
            if(messageViewModel.message.countImages == 4){
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        ForEach(0...1, id: \.self){ id in
                            VStack{
                                ZStack{
                                    VStack{
                                        WebImage(url: imagesUrl[id]).centerCropped()
                                            .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                            .clipped()
                                    }
                                    .onTapGesture {
                                            selectedMessage = messageViewModel.message
                                            selectedImage = id
                                            openFullSizeImage = true
                                    }
                                    LoaderView(tintColor: .white, scaleSize: 1.2).hidden(isHideLoader[id])
                                }
                            }
                            .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                        }
                    }
                    .frame(width: widthImage(messageViewModel) * CGFloat(2), height: heightImage(messageViewModel))
                    HStack(spacing: 0){
                        ForEach(2...3, id: \.self){ id in
                            VStack{
                                ZStack{
                                    VStack{
                                        WebImage(url: imagesUrl[id]).centerCropped()
                                            .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                            .clipped()
                                    }
                                    .onTapGesture {
                                            selectedMessage = messageViewModel.message
                                            selectedImage = id
                                            openFullSizeImage = true
                                    }
                                    LoaderView(tintColor: .white, scaleSize: 1.2).hidden(isHideLoader[id])
                                }
                            }
                            .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                        }
                    }.frame(width: widthImage(messageViewModel) * CGFloat(2), height: heightImage(messageViewModel))
                }
            }
            
            // Если фотографий 5
            if(messageViewModel.message.countImages == 5){
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        ForEach(0...1, id: \.self){ id in
                            VStack{
                                ZStack{
                                    VStack{
                                        WebImage(url: imagesUrl[id]).centerCropped()
                                            .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                            .clipped()
                                    }
                                    .onTapGesture {
                                            selectedMessage = messageViewModel.message
                                            selectedImage = id
                                            openFullSizeImage = true
                                    }
                                    LoaderView(tintColor: .white, scaleSize: 1.0).hidden(isHideLoader[id])
                                }
                            }
                            .frame(width: UIScreen.screenWidth * 0.33, height: UIScreen.screenWidth * 0.33)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.33 * CGFloat(2), height: UIScreen.screenWidth * 0.33)
                    HStack(spacing: 0){
                        ForEach(2...4, id: \.self){ id in
                            VStack{
                                ZStack{
                                    VStack{
                                        WebImage(url: imagesUrl[id]).centerCropped()
                                            .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                            .clipped()
                                    }
                                    .onTapGesture {
                                            selectedMessage = messageViewModel.message
                                            selectedImage = id
                                            openFullSizeImage = true
                                    }
                                    LoaderView(tintColor: .white, scaleSize: 1.0).hidden(isHideLoader[id])
                                }
                            }
                            .frame(width: UIScreen.screenWidth * 0.22, height: UIScreen.screenWidth * 0.22)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.22 * CGFloat(3), height: UIScreen.screenWidth * 0.22)
                }
            }

            // Если фотографий 6
            if(messageViewModel.message.countImages == 6){
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        ForEach(0...2, id: \.self){ id in
                            VStack{
                                ZStack{
                                    VStack{
                                        WebImage(url: imagesUrl[id]).centerCropped()
                                            .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                            .clipped()
                                    }
                                    .onTapGesture {
                                            selectedMessage = messageViewModel.message
                                            selectedImage = id
                                            openFullSizeImage = true
                                    }
                                    LoaderView(tintColor: .white, scaleSize: 1.0).hidden(isHideLoader[id])
                                }
                            }
                            .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                        }
                    }
                    .frame(width: widthImage(messageViewModel) * CGFloat(3), height: heightImage(messageViewModel))
                    HStack(spacing: 0){
                        ForEach(3...5, id: \.self){ id in
                            VStack{
                                ZStack{
                                    VStack{
                                        WebImage(url: imagesUrl[id]).centerCropped()
                                            .background(Color(#colorLiteral(red: 0.4711452723, green: 0.4828599095, blue: 0.9940789342, alpha: 1)))
                                            .clipped()
                                    }
                                    .onTapGesture {
                                            selectedMessage = messageViewModel.message
                                            selectedImage = id
                                            openFullSizeImage = true
                                    }
                                    LoaderView(tintColor: .white, scaleSize: 1.0).hidden(isHideLoader[id])
                                }
                            }
                            .frame(width: widthImage(messageViewModel), height: heightImage(messageViewModel))
                        }
                    }
                    .frame(width: widthImage(messageViewModel) * CGFloat(3), height: heightImage(messageViewModel))
                }
            }

        }.onAppear{
            for id in 0...messageViewModel.message.countImages {
                getImageUrl(pathImage: "ImageMessage", idImage: ("\(String(describing: messageViewModel.message.id!))_\(id)")){ (verified, status) in
                    if !verified {
                        imagesUrl[id] = status
                    }
                    else{
                        isHideLoader[id] = true
                        imagesUrl[id] = status
                    }
                }
            }
        }
        .onChange(of: newMessageId){ Value in
            if(newMessageId == messageViewModel.message.id){
                for id in 0...messageViewModel.message.countImages {
                    getImageUrl(pathImage: "ImageMessage", idImage: ("\(String(describing: messageViewModel.message.id!))_\(id)")){ (verified, status) in
                        if !verified  {
                            imagesUrl[id] = status
                        }
                        else{
                            isHideLoader[id] = true
                            imagesUrl[id] = status
                        }
                    }
                }
            }
       
        }
    }
}

func widthImage(_ messageViewModel: MessageViewModel) -> CGFloat {
    switch messageViewModel.message.countImages {
    case 1:
        return UIScreen.screenWidth * 0.66
    case 2:
        return UIScreen.screenWidth * 0.33
    case 3:
        return UIScreen.screenWidth * 0.22
    case 4:
        return UIScreen.screenWidth * 0.33
    case 6:
        return UIScreen.screenWidth * 0.22
    default:
        return UIScreen.screenWidth * 0.66
    }
}

func heightImage(_ messageViewModel: MessageViewModel) -> CGFloat {
    switch messageViewModel.message.countImages {
    case 1:
        return UIScreen.screenWidth * 0.66
    case 2:
        return UIScreen.screenWidth * 0.33
    case 3:
        return UIScreen.screenWidth * 0.22
    case 4:
        return UIScreen.screenWidth * 0.33
    case 6:
        return UIScreen.screenWidth * 0.22
    default:
        return UIScreen.screenWidth * 0.66
    }
}

extension WebImage {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .clipped()
        }
    }
}

//struct MessageImages_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageImages()
//    }
//}

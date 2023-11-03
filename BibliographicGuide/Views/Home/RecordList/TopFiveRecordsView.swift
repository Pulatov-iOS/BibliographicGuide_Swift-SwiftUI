//
//  TopFiveRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 18.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TopFiveRecordsView: View {
    
    var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    var userNameRecord: String
    @State private var showRecordPage: Bool = false
    @State private var imageUrl = URL(string: "")
    
    @State var isImageTitle = true
    @State var loadingImage = false
    @State var imageDefaultTitle = UIImage(named: "default-square")
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                ZStack(alignment: .bottom) {
                    VStack{
                        ZStack{
                            if(isImageTitle){
                                WebImage(url: imageUrl)
                                    .resizable()
                            }
                            else{
                                Image(uiImage: self.imageDefaultTitle ?? UIImage())
                                    .resizable()
                            }
                            LoaderView(tintColor: .gray, scaleSize: 1.5).hidden(loadingImage)
                        }
                    }
                    .frame(width: 190, height:  150)
                    .aspectRatio(contentMode: .fit)
                    .onAppear{
                        recordListViewModel.getImageUrl(pathImage: "ImageTitle", idImage: recordViewModel.record.id ?? ""){ (verified, status) in
                            if !verified  {
                                if(!(recordViewModel.record.updatingImage > 0)){
                                    isImageTitle = false
                                    imageUrl = status
                                    loadingImage = true
                                }
                            }
                            else{
                                isImageTitle = true
                                imageUrl = status
                                loadingImage = true
                            }
                        }
                    }
                    .onChange(of: recordViewModel.record.updatingImage){ Value in
                        recordListViewModel.getImageUrl(pathImage: "ImageTitle", idImage: recordViewModel.record.id ?? ""){ (verified, status) in
                            if !verified  {
                                isImageTitle = false
                                imageUrl = status
                            }
                            else{
                                isImageTitle = true
                                imageUrl = status
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "person.2")
                            .foregroundColor(Color.white)
                            .font(.callout)
                            .padding(.leading, 5)
                        
                        Text("\(userNameRecord)")
                            .foregroundColor(Color.white)
                            .font(.callout)
                            .lineLimit(1)
                        Spacer()
                        
                        Text(recordListViewModel.checkingEditingTime(recordViewModel.record, withDescription: false))
                            .foregroundColor(Color.white)
                            .font(.callout)
                            .padding(.trailing, 5)
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
                            .padding(.top, -20)
                    )
                    
                }
                
                Text(recordViewModel.record.title.uppercased())
                    .foregroundColor(.primary)
                    .font(.caption)
                    .lineLimit(1)
                    .padding(.leading, 3)
                    .padding(.trailing, 2)
                    .padding(.bottom, 4)
            }
            .background(Color.white)
            .cornerRadius(5)
        }
        .padding(.leading, 15)
        .onTapGesture {
            self.showRecordPage = true
        }
        .frame(width: 200, height:  185)
        .sheet(isPresented: self.$showRecordPage) {
            RecordPageView(recordListViewModel: recordListViewModel, recordViewModel: recordViewModel, userNameRecord: userNameRecord)
        }
    }
}


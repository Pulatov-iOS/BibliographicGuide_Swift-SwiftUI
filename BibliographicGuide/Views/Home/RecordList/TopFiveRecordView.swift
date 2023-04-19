//
//  TopFiveRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 18.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TopFiveRecordView: View {
    
    var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    var userNameRecord: String
    @State private var showRecordPage: Bool = false
    @State private var imageUrl = URL(string: "")
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottom) {
                VStack{
                    WebImage(url: imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .scaledToFit()
                .onAppear{
                    recordListViewModel.getImageUrl(pathImage: "ImageTitle", idImage: recordViewModel.record.id ?? ""){ (verified, status) in
                        if !verified  {
                            imageUrl = status
                        }
                        else{
                            print(status)
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
                    Spacer()
                    
                    Text(recordListViewModel.checkingEditingTime(recordViewModel.record.datesChange.last ?? Date())) // может быть ошибка
                        .foregroundColor(Color.white)
                        .font(.callout)
                        .padding(.trailing, 5)
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
                        .padding(.top, -20)
                )
                
            }
            .cornerRadius(5)
            
            Text(recordViewModel.record.title)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
        .onTapGesture {
            self.showRecordPage = true
        }
        .frame(minHeight:  200, maxHeight: .infinity)
        .sheet(isPresented: self.$showRecordPage) {
            RecordPageView(recordListViewModel: recordListViewModel, recordViewModel: recordViewModel, userNameRecord: userNameRecord)
        }
    }
}

//struct TopFiveRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopFiveRecordView()
//    }
//}

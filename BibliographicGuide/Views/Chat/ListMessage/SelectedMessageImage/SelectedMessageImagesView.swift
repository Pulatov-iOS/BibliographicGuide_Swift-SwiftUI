//
//  MessageImageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 8.05.23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct SelectedMessageImagesView: View {
    
    @Binding var imagesPhotosPicker: [PhotosPickerItem]
    @Binding var imagesImage: [ImageModel]
    @Binding var imagesData: [Data]
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(imagesImage) { image in
                        SelectedMessageImageView(image: image, imagesPhotosPicker: $imagesPhotosPicker, imagesData: $imagesData)
                    }
                }
                .frame(height: 94)
            }
        }
        .padding(7)
        .frame(height: 94)
        .background(Color(UIColor.init(hex: "#f7f7f7") ?? .white))
        
    }
}




//
//  MessageImageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 8.05.23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct MessageImagesView: View {
    
    @Binding var imagesPhotosPicker: [PhotosPickerItem]
    @Binding var imagesImage: [ImageModel]
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(imagesImage) { image in
                        MessageImageView(image: image, imagesPhotosPicker: $imagesPhotosPicker)
                    }
                }
                .frame(height: 94)
            }
        }
        .padding(7)
        .frame(height: 94)
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        Divider()
    }
}

//struct MessageImagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageImagesView()
//    }
//}



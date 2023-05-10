//
//  ImageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 8.05.23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct SelectedMessageImageView: View {
    
    @State var image: ImageModel
    @Binding var imagesPhotosPicker: [PhotosPickerItem]
    @Binding var imagesData: [Data]
    
    var body: some View {
        ZStack{
            VStack{
                image.image
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 80, height: 80)
            }
            VStack{
                HStack{
                    Spacer()
                    Button{
                        if(imagesPhotosPicker.count > 0 && imagesPhotosPicker.count > image.idInt){
                            imagesPhotosPicker.remove(at: image.idInt)
                            imagesData.remove(at: image.idInt)
                        }
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color.gray)
                            .background(Color.white)
                            .cornerRadius(9)
                    }
                    .padding(6)
                }
            Spacer()
            }
            .frame(width: 80, height: 80)
        }
    }
}

//struct SelectedMessageImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedMessageImageView()
//    }
//}

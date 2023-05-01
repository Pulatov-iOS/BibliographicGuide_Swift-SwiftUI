//
//  KeywordSearchBarView.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.04.23.
//

import SwiftUI

struct KeywordSearchBarView: View {
    var body: some View {
        VStack{
            VStack{
                Text("2")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            .background(Color.red)
            .cornerRadius(10)
        }
        .padding(.leading, 10)
    }
}

struct KeywordSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSearchBarView()
    }
}

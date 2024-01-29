//
//  KeywordsSelectionSearchView.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.05.23.
//

import SwiftUI

struct KeywordsSelectionSearchView: View {
    
    @State var createRecordViewModel: CreateRecordViewModel
    
    @State var textSearch = ""
    @State var isSearching = false
    
    @Binding var countKeywordsSelected: Int
    @State var horizontalKeywords: [[Keyword]] = []
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    SearchBarCreateView(textSearch: $textSearch, isSearching: $isSearching)
                        .padding(.top, 15)
                    Spacer()
                }
                
                VStack{
                    ScrollView(.vertical, showsIndicators: false, content: {
                        ForEach(0..<horizontalKeywords.count, id: \.self){ id in
                            
                            HStack{
                                ForEach(horizontalKeywords[id]){ keyword in
                                    KeywordSelectionView(createRecordViewModel: $createRecordViewModel, keyword: keyword, countKeywordsSelected: $countKeywordsSelected)
                                }
                            }
                        }
                    })
                }
                .padding(.top, 65)
            }
        }
        .onAppear(){
            horizontalKeywords = getArrayHorizontalKeywords(createRecordViewModel.keywords, CGFloat(20), CGFloat(35))
        }
        .onChange(of: countKeywordsSelected){ value in
            if(textSearch == ""){
                horizontalKeywords = getArrayHorizontalKeywords(createRecordViewModel.keywords, CGFloat(20), CGFloat(35))
            }
        }
        .onChange(of: textSearch){ value in
            createRecordViewModel.fetchKeywordsSearch(SearchString: textSearch)
            horizontalKeywords = getArrayHorizontalKeywords(createRecordViewModel.searchKeywords, CGFloat(20), CGFloat(35))
        }
    }
}

func widthKeyword(_ keywordName: String) -> CGFloat {
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16)
    ]
    let attributedText = NSAttributedString(string: keywordName, attributes: attributes)
    let constraintBox = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
    return rect.size.width
}

func getArrayHorizontalKeywords(_ keywords: [Keyword],_ marginsWidth: CGFloat,_ marginsWidthBetweenWords: CGFloat) -> [[Keyword]] {
    var width = marginsWidth
    var horizontalKeywords: [Keyword] = []
    var verticalHorizontalKeywords: [[Keyword]] = []
    
    for keyword in keywords {
        width = width + widthKeyword(keyword.name) + marginsWidthBetweenWords
        if(width < UIScreen.screenWidth){
            horizontalKeywords.append(keyword)
            if(keywords.last?.id == keyword.id){
                verticalHorizontalKeywords.append(horizontalKeywords)
            }
        }
        else{
            if(horizontalKeywords.count > 0){
                verticalHorizontalKeywords.append(horizontalKeywords)
            }
            horizontalKeywords.removeAll()
            horizontalKeywords.append(keyword)
            width = widthKeyword(keyword.name) + marginsWidth
            if(keywords.last?.id == keyword.id){
                verticalHorizontalKeywords.append(horizontalKeywords)
            }
        }
    }
    return verticalHorizontalKeywords
}

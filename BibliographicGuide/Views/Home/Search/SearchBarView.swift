//
//  SearchBarView.swift
//  BibliographicGuide
//
//  Created by Alexander on 18.04.23.
//

import SwiftUI

struct SearchBarView: View {
    
    @EnvironmentObject var recordListViewModel: RecordListViewModel

    @Binding var textSearch: String
    @Binding var isSearching: Bool
    
    var body: some View {
        
        HStack {
            TextField("Search ...", text: $textSearch)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isSearching {
                            Button(action: {
                                self.textSearch = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isSearching = true
                }

            if isSearching {
                Button(action: {
                    self.isSearching = false
                    self.textSearch = ""
             
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .onChange(of: textSearch){ newValue in
            recordListViewModel.fetchRecordsSearch(SearchString: textSearch)
        }
    }
}

//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView()
//    }
//}

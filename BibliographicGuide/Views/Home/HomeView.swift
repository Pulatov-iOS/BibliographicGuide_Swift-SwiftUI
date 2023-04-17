//
//  HomeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView{
            VStack{
                RecordListView(recordListViewModel: RecordListViewModel())
            }
        }
      
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(recordListViewModel: RecordListViewModel())
//    }
//}

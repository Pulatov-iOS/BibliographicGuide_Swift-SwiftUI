//
//  HomeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var recordListViewModel: RecordListViewModel
    
    var body: some View {
        VStack{
            List(recordListViewModel.records){ record in
                Text(record.title)
            }
            Button("New"){
                let rec = Record(idUsers: "dsedse", datesChange: "2023", title: "title", year: 2020, keywords: "Math", authors: "Pulatov", linkDoi: "http", linkWebsite: "http", journalName: "BSTU", journalNumber: "34", pageNumbers: "100", description: "none", idPhotoTitle: "dc", idPhotoRecord: "sx", idPdfRecord: "cc")
                recordListViewModel.addRecord(rec)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(recordListViewModel: RecordListViewModel())
    }
}

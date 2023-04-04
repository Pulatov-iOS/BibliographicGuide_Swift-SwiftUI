//
//  RecordDescriptionView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct RecordDescriptionView: View {
    
    @ObservedObject var recordDescriptionViewModel: RecordDescriptionViewModel
    var record: Record
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 12) {
                HStack(alignment: .center, spacing: 2, content: {
                    Image(systemName: "person.2")
                    Text("Ник: \(record.idUsers[0])")
                })
                HStack(alignment: .center, spacing: 2, content: {
                    Image(systemName: "pencil.line")
                    Text("Редакт: \(recordDescriptionViewModel.checkingEditingTime(record.datesChange))")
                })
            }
            HStack(alignment: .center, spacing: 2, content: {
                Image(systemName: "clock")
                Text("Дата создания: \(recordDescriptionViewModel.checkingCreatingTime(record.datesChange))")
            })
        }.padding(.leading, 7)
        .font(.footnote)
        .foregroundColor(Color.gray)
    }
}

struct RecordDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDescriptionView(recordDescriptionViewModel: RecordDescriptionViewModel(), record: Record(idUsers: [""], datesChange: Date(), title: "", year: 1, keywords: "", authors: "", linkDoi: "", linkWebsite: "", journalName: "", journalNumber: "", pageNumbers: "", description: "", idPhotoTitle: "", idPhotoRecord: "", idPdfRecord: ""))
    }
}

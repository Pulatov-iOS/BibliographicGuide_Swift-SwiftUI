//
//  RecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct RecordView: View {
    
    var recordViewModel: RecordViewModel
    
    var body: some View {
        Text(recordViewModel.record.title + recordViewModel.record.authors)
    }
}

//struct RecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordView()
//    }
//}

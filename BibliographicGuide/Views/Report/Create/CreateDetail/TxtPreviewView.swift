//
//  TxtPreviewView.swift
//  BibliographicGuide
//
//  Created by Alexander on 26.06.23.
//

import SwiftUI

struct TxtPreviewView: View {
    
    var recordsIncludedReport: [Record]
    
    var body: some View {
        ForEach(recordsIncludedReport) { report in
            Text(report.title)
        }
    }
}

//struct TxtPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        TxtPreviewView()
//    }
//}

//
//  InformationDOI.swift
//  BibliographicGuide
//
//  Created by Alexander on 19.04.23.
//

import SwiftUI

class InformationDOI{
    
    var title = ""
    var year = ""
    var journalName = ""
    var jornalNumber = ""
    var pageNumbers = ""
    var linkDoi = ""
    var linkWebsite = ""
    var authors = ""
    var error = false
    
    private var responseDOIApi = ""
    private var resResponseDOIApi = ""
 
    func getRecordDOI(doi: String) {
        let newDoi = doi.lowercased()
        
        let ruCharacters = "йцукенгшщзхъфывапролджэёячсмитьбю"
        for character in ruCharacters {
            print(character)
            if newDoi.contains(character) {
                error = true
            }
        }
 
        if(error == false){
            //        var request = URLRequest(url: URL(string: "https://api.crossref.org/v1/works/10.36773/1818-1112-2022-127-1-32-36/transform/application/vnd.crossref.unixref+xml")!)
            var request = URLRequest(url: URL(string: "https://api.crossref.org/v1/works/" + newDoi + "/transform/application/vnd.crossref.unixref+xml")!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["AuthToken": "null"]
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                self.responseDOIApi = (String(decoding: data!, as: UTF8.self))
            }
            task.resume()
        }
        else{
            responseDOIApi = ""
        }
    }
    
    func getObject(doi: String, completion: @escaping (Bool, String)->Void) {
        
        getRecordDOI(doi: doi)
        
        if(error == false){
            while(true){
                if(responseDOIApi != ""){
                    resResponseDOIApi = responseDOIApi
                    
                    let newTitle = responseDOIApi.components(separatedBy: "<title>").last?.components(separatedBy: "</title>").first
                    title = newTitle ?? ""
                    
                    
                    var endPosJournalArticle = 0
                    var newResponseDOIApiJournalArticle = responseDOIApi
                    if let rangeJournalArticle = newResponseDOIApiJournalArticle.range(of: "</person_name>") {
                        endPosJournalArticle = newResponseDOIApiJournalArticle.distance(from: newResponseDOIApiJournalArticle.startIndex, to: rangeJournalArticle.upperBound)
                    }
                    let rangeJournalArticle2 = newResponseDOIApiJournalArticle.index(newResponseDOIApiJournalArticle.startIndex, offsetBy: endPosJournalArticle)..<newResponseDOIApiJournalArticle.endIndex
                    newResponseDOIApiJournalArticle.removeSubrange(rangeJournalArticle2)
                    let newYear = newResponseDOIApiJournalArticle.components(separatedBy: "<year>").last?.components(separatedBy: "</year>").first
                    year = newYear ?? ""
                    
                    let newJournalName = responseDOIApi.components(separatedBy: "<full_title>").last?.components(separatedBy: "</full_title>").first
                    journalName = newJournalName ?? ""
                    
                    let newJournalNumber = responseDOIApi.components(separatedBy: "<issue>").last?.components(separatedBy: "</issue>").first
                    jornalNumber = newJournalNumber ?? ""
                    
                    let newPageNumberFirst = responseDOIApi.components(separatedBy: "<first_page>").last?.components(separatedBy: "</first_page>").first
                    let newPageNumberLast = responseDOIApi.components(separatedBy: "<last_page>").last?.components(separatedBy: "</last_page>").first
                    pageNumbers = (newPageNumberFirst ?? "") + " - " + (newPageNumberLast ?? "")
                    
                    let newLinkDoi = newResponseDOIApiJournalArticle.components(separatedBy: "<doi>").last?.components(separatedBy: "</doi>").first
                    linkDoi = newLinkDoi ?? ""
                    
                    let newLink = newResponseDOIApiJournalArticle.components(separatedBy: "<resource>").last?.components(separatedBy: "</resource>").first
                    linkWebsite = newLink ?? ""
                    
                    
                    
                    
                    let countAuthor = responseDOIApi.components(separatedBy: "<surname>").last?.components(separatedBy: "</surname>").count ?? 0
                    var item = 0;
                    var newResponseDOIApi = responseDOIApi
                    authors = ""
                    while(item < countAuthor){
                        if(item == 0){
                            let newAuthorSurname = newResponseDOIApi.components(separatedBy: "<surname>").last?.components(separatedBy: "</surname>").first
                            let newAuthorLastName = newResponseDOIApi.components(separatedBy: "<given_name>").last?.components(separatedBy: "</given_name>").first
                            authors = authors + (newAuthorSurname ?? "") + " " + (newAuthorLastName ?? "")
                            
                            
                            var endPos = 0
                            if let range = newResponseDOIApi.range(of: "</person_name>") {
                                endPos = newResponseDOIApi.distance(from: newResponseDOIApi.startIndex, to: range.upperBound)
                            }
                            let range2 = newResponseDOIApi.index(newResponseDOIApi.startIndex, offsetBy: endPos)..<newResponseDOIApi.endIndex
                            newResponseDOIApi.removeSubrange(range2)
                        }
                        else{
                            let newAuthorSurname = newResponseDOIApi.components(separatedBy: "<surname>").last?.components(separatedBy: "</surname>").first
                            let newAuthorLastName = newResponseDOIApi.components(separatedBy: "<given_name>").last?.components(separatedBy: "</given_name>").first
                            authors = authors + ", " + (newAuthorSurname ?? "") + " " + (newAuthorLastName ?? "")
                            
                            var endPos = 0
                            if let range = newResponseDOIApi.range(of: "</person_name>") {
                                endPos = newResponseDOIApi.distance(from: newResponseDOIApi.startIndex, to: range.upperBound)
                            }
                            let range2 = newResponseDOIApi.index(newResponseDOIApi.startIndex, offsetBy: endPos)..<newResponseDOIApi.endIndex
                            newResponseDOIApi.removeSubrange(range2)
                        }
                        
                        
                        item = item + 1
                    }
                    
                    break
                }
            }
        }
        
    
        if(resResponseDOIApi == "" || resResponseDOIApi == "Resource not found."){
            completion(false, "Error")
        }
        else{
            completion(true, "Ok")
        }
        resResponseDOIApi = ""
        responseDOIApi = ""
        error = false
    }
}

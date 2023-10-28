//
//  InformationDOI.swift
//  BibliographicGuide
//
//  Created by Alexander on 19.04.23.
//

import SwiftUI

final class InformationDOI {
    
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
            if newDoi.contains(character) {
                error = true
            }
        }
 
        if(error == false){
            //        var request = URLRequest(url: URL(string: "https://api.crossref.org/v1/works/10.36773/1818-1112-2022-127-1-32-36/transform/application/vnd.crossref.unixref+xml")!)
            var request = URLRequest(url: (URL(string: "https://api.crossref.org/v1/works/" + newDoi + "/transform/application/vnd.crossref.unixref+xml") ?? URL(string: "https://api.crossref.org"))!)
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
                    
                    var articleInformation = ""
                    if let index = responseDOIApi.indices(of: "</doi_data>").last    {
                        let substring = responseDOIApi[..<index]
                        articleInformation = String(substring)
                    }
                    
                    let newTitle = articleInformation.components(separatedBy: "<title>").last?.components(separatedBy: "</title>").first
                    title = isMistake(str: newTitle ?? "")
                    
                    let newYear = articleInformation.components(separatedBy: "<year>").last?.components(separatedBy: "</year>").first
                    year = isMistake(str: newYear ?? "")
                    
                    let newJournalName = articleInformation.components(separatedBy: "<full_title>").last?.components(separatedBy: "</full_title>").first
                    journalName = isMistake(str: newJournalName ?? "")
                    
                    let newJournalNumber = articleInformation.components(separatedBy: "<issue>").last?.components(separatedBy: "</issue>").first
                    jornalNumber = isMistake(str: newJournalNumber ?? "")
                    
                    let newPageNumberFirst = articleInformation.components(separatedBy: "<first_page>").last?.components(separatedBy: "</first_page>").first
                    let newPageNumberLast = articleInformation.components(separatedBy: "<last_page>").last?.components(separatedBy: "</last_page>").first
                    pageNumbers = isMistake(str: (newPageNumberFirst ?? "") + " - " + (newPageNumberLast ?? ""))
                    
                    let newLinkDoi = articleInformation.components(separatedBy: "<doi>").last?.components(separatedBy: "</doi>").first
                    linkDoi = isMistake(str: newLinkDoi ?? "")
                    
                    var newLink = articleInformation.components(separatedBy: "<resource").last?.components(separatedBy: "/resource>").first
                    newLink = newLink?.components(separatedBy: ">").last?.components(separatedBy: "<").first
                    linkWebsite = isMistake(str: newLink ?? "")
                    
                    var countAuthor = 0
                    countAuthor = responseDOIApi.indices(of: "<person_name").count
                    var item = 0;
                    var newResponseDOIApi = responseDOIApi
                    authors = ""
                    while(item < countAuthor){
                        if(item == 0){
                            let newAuthorSurname = newResponseDOIApi.components(separatedBy: "<surname>").last?.components(separatedBy: "</surname>").first
                            let newAuthorLastName = newResponseDOIApi.components(separatedBy: "<given_name>").last?.components(separatedBy: "</given_name>").first
                            authors = authors + (newAuthorSurname ?? "") + " " + (newAuthorLastName ?? "")
                            
                            if let indexFirst = newResponseDOIApi.indices(of: "<person_name").first {
                                if let indexLast = newResponseDOIApi.indices(of: "<person_name").last {
                                    let substring = newResponseDOIApi[indexFirst..<indexLast]
                                    newResponseDOIApi = String(substring)
                                }
                            }
                        }
                        else{
                            let newAuthorSurname = newResponseDOIApi.components(separatedBy: "<surname>").last?.components(separatedBy: "</surname>").first
                            let newAuthorLastName = newResponseDOIApi.components(separatedBy: "<given_name>").last?.components(separatedBy: "</given_name>").first
                            authors = (newAuthorSurname ?? "") + " " + (newAuthorLastName ?? "") + ", " + authors
                            
                            if let indexFirst = newResponseDOIApi.indices(of: "<person_name").first {
                                if let indexLast = newResponseDOIApi.indices(of: "<person_name").last {
                                    let substring = newResponseDOIApi[indexFirst..<indexLast]
                                    newResponseDOIApi = String(substring)
                                }
                            }
                        }
                        
                        item = item + 1
                    }
                    
                    authors = isMistake(str: authors)
                    
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
    
    func isMistake(str: String) -> String {
        if str.contains("<") {
            return ""
        }
        if str.contains(">") {
            return ""
        }
        return str
    }
}

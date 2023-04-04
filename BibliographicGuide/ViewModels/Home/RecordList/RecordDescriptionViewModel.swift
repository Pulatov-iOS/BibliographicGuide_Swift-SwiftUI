//
//  RecordDescriptionViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation

final class RecordDescriptionViewModel: ObservableObject {
    
    
    func checkingCreatingTime(_ date: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        // Convert Date to String
        let newDate = dateFormatter.string(from: date)
        return newDate
        
    }

    func checkingEditingTime(_ time: Date) -> String {

        var timeEditing: String
        
//        if(time == nil){   //// если редакт нет!!!!!
//            timeEditing = "отсутствует"
//        }
        
        
        var time = time.millisecondsSince1970
        let nowTime = Date().millisecondsSince1970
        time = nowTime - time
        if(time < 60){
                let seconds = time
                timeEditing = String(seconds) + " сек. назад"
            }
        else{
            if(time > 59 && time < 3600){
                let minutes = (time / 60) % 60
                timeEditing = String(minutes) + " мин. назад"
            }
            else{
                if(time > 3599 && time < 86400){
                    let hours = (time / 3600) % 60
                    timeEditing = String(hours) + " ч. назад"
                }
                else{
                    let day = (time / 86400) % 30
                    timeEditing = String(day) + " дн. назад"
                }
            }

        }
        return timeEditing
    }
    
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

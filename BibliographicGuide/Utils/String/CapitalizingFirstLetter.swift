//
//  capitalizingFirstLetter.swift
//  BibliographicGuide
//
//  Created by Alexander on 27.05.23.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

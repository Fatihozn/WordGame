//
//  String+ext.swift
//  WordGame
//
//  Created by Fatih Özen on 17.04.2023.
//

import Foundation

extension String {
    func toLowerCasedTurkish() -> String{
        let dict: [Substring: Substring] = ["A": "a", "B": "b", "C": "c", "Ç": "ç", "D": "d", "E": "e", "F": "f", "G": "g", "Ğ": "ğ", "H": "h", "I": "ı", "İ": "i", "J": "j", "K": "k", "L": "l", "M": "m", "N": "n", "O": "o", "Ö": "ö", "P": "p", "R": "r", "S": "s", "Ş": "ş", "T": "t", "U": "u", "Ü": "ü", "V": "v", "Y": "y", "Z": "z"]
        
        var splitedText = self.split(separator: "")
        
        for (i, char) in splitedText.enumerated() {
            if dict[char] == nil {
                splitedText[i] = char
            } else {
                splitedText[i] = dict[char] ?? ""
            }
        }
        let newText = splitedText.joined()
        
        return newText
    }
}

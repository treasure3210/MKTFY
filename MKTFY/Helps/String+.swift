//
//  String+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/16.
//

import Foundation

extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character, addCountryCodePrefix: Bool) -> String {
        var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if addCountryCodePrefix && !pureNumber.hasPrefix("1") {
            pureNumber = "1" + pureNumber
        }
        
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        
        return pureNumber
    }
}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

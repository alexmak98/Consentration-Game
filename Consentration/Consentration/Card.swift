//
//  Card.swift
//  Consentration
//
//  Created by Alex Makovetskiy on 24.08.2021.
//

import Foundation

struct Card {
    var isFaseUp = false
    var isMatched = false
    var wasAlreadyChoosed = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func   getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}

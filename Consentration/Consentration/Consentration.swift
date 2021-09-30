//
//  Consentration.swift
//  Consentration
//
//  Created by Alex Makovetskiy on 24.08.2021.
//

import Foundation
import UIKit

class Consentration {
    
    var flipCount = 0
    var scoreCount = 0
    var cardsMatched = 0
    var indexOfOneAndOnlyMatchedCard: Int?
    
    let choicesArray = [["👻", "🎃", "🦇", "🍬", "💀", "🤖", "👾", "😈"],
        ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉","🥏"],
        ["🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔"],
        ["🇺🇦", "🇳🇫", "🇵🇲", "🇮🇲", "🇬🇵", "🇮🇴", "🇲🇴", "🇳🇵"],
        ["☢️", "♻️", "⚛️", "🚮", "📵", "💠", "🚾", "〽️"],
        ["🎞", "🧾", "💳", "🪤", "🕳", "🧫", "🪆", "🪄"]]
    let cardColors = [UIColor.black, UIColor.systemGreen, UIColor.systemBlue, UIColor.white, UIColor.lightGray, UIColor.darkGray]
    let backgroundColors = [UIColor.systemOrange, UIColor.lightGray, UIColor.black, UIColor.lightGray, UIColor.white, UIColor.lightGray];
    
    var cards = [Card]()

    var chosenArray = [String]()
    var chosenCardColor = UIColor()
    var chosenBackgroundColor = UIColor()
    
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchedIndex = indexOfOneAndOnlyMatchedCard, matchedIndex != index {
                // 2 cards choosed
                if cards[matchedIndex].identifier == cards[index].identifier {
                    // 2 cards matched
                    cardsMatched += 2
                    scoreCount += 2
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                } else {
                    // 2 cards not matched
                    if cards[index].wasAlreadyChoosed {
                        scoreCount -= 1
                    }
                    if cards[matchedIndex].wasAlreadyChoosed {
                        scoreCount -= 1
                    }
                    cards[index].wasAlreadyChoosed = true
                    cards[matchedIndex].wasAlreadyChoosed = true
                }
                cards[index].isFaseUp = true
                indexOfOneAndOnlyMatchedCard = nil
            } else {
                // 1 cards choosen
                for cardIndex in cards.indices {
                    cards[cardIndex].isFaseUp = false
                }
                cards[index].isFaseUp = true
                indexOfOneAndOnlyMatchedCard = index
            }
        }
    }
    
    init(numberOfPairsOFCards: Int) {
        let randomIndex = Int(arc4random_uniform(UInt32(choicesArray.count)))
        chosenArray = choicesArray[randomIndex]
        chosenCardColor = cardColors[randomIndex]
        chosenBackgroundColor = backgroundColors[randomIndex]
        for _ in 1...numberOfPairsOFCards {
            let card = Card()
            cards += [card, card]
        }
        var shuffledCards = [Card]()
        for _ in cards.indices {
            let secondRandomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            shuffledCards.append(cards.remove(at: secondRandomIndex))
        }
        cards = shuffledCards
    }
    
}

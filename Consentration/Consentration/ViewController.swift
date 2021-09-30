//
//  ViewController.swift
//  Consentration
//
//  Created by Alex Makovetskiy on 23.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let recordsArray = getRecordsArray() {
            print(recordsArray)
        } else {
            defaults.setValue([0.00, 0.00, 0.00, 0.00, 0.00], forKey: "Records")
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeFineLabel: UILabel!
    @IBOutlet weak var recordsLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    lazy var game = Consentration(numberOfPairsOFCards: (cardButtons.count + 1) / 2)
    
    var emoji = [Int:String]()
    var startingDate = Date()
    
    @IBAction func newGameButtonTouched(_ sender: UIButton) {
        startingDate = Date()
        game = Consentration(numberOfPairsOFCards: (cardButtons.count + 1) / 2)
        for index in cardButtons.indices {
            cardButtons[index].backgroundColor = game.chosenCardColor;
            
        }
        timeFineLabel.alpha = 0
        recordsLabel.alpha = 0
        flipCountLabel.textColor = game.chosenCardColor
        scoreLabel.textColor = game.chosenCardColor
        timeFineLabel.textColor = game.chosenCardColor
        recordsLabel.textColor = game.chosenCardColor
        view.backgroundColor = game.chosenBackgroundColor
        
        updateViewFromModel()
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("not in collection")
        }
    }

    func updateViewFromModel() {
        if game.cardsMatched == 16 {
            finalUpdate()
        } else {
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreLabel.text = "Score: \(game.scoreCount)"
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaseUp {
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : game.chosenCardColor
                }
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, game.chosenArray.count > 0 {
            let randomIndex = randomNumber(to: game.chosenArray.count)
            emoji[card.identifier] = game.chosenArray.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func randomNumber(to number: Int) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }
    
    func finalUpdate() {
        
        let score = Double(game.scoreCount)
        let timeFine = startingDate.distance(to: Date()) * 3 / 100
        let finalScore = score - timeFine
        let formattedFinalScore = String(format: "%.2f", finalScore)
        let formattedTimeFine = String(format: "%.2f", timeFine)
        checkIfRecordIsSet(score: finalScore)
        timeFineLabel.alpha = 1
        recordsLabel.alpha = 1
        timeFineLabel.text = "Time fine \(formattedTimeFine) sec"
        scoreLabel.text = "Score: \(formattedFinalScore)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
        var str = "R E C O R D S"
        if let recordsArray = getRecordsArray() {
            for i in recordsArray.indices {
                str += "\n\(i+1). \(String(format: "%.2f", recordsArray[i]))"
            }
        }
        print(str)
        recordsLabel.text = str
        
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaseUp {
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : game.chosenCardColor
            }
        }
    }
    
    func checkIfRecordIsSet(score: Double) {
        let defaults = UserDefaults.standard
        if var recordsArray = getRecordsArray() {
            var placeInRating: Int?
            for index in recordsArray.indices {
                if score > recordsArray[index] {
                    placeInRating = index
                    break
                }
            }
            if placeInRating != nil {
                recordsArray = shiftValuesToRightIn(recordsArray, fromIndex: placeInRating! + 1)
                recordsArray[placeInRating!] = score
                defaults.setValue(recordsArray, forKey: "Records")
            }
        }
    }
    
    func getRecordsArray() -> [Double]?{
        var array: [Double]?
        let defaults = UserDefaults.standard
        if let recordsArray = defaults.object(forKey: "Records") as? [Double] {
            array = recordsArray
        }
        return array
    }
    
    func shiftValuesToRightIn(_ array2: [Double], fromIndex startingIndex: Int) -> [Double] {
        // TODO - Shift Values in Array
        var array = array2
        var oldValue = array[startingIndex - 1]
        var newValue = array[startingIndex]
        for i in stride(from: startingIndex, to: array.count, by: 1) {
            newValue = array[i]
            array[i] = oldValue
            oldValue = newValue
        }
        return array
    }
}


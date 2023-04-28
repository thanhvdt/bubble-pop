//
//  Bubble.swift
//  BubblePop
//
//  Created by Than Vuong on 10/4/23.
//

import UIKit

class Bubble: UIButton {
    var score = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initColorAndScore()
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    //init color and score of bubbles based on probabilities
    func initColorAndScore() {
        let colorScoreProbabilities: [(color: UIColor, score: Int, probability: Int)] = [
            (#colorLiteral(red: 1, green: 0, blue: 0.08118886501, alpha: 1), 1, 400),
            (#colorLiteral(red: 1, green: 0.538099885, blue: 1, alpha: 1), 2, 300),
            (#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), 5, 150),
            (#colorLiteral(red: 0, green: 0.3725490196, blue: 1, alpha: 1), 8, 100),
            (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), 10, 49)
        ]
        
        var weightedArray: [(color: UIColor, score: Int)] = []
        
        //adding element to a weighted array to create random probabilities
        for (color, score, probability) in colorScoreProbabilities {
            for _ in 0..<probability {
                weightedArray.append((color, score))
            }
        }
        
        //select a random color bubble from the weighted array
        if let (selectedColor, selectedScore) = weightedArray.randomElement() {
                self.backgroundColor = selectedColor
                self.score = selectedScore
            } else {
                print("Error: Couldn't select a random color and score.")
            }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //get current score of bubble
    func getScore() -> Int {
        return self.score
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
}

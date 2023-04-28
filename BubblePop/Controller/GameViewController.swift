//
//  GameViewController.swift
//  BubblePop
//
//  Created by Thanh Vuong on 10/4/23.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameDetailStackView: UIStackView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var name: String?
    var remainingTime = 60
    var timer = Timer() //game time
    var score: Double = 0
    var highScore = 0 //initial highscore
    var maxNoBubble = 15 //default max number of bubbles
    var currentBubbles = [Bubble]() //arr of bubbles currently on screen
    var noCurrentBubbles = 0 //number of current bubbles
    var colorOfPreviousBubblePressed: UIColor?
    var countDownTimer = Timer() //pre-game countdown time
    var countDownTime = 3
    var soundPlayer: AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDetailStackView.backgroundColor = UIColor(red: 0.39, green: 0.25, blue: 0.65, alpha: 0.7)
        countDownLabel.text = String(countDownTime)
        remainingTimeLabel.text = String(remainingTime)
        scoreLabel.text = String(Int(score))
        setHighScore()
        bubbleSoundEffect()
        
        //set countdown timer
        self.navigationItem.setHidesBackButton(true, animated: true)
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { countDownTimer in
            self.countdown()
        }
        
    }
    
    //countdown before game starts
    @objc func countdown() {
        countDownTime -= 1
        countDownLabel.text = String(countDownTime)
        if countDownTime == 0 {
            countDownLabel.text = "Start!"
            startGameTimer()
        }
    }

    //start counting down game time
    func startGameTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.countDownTime == -1{
                self.countDownLabel.isHidden = true
                self.countDownTimer.invalidate()
            }
            self.deleteBubble()
            self.generateBubble()
            self.counting()
        }
    }

    
    @objc func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        if remainingTime == 0 {
            timer.invalidate()
            // show HighScore Screen
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
            vc.writeHighScore(name!, Int(score))
        }
    }
    
    //create on-creen container of bubbles
    @objc func generateBubbleContainer(bubble: Bubble,x xPosition: Int, y yPosition: Int) {
        bubble.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        bubble.layer.cornerRadius = 0.5 * bubble.bounds.size.width
    }
    
    //check if bubbles intersect
    func checkIntersect(_ newBubble: Bubble) -> Bool {
        for bubble in currentBubbles {
            if newBubble.frame.intersects(bubble.frame) { return true }
        }
        return false
    }
    
    //create bubbles currently on screen
    @objc func generateBubble() {
        //randomize max number of bubbles
        let noBubbles = Int.random(in: 1...maxNoBubble)
        let frame = view.frame

        for  _ in 1...noBubbles {
            //define possible x, y coordinates of bubbles (based on size of bubble)
            let yPosition = Int.random(in: Int(gameDetailStackView.frame.origin.y) + 75...Int(frame.maxY) - 150)
            let xPosition = Int.random(in: 25...Int(frame.maxX) - 75)
            
            //create more bubbles if current bubbles < max number of bubbles
            if noCurrentBubbles < maxNoBubble {
                let bubble = Bubble()
                generateBubbleContainer(bubble: bubble, x: xPosition, y: yPosition)
                //check if bubbles intersect
                if !checkIntersect(bubble) {
                    currentBubbles.append(bubble)
                    bubble.animation()
                    bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                    self.view.addSubview(bubble)
                    noCurrentBubbles += 1
                }
            }
        }
    }
    
    //delete bubbles in game time
    func deleteBubble() {
        let bubblesToDelete = Int.random(in: 0...noCurrentBubbles)
        
        //delete random bubbles fewer than current bubbles displayed
        for _ in 0..<bubblesToDelete {
            if !currentBubbles.isEmpty {
                let randomIndex = Int.random(in: 0..<currentBubbles.count)
                let bubbleToRemove = currentBubbles[randomIndex]
                
                bubbleToRemove.flash()
                bubbleToRemove.removeFromSuperview()
                currentBubbles.remove(at: randomIndex)
                noCurrentBubbles -= 1
            }
        }
    }

    //handle bubble pressed
    @IBAction func bubblePressed(_ sender: Bubble) {
        soundPlayer?.play()
        // calculate score when bubble pressed
        score = (sender.backgroundColor == colorOfPreviousBubblePressed) ? score + Double(sender.getScore()) * 1.5 : score + Double(sender.getScore())
        scoreLabel.text = String(Int(score)) //update score
        noCurrentBubbles -= 1
        colorOfPreviousBubblePressed = sender.backgroundColor! //save background color of pressed bubble to handle calculating score
        if let index = currentBubbles.firstIndex(of: sender){
            currentBubbles.remove(at: index)
        }
        sender.flash()
        sender.removeFromSuperview() //remove bubble pressed
        updateHighScore()
    }
    
    //set high score to display in high score view
    func setHighScore() {
        let vc = HighScoreViewController()
        highScore = vc.getTopScore()
        highScoreLabel.text = String(highScore)
    }
    
    //update high score when current score is higher
    func updateHighScore(){
        if Int(score) > highScore {
            highScoreLabel.text = String(Int(score))
        }
    }
    
    //set bubble sound effect
    func bubbleSoundEffect(){
        let soundPath = Bundle.main.path(forResource: "pop", ofType: "mp3")!
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
            soundPlayer?.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
}

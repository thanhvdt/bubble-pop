//
//  SettingViewController.swift
//  BubblePop
//
//  Created by Thanh Vuong on 10/4/23.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gameTimeSlider: UISlider!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var maxBubbleSlider: UISlider!
    @IBOutlet weak var maxBubbleLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet weak var noneInputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTimeLabel.text = String(Int(gameTimeSlider.value)) + " seconds"
        maxBubbleLabel.text = String(Int(maxBubbleSlider.value))
        playButton.isEnabled = false
        playButton.backgroundColor = UIColor(red: 0.39, green: 0.25, blue: 0.65, alpha: 0.7)
        playButton.setTitleColor(.white, for: .normal)
    }
    
    //enable play button when user enters name, disable when not
    @IBAction func onNameTextFieldChange(_ sender: Any) {
        if nameTextField.text == "" {
            playButton.isEnabled = false
            playButton.alpha = 0.7
            noneInputLabel.text = "Please put you name before start"
        }
        else{
            playButton.isEnabled = true
            playButton.alpha = 1
            noneInputLabel.text = ""
        }
    }
    
    //update displayed number when slider changes
    @IBAction func onGameTimeSliderChange(_ sender: UISlider) {
        gameTimeLabel.text = String(Int(gameTimeSlider.value)) + " seconds"
    }
    
    //update displayed number when slider changes
    @IBAction func onMaxBubbleSliderChange(_ sender: Any) {
        maxBubbleLabel.text = String(Int(maxBubbleSlider.value))
    }
    
    //pass data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController
            VC.name = nameTextField.text!
            VC.remainingTime = Int(gameTimeSlider.value)
            VC.maxNoBubble = Int(maxBubbleSlider.value)
        }
    }
  
}

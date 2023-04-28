//
//  HighScoreViewController.swift
//  BubblePop
//
//  Created by Thanh Vuong on 10/4/23.
//

import UIKit

struct GameScore: Codable {
    var name: String
    var score: Int
}

let KEY_HIGH_SCORE = "highScore"

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTableView: UITableView!
    var highScore:[GameScore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScore.sort {$0.score > $1.score}

        self.highScore = readHighScore()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func returnMainPage(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func writeHighScore(_ newName: String, _ newScore: Int) {
        let defaults = UserDefaults.standard
        var updatedHighScoreFromGame: [GameScore] = readHighScore()
        updatedHighScoreFromGame.append(GameScore(name: newName, score: newScore))
        //show 3 highest scores
        if updatedHighScoreFromGame.count > 3 {
            updatedHighScoreFromGame.sort {$0.score > $1.score}
            updatedHighScoreFromGame.removeLast()
        }
        
        defaults.set(try? PropertyListEncoder().encode(updatedHighScoreFromGame), forKey: KEY_HIGH_SCORE)
    }
    
    // read high score from user default value
    func readHighScore() -> [GameScore] {
        let defaults = UserDefaults.standard
        
        if let savedArrayData = defaults.value(forKey: KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData){
                return array
            } else {
                return []
            }
        } else {
                return []
            }
    }
    
    
    //get the highest score to show in gameview
    func getTopScore() -> Int {
        let highScores = readHighScore()
        guard !highScores.isEmpty else {
            return 0
        }
        return highScores.max(by: { $0.score < $1.score })!.score
    }


}

extension HighScoreViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension HighScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScore.count
    }
    // setting of cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        let score = highScore[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "\(score.score)"
        return cell
    }
}

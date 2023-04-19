//
//  ResultVC.swift
//  WordGame
//
//  Created by Fatih Özen on 2.04.2023.
//

import UIKit

class ResultVC: UIViewController {
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let d = UserDefaults.standard
        
        let currentScore: Int = d.integer(forKey: "currentScore")
        let highScore: Int = d.integer(forKey: "highScore")
        
        lastTenScoreSet(newScore: currentScore)
        
        currentScoreLabel.text = String(currentScore)
        
        if currentScore > highScore {
            d.set(currentScore, forKey: "highScore")
            highScoreLabel.text = String(currentScore)
        } else {
            highScoreLabel.text = String(highScore)
        }
        
    }
    
    
    @IBAction func tryAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func lastTenScoreSet(newScore: Int) {
        
        let d = UserDefaults.standard
        
        var lastTenScore: [Int] = d.array(forKey: "lastTenScore") as? [Int] ?? [Int]()
        
        lastTenScore.insert(newScore, at: 0)
        
        if lastTenScore.count > 10 {
            lastTenScore.removeLast()
        }
        
        d.set(lastTenScore, forKey: "lastTenScore")
        
    }
}

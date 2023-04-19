//
//  AnaSayfa.swift
//  WordGame
//
//  Created by Fatih Özen on 2.04.2023.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class MainVC: UIViewController {

    @IBOutlet weak var lastTenScoreTableView: UITableView!
    @IBOutlet weak var HighScoreLabel: UILabel!
    
    var lastTenScore: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastTenScoreTableView.delegate = self
        lastTenScoreTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let d = UserDefaults.standard
        
        lastTenScore = d.array(forKey: "lastTenScore") as? [Int]
        
        DispatchQueue.main.async {
            self.lastTenScoreTableView.reloadData()
        }
        
        let highScore = d.integer(forKey: "highScore")
        HighScoreLabel.text = String(highScore)
        
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lastTenScore?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lastTenScoreTableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = "Score : \(String(describing: lastTenScore?[indexPath.row] ?? 0))"
        
        return cell
    }
    
    
}

//
//  ResultVC.swift
//  WordGame
//
//  Created by Fatih Özen on 2.04.2023.
//

import UIKit

class ResultVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tryAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

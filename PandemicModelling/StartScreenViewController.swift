//
//  StartScreenViewController.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 07/06/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.87, blue: 0.91, alpha: 1)
    }
    //The only button on the screen opens the main application.
    @IBAction func continueButton(_ sender: Any) {
        performSegue(withIdentifier: "continue", sender: self)
    }
    
   

}

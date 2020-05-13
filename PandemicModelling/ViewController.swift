//
//  ViewController.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 11/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var aspects = Aspects()
    var modeller = Modeller()
    
    @IBOutlet var susceptibleLabel: UILabel!
    
    @IBOutlet var infectedLabel: UILabel!
    
    @IBOutlet var removedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func simulation() {
        modeller.r = aspects.r0
        while modeller.infected != 0 {
            let tuple = modeller.simulate(data: aspects)
            susceptibleLabel.text = "Susceptible: \(tuple.0)"
            infectedLabel.text = "Infected: \(tuple.1)"
            removedLabel.text = "Removed: \(tuple.2)"
        }
    }
    
    @IBAction func simulateButton(_ sender: Any) {
        simulation()
    }
}


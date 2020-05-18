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
        susceptibleLabel.text = "Susceptible: nil"
        infectedLabel.text = "Infected: nil"
        removedLabel.text = "Removed: nil"
        
        // Do any additional setup after loading the view.
    }
    
    func simulation() {
        modeller.r = aspects.r0
        modeller.susceptible = (aspects.population - 1)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.modeller.infected == 0 {
                timer.invalidate()
            }
            let tuple = self.modeller.simulate(data: self.aspects)
            self.susceptibleLabel.text = "Susceptible: \(tuple.0)"
            self.infectedLabel.text = "Infected: \(tuple.1)"
            self.removedLabel.text = "Removed: \(tuple.2)"
        }
        
    }
    
    @IBAction func simulateButton(_ sender: Any) {
        simulation()
    }
}


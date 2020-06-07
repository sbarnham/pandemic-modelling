//
//  ExampleVirusViewController.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 07/06/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import UIKit

class ExampleVirusViewController: UIViewController {
    
    
    @IBOutlet var covid19Button: UIButton!
    @IBOutlet var ebolaButton: UIButton!
    @IBOutlet var swineFluButton: UIButton!
    @IBOutlet var spanishFluButton: UIButton!
    @IBOutlet var measlesButton: UIButton!
    @IBOutlet var ukButton: UIButton!
    @IBOutlet var usButton: UIButton!
    @IBOutlet var chinaButton: UIButton!
    @IBOutlet var russiaButton: UIButton!
    @IBOutlet var worldButton: UIButton!
    
    //Make sure all buttons are enabled.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.87, blue: 0.91, alpha: 1)
        turnAllVirusButtonsOn()
        turnAllPopulationButtonsOn()
        // Do any additional setup after loading the view.
    }
    
    
    func turnAllVirusButtonsOn() {
        covid19Button.isEnabled = true
        ebolaButton.isEnabled = true
        swineFluButton.isEnabled = true
        spanishFluButton.isEnabled = true
        measlesButton.isEnabled = true
    }
    
    func turnAllPopulationButtonsOn() {
        ukButton.isEnabled = true
        usButton.isEnabled = true
        chinaButton.isEnabled = true
        russiaButton.isEnabled = true
        worldButton.isEnabled = true
    }
    //Set data according to button pressed.
    fileprivate func virusAspectsSetup(mortalityRate: Double, r0: Double, button: UIButton) {
        Aspects.averageMortalityRate = mortalityRate
        Aspects.r0 = r0
        turnAllVirusButtonsOn()
        button.isEnabled = false //Disable the button pressed, to signal to the user what selectin has been made.
    }
    
    
    //Functions triggered when their respective buttons are pressed.
    @IBAction func covid19(_ sender: Any) {
        virusAspectsSetup(mortalityRate: 2, r0: 2.5, button: covid19Button)
    }
    
    
    @IBAction func ebola(_ sender: Any) {
        virusAspectsSetup(mortalityRate: 50, r0: 1.7, button: ebolaButton)
    }
    
    
    @IBAction func swineFlu(_ sender: Any) {
        virusAspectsSetup(mortalityRate: 0.02, r0: 1.5, button: swineFluButton)
    }
    
    
    @IBAction func spanishFlu(_ sender: Any) {
        virusAspectsSetup(mortalityRate: 2.5, r0: 2.3, button: spanishFluButton)
    }
    
    
    @IBAction func measles(_ sender: Any) {
        virusAspectsSetup(mortalityRate: 0.2, r0: 15, button: measlesButton)
    }
    
    func populationSetup(population: Int, button: UIButton) {
        Aspects.population = population
        turnAllPopulationButtonsOn()
        button.isEnabled = false
    }

    @IBAction func uk(_ sender: Any) {
        populationSetup(population: 66500000, button: ukButton)
    }
    
    @IBAction func us(_ sender: Any) {
        populationSetup(population: 328200000, button: usButton)
    }
    
    @IBAction func china(_ sender: Any) {
        populationSetup(population: 1393000000, button: chinaButton)
    }
    
    @IBAction func russia(_ sender: Any) {
        populationSetup(population: 144500000, button: russiaButton)
    }
    
    @IBAction func world(_ sender: Any) {
        populationSetup(population: 7800000000, button: worldButton)
    }

}

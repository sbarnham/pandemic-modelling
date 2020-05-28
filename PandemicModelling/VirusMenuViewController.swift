//
//  VirusMenuViewController.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 25/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import UIKit

class VirusMenuViewController: UIViewController, UITextFieldDelegate {
    
      
    @IBOutlet var populationField: UITextField!
    @IBOutlet var r0Field: UITextField!
    @IBOutlet var diseaseLengthField: UITextField!
    @IBOutlet var averageMortalityRateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populationField.placeholder = String(Aspects.population)
        r0Field.placeholder = String(Aspects.r0)
        diseaseLengthField.placeholder = String(Aspects.diseaseLength)
        averageMortalityRateField.placeholder = String(Aspects.averageMortalityRate)
        populationField.delegate = self
        r0Field.delegate = self
        diseaseLengthField.delegate = self
        averageMortalityRateField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveAspects()
    }
    
    
    func saveAspects() {
        Aspects.population = Int(populationField.text!) ?? 0
        Aspects.r0 = Double(r0Field.text!) ?? 0
        Aspects.diseaseLength = Int(diseaseLengthField.text!) ?? 0
        Aspects.averageMortalityRate = (Double(averageMortalityRateField.text!) ?? 0 / 100.0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.87, blue: 0.91, alpha: 1)
        populationField.placeholder = String(Aspects.population)
        r0Field.placeholder = String(Aspects.r0)
        diseaseLengthField.placeholder = String(Aspects.diseaseLength)
        averageMortalityRateField.placeholder = String(Aspects.averageMortalityRate * 100)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveAspects()
        if textField.text! != "" {
            checkForWarnings(textField: textField)
        }
    }
    
    
    func saveAspects() {
        Aspects.population = Int(populationField.text!) ?? 50000
        Aspects.r0 = Double(r0Field.text!) ?? 3
        Aspects.diseaseLength = Int(diseaseLengthField.text!) ?? 6
        Aspects.averageMortalityRate = ((Double(averageMortalityRateField.text!) ?? 2) / 100.0)
    }
    
    func checkForWarnings(textField: UITextField) {
        if Aspects.population <= 0 {
            errorAlert(error: "Population count is 0 or below.", severity: "S", textField: textField)
        }
        if Aspects.population <= 50 {
            errorAlert(error: "Population count is too low for a suitable simulation model.", severity: "M", textField: textField)
        }
        if Aspects.r0 < 1 {
            errorAlert(error: "This defined R0 does not create a pandemic.", severity: "S", textField: textField)
        }
        if Aspects.r0 > 18 {
            errorAlert(error: "This R0 is larger than any defined R0 of a virus. The simulation is likely to be unrealistic.", severity: "M", textField: textField)
        }
        if Aspects.averageMortalityRate > 1 || Aspects.averageMortalityRate < 0 {
            errorAlert(error: "Mortality rate is not between 0 and 100%.", severity: "S", textField: textField)
        }
    }
    
    func errorAlert(error: String, severity: String, textField: UITextField) {
        let alert = UIAlertController(title: "Incorrect/boundary input", message: "Please rectify the following error(s): \n\(error)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        if severity == "S" {
            textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        } else {
            textField.backgroundColor = UIColor(red: 1, green: 0.647, blue: 0, alpha: 0.3)
        }
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

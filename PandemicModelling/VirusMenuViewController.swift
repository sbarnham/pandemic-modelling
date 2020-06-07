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
    @IBOutlet var socialDistancingButton: UISwitch!
    @IBOutlet var socialDistancingSliderValue: UILabel!
    @IBOutlet var socialDistancingExplainer: UILabel!
    @IBOutlet var socialDistancingSlider: UISlider!
    @IBOutlet var lockdownLabel: UILabel!
    @IBOutlet var lockdownButton: UISwitch!
    @IBOutlet var activationThresholdField: UITextField!
    @IBOutlet var activationThresholdExplainer: UILabel!
    @IBOutlet var activationThresholdLabel: UILabel!
    @IBOutlet var lockdownStartLabel: UILabel!
    @IBOutlet var lockdownStartField: UITextField!
    @IBOutlet var lockdownStartExplainer: UILabel!
    @IBOutlet var lockdownLengthLabel: UILabel!
    @IBOutlet var lockdownLengthField: UITextField!
    @IBOutlet var lockdownLengthExplainer: UILabel!
    @IBOutlet var lockdownSlider: UISlider!
    @IBOutlet var lockdownEffectExplainer: UILabel!
    @IBOutlet var lockdownSliderValue: UILabel!
    
    var hideSDLabels = true
    var hideLLabels = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMovement()
        textFieldSetup(textField: populationField)
        textFieldSetup(textField: r0Field)
        textFieldSetup(textField: diseaseLengthField)
        textFieldSetup(textField: averageMortalityRateField)
        textFieldSetup(textField: activationThresholdField)
        textFieldSetup(textField: lockdownStartField)
        textFieldSetup(textField: lockdownLengthField)
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.87, blue: 0.91, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        populationField.placeholder = String(Aspects.population)
        r0Field.placeholder = String(Aspects.r0)
        diseaseLengthField.placeholder = String(Aspects.diseaseLength)
        averageMortalityRateField.placeholder = String(Aspects.averageMortalityRate)
        activationThresholdField.placeholder = String(Aspects.socialDistancingActivationThreshold)
        lockdownStartField.placeholder = String(Aspects.lockdownStart)
        lockdownLengthField.placeholder = String(Aspects.lockdownLength)
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
    
    func textFieldSetup(textField: UITextField) {
        textField.text?.removeAll()
        textField.delegate = self
    }
    
    
    @IBAction func socialDistancingSliderValueChanged(_ sender: Any) {
        socialDistancingSliderValue.text = String(format: "%.0f", socialDistancingSlider.value)
        Aspects.socialDistancingEffect = Double(1 - (socialDistancingSlider.value / 100))
    }
    
    
    @IBAction func lockdownSliderValueChanged(_ sender: Any) {
        lockdownSliderValue.text = String(format: "%.0f", lockdownSlider.value)
        Aspects.lockdownEffect = Double(1 - (lockdownSlider.value / 100))
    }
    
    
    
    func saveAspects() {
        Aspects.population = Int(populationField.text!) ?? 50000
        Aspects.r0 = Double(r0Field.text!) ?? 3
        Aspects.diseaseLength = Int(diseaseLengthField.text!) ?? 6
        Aspects.averageMortalityRate = Double(averageMortalityRateField.text!) ?? 2
        Aspects.socialDistancingActivationThreshold = Int(activationThresholdField.text!) ?? 20000
        Aspects.lockdownLength = Int(lockdownLengthField.text!) ?? 14
        Aspects.lockdownStart = Int(lockdownStartField.text!) ?? 6
    }
    
    func checkForWarnings(textField: UITextField) {
        Aspects.invalidData = false
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
        if Aspects.averageMortalityRate > 100 || Aspects.averageMortalityRate < 0 {
            errorAlert(error: "Mortality rate is not between 0 and 100%.", severity: "S", textField: textField)
        }
        if Aspects.socialDistancingActivationThreshold < 100 {
            errorAlert(error: "Social distancing activation threshold is low, and may not be reflected in real life.", severity: "M", textField: textField)
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
        Aspects.invalidData = true
    }
    
    
    @IBAction func socialDistancingToggled(_ sender: Any) {
        labelMovement()
    }
    
    
    @IBAction func lockdownToggled(_ sender: Any) {
        labelMovement()
    }
    
    func labelMovement() {
        if socialDistancingButton.isOn == false {
            lockdownLabel.frame.origin = CGPoint(x: 20, y: 353)
            lockdownButton.frame.origin = CGPoint(x: 293, y: 353)
            hideSDLabels = true
            Aspects.socialDistancing = false
            if lockdownButton.isOn == false {
                Aspects.lockdown = false
                hideLLabels = true
            } else {
                hideLLabels = false
                Aspects.lockdown = true
                lockdownStartLabel.frame.origin = CGPoint(x: 28, y: 402)
                lockdownLengthLabel.frame.origin = CGPoint(x: 28, y: 463)
                lockdownLengthField.frame.origin = CGPoint(x: 264, y: 397)
                lockdownStartField.frame.origin = CGPoint(x: 264, y: 458)
                lockdownStartExplainer.frame.origin = CGPoint(x: 26, y: 423)
                lockdownLengthExplainer.frame.origin = CGPoint(x: 26, y: 484)
                lockdownSlider.frame.origin = CGPoint(x: 23, y: 514)
                lockdownSliderValue.frame.origin = CGPoint(x: 184, y: 540)
                lockdownEffectExplainer.frame.origin = CGPoint(x: 25, y: 550)
            }
        } else {
            hideSDLabels = false
            lockdownLabel.frame.origin = CGPoint(x: 20, y: 501)
            lockdownButton.frame.origin = CGPoint(x: 293, y: 501)
            Aspects.socialDistancing = true
            if lockdownButton.isOn == true {
                Aspects.lockdown = true
                hideLLabels = false
                lockdownStartLabel.frame.origin = CGPoint(x: 28, y: 541)
                lockdownLengthLabel.frame.origin = CGPoint(x: 28, y: 602)
                lockdownLengthField.frame.origin = CGPoint(x: 264, y: 596)
                lockdownStartField.frame.origin = CGPoint(x: 264, y: 538)
                lockdownStartExplainer.frame.origin = CGPoint(x: 26, y: 562)
                lockdownLengthExplainer.frame.origin = CGPoint(x: 26, y: 619)
                lockdownSlider.frame.origin = CGPoint(x: 23, y: 649)
                lockdownSliderValue.frame.origin = CGPoint(x: 184, y: 676)
                lockdownEffectExplainer.frame.origin = CGPoint(x: 25, y: 687)
            } else {
                hideLLabels = true
                Aspects.lockdown = false
            }
        }
        socialDistancingSlider.isHidden = hideSDLabels
        socialDistancingSliderValue.isHidden = hideSDLabels
        socialDistancingExplainer.isHidden = hideSDLabels
        activationThresholdField.isHidden = hideSDLabels
        activationThresholdExplainer.isHidden = hideSDLabels
        activationThresholdLabel.isHidden = hideSDLabels
        lockdownStartLabel.isHidden = hideLLabels
        lockdownStartField.isHidden = hideLLabels
        lockdownStartExplainer.isHidden = hideLLabels
        lockdownLengthField.isHidden = hideLLabels
        lockdownLengthLabel.isHidden = hideLLabels
        lockdownLengthExplainer.isHidden = hideLLabels
        lockdownSlider.isHidden = hideLLabels
        lockdownEffectExplainer.isHidden = hideLLabels
        lockdownSliderValue.isHidden = hideLLabels
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

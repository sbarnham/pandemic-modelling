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
    
    //make sure labels are in the right place as well as text fields displaying correctly
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
    
    
    //Every time this view is loaded onto the screen, make sure the correct placeholders are set with the correct data
    override func viewDidAppear(_ animated: Bool) {
        populationField.placeholder = String(Aspects.population)
        r0Field.placeholder = String(Aspects.r0)
        diseaseLengthField.placeholder = String(Aspects.diseaseLength)
        averageMortalityRateField.placeholder = String(Aspects.averageMortalityRate)
        activationThresholdField.placeholder = String(Aspects.socialDistancingActivationThreshold)
        lockdownStartField.placeholder = String(Aspects.lockdownStart)
        lockdownLengthField.placeholder = String(Aspects.lockdownLength)
    }
    
    //Called when the 'Return' key is pressed on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Keyboard disappears.
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white //Reset any flagged error colours.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveAspects() //Save all data entered.
        if textField.text! != "" { //If there is some data entered
            checkForWarnings(textField: textField)
        }
    }
    
    func textFieldSetup(textField: UITextField) {
        textField.text?.removeAll() //Makes sure the text field is empty
        textField.delegate = self
    }
    
    
    @IBAction func socialDistancingSliderValueChanged(_ sender: Any) {
        socialDistancingSliderValue.text = String(format: "%.0f", socialDistancingSlider.value) //Update the value below the slider as it is scrolled.
        Aspects.socialDistancingEffect = Double(1 - (socialDistancingSlider.value / 100)) //Convert percentage to ratio.
    }
    
    
    @IBAction func lockdownSliderValueChanged(_ sender: Any) {
        lockdownSliderValue.text = String(format: "%.0f", lockdownSlider.value) //Update the value below the slider as it is scrolled.
        Aspects.lockdownEffect = Double(1 - (lockdownSlider.value / 100)) //Convert percentage to ratio.
    }
    
    
    //Saves data every time the user has stopped typing in a text field. If there is no text in the text field, the placeholder value is used. Force unwrapping the placeholder is justified here since the placeholder will never be empty.
    func saveAspects() {
        Aspects.population = Int(populationField.text!) ?? Int(populationField.placeholder!)!
        Aspects.r0 = Double(r0Field.text!) ?? Double(r0Field.placeholder!)!
        Aspects.diseaseLength = Int(diseaseLengthField.text!) ?? Int(diseaseLengthField.placeholder!)!
        Aspects.averageMortalityRate = Double(averageMortalityRateField.text!) ?? Double(averageMortalityRateField.placeholder!)!
        Aspects.socialDistancingActivationThreshold = Int(activationThresholdField.text!) ?? Int(activationThresholdField.placeholder!)!
        Aspects.lockdownLength = Int(lockdownLengthField.text!) ?? Int(lockdownLengthField.placeholder!)!
        Aspects.lockdownStart = Int(lockdownStartField.text!) ?? Int(lockdownStartField.placeholder!)!
    }
    /*
    Validation checker to see if the data entered by the user is valid.
     Various conditions exist for each data point, and if one of them is met, the errorAlert() function is called with a set message and severity.
     Severities:
     'S' means severe and is colour coded red. The simulation will not run.
     'M' means moderate and is colour coded orange. The simulation will run, but it may not be accurate.
     */
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
    
    //Presents an action sheet error to the user with the specified message, telling them the recommended course of action.
    func errorAlert(error: String, severity: String, textField: UITextField) {
        let alert = UIAlertController(title: "Incorrect/boundary input", message: "Please rectify the following error(s): \n\(error)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        //Set offending text field to a colour depending on severity.
        if severity == "S" {
            textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3) //red
        } else {
            textField.backgroundColor = UIColor(red: 1, green: 0.647, blue: 0, alpha: 0.3) //orange
        }
        Aspects.invalidData = true
    }
    
    
    @IBAction func socialDistancingToggled(_ sender: Any) {
        labelMovement()
    }
    
    
    @IBAction func lockdownToggled(_ sender: Any) {
        labelMovement()
    }
    
    //Performs the function of a 'drop-down' menu, by revealing and concealing contents of the 'Social Distancing' and 'Lockdown' data depending on their toggle.
    func labelMovement() {
        if socialDistancingButton.isOn == false {
            lockdownLabel.frame.origin = CGPoint(x: 20, y: 353)
            lockdownButton.frame.origin = CGPoint(x: 293, y: 353)
            hideSDLabels = true
            Aspects.socialDistancing = false
            if lockdownButton.isOn == false { //If SD + L are not enforced
                Aspects.lockdown = false
                hideLLabels = true
            } else { //If SD is not enforced but L is. All Lockdown labels, text fields and slider must be moved upwards.
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
            if lockdownButton.isOn == true { //If SD + L are enforced. All Lockdown labels must be moved to the bottom end of the screen.
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
        //Labels hidden depending on the Social Distancing hide label value and the Lockdown hide label value.
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
    
}

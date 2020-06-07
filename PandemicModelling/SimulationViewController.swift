//
//  SimulationViewController.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 11/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import UIKit
import Charts

class SimulationViewController: UIViewController {
    
    
    @IBOutlet var lineChart: LineChartView!
    @IBOutlet var susceptibleLabel: UILabel!
    @IBOutlet var infectedLabel: UILabel!
    @IBOutlet var survivedLabel: UILabel!
    @IBOutlet var deceasedLabel: UILabel!
    @IBOutlet var susceptibleSwitch: UISwitch!
    @IBOutlet var infectedSwitch: UISwitch!
    @IBOutlet var survivedSwitch: UISwitch!
    @IBOutlet var deceasedSwitch: UISwitch!
    
    var modeller = Modeller()
    var infectedDataEntries: [ChartDataEntry] = []
    var susceptibleDataEntries: [ChartDataEntry] = []
    var survivedDataEntries: [ChartDataEntry] = []
    var deceasedDataEntries: [ChartDataEntry] = []
    var deceased: Double = 0
    var susceptibleLineShown: Bool = true
    var infectedLineShown: Bool = true
    var survivedLineShown: Bool = true
    var deceasedLineShown: Bool = true
    
    //Setup of chart modifications and formats
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.87, blue: 0.91, alpha: 1)
        susceptibleLabel.text = "Susceptible: nil"
        infectedLabel.text = "Infected: nil"
        survivedLabel.text = "Removed: nil"
        deceasedLabel.text = "Deceased: nil"
        lineChart.backgroundColor = UIColor(red: 0.76, green: 0.87, blue: 0.91, alpha: 1)
        lineChart.drawGridBackgroundEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.axisMinimum = 0
        lineChart.xAxis.spaceMax = 1
        lineChart.xAxis.granularity = 1
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.axisMinimum = 0
        lineChart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.leftAxis.granularity = 1
        lineChart.leftAxis.drawGridLinesEnabled = false
        updateChartData()
        
        // Do any additional setup after loading the view.
    }
    
    //The ViewController simulation() function manages the pre-requisits for the Modeller simulate() function, as well as making sure that the data entries are cleared and prepared for new data. It then schedules the calling of the simulate() function on a timer that repeats every half-second, so the user can see how the chart is animated as values are calculated.
    func simulation() {
        modeller.reset()
        susceptibleDataEntries.removeAll()
        infectedDataEntries.removeAll()
        survivedDataEntries.removeAll()
        deceasedDataEntries.removeAll()
        modeller.day = 0
        modeller.r = Aspects.r0
        modeller.susceptible = (Aspects.population - 1)
        susceptibleDataEntries.append(ChartDataEntry(x: 0, y: Double(modeller.susceptible)))
        infectedDataEntries.append(ChartDataEntry(x: 0, y: 1))
        survivedDataEntries.append(ChartDataEntry(x: 0, y: 0))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            //Loop stops when the virus is eradicated from the population.
            if self.modeller.infected == 0 {
                timer.invalidate()
            }
            let tuple = self.modeller.simulate()
            self.deceased = round(Double(tuple.2) * (Aspects.averageMortalityRate / 100))
            self.susceptibleLabel.text = "Susceptible: \(tuple.0)"
            self.infectedLabel.text = "Infected: \(tuple.1)"
            self.survivedLabel.text = "Survived: \(tuple.2 - Int(self.deceased))"
            self.deceasedLabel.text = "Deceased: \(Int(self.deceased))"
            self.modeller.day += 1
            self.susceptibleDataEntries.append(ChartDataEntry(x: Double(self.modeller.day), y: Double(tuple.0)))
            self.infectedDataEntries.append(ChartDataEntry(x: Double(self.modeller.day), y: Double(tuple.1)))
            self.survivedDataEntries.append(ChartDataEntry(x: Double(self.modeller.day), y: Double(tuple.2) - Double(self.deceased)))
            self.deceasedDataEntries.append(ChartDataEntry(x: Double(self.modeller.day), y: Double(self.deceased)))
            self.updateChartData()
        }
        
    }
    
    //When the 'Simulate' button is pressed.
    @IBAction func simulateButton(_ sender: Any) {
        //The two lineChart functions clear the data sets and values on the charts, so a new simulation can be run.
        lineChart.clear()
        lineChart.clearValues()
        switchCheck()
        //If the invalidData flag is true, the simulation will not run.
        if Aspects.invalidData == true {
            errorAlert()
            return
        }
        simulation()
    }
    
    
    //Checks the state of the switches and changes the line flags accordingly.
    func switchCheck() {
        if susceptibleSwitch.isOn == false {
            susceptibleLineShown = false
        } else {
            susceptibleLineShown = true
        }
        if infectedSwitch.isOn == false {
            infectedLineShown = false
        } else {
            infectedLineShown = true
        }
        if survivedSwitch.isOn == false {
            survivedLineShown = false
        } else {
            survivedLineShown = true
        }
        if deceasedSwitch.isOn == false {
            deceasedLineShown = false
        } else {
            deceasedLineShown = true
        }
    }
    
    
    
    //Formatting each line of data. Required after every alteration of data (due to how the library works).
    fileprivate func dataSetFormatting(chartDataSet: LineChartDataSet, colour: UIColor) {
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.05
        chartDataSet.lineWidth = 3
        chartDataSet.circleRadius = 2.5
        chartDataSet.setColor(colour)
        chartDataSet.fill = Fill(color: colour)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.setCircleColor(colour)
        chartDataSet.drawValuesEnabled = false
    }
    
    //Updates chart data after each call.
    func updateChartData() {
        let infChartDataSet = LineChartDataSet(entries: infectedDataEntries, label: "Infected")
        let susChartDataSet = LineChartDataSet(entries: susceptibleDataEntries, label: "Susceptible")
        let survChartDataSet = LineChartDataSet(entries: survivedDataEntries, label: "Survived")
        let decChartDataSet = LineChartDataSet(entries: deceasedDataEntries, label: "Deceased")
        var dataSets = [LineChartDataSet]()
        if susceptibleLineShown == true {
            dataSets.append(susChartDataSet)
        }
        if infectedLineShown == true {
            dataSets.append(infChartDataSet)
        }
        if survivedLineShown == true {
            dataSets.append(survChartDataSet)
        }
        if deceasedLineShown == true {
            dataSets.append(decChartDataSet)
        }
        let chartData = LineChartData(dataSets: dataSets)
        dataSetFormatting(chartDataSet: infChartDataSet, colour: .red)
        dataSetFormatting(chartDataSet: susChartDataSet, colour: .blue)
        dataSetFormatting(chartDataSet: survChartDataSet, colour: .gray)
        dataSetFormatting(chartDataSet: decChartDataSet, colour: .black)
        lineChart.data = chartData
    }
    
    //This function is triggered when the user has bypassed the alerts on the 'Edit Virus' screen without correcting them, but still attempts to simulate.
    func errorAlert() {
        let alert = UIAlertController(title: "One or more inputs are invalid", message: "Please navigate to the 'Edit Virus' screen and enter valid data for all input fields", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


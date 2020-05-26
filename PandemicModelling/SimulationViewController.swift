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
    
    @IBOutlet var removedLabel: UILabel!
    
    var aspects = Aspects()
    var modeller = Modeller()
    var infectedDataEntries: [ChartDataEntry] = []
    var susceptibleDataEntries: [ChartDataEntry] = []
    var survivedDataEntries: [ChartDataEntry] = []
    var deceasedDataEntries: [ChartDataEntry] = []
    var day: Double = 0
    var deceased: Double = 0
    
    //Setup of chart modifications and formats
    override func viewDidLoad() {
        super.viewDidLoad()
        susceptibleLabel.text = "Susceptible: nil"
        infectedLabel.text = "Infected: nil"
        removedLabel.text = "Removed: nil"
        lineChart.backgroundColor = .white
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
    
    func simulation() {
        modeller.reset()
        day = 0
        modeller.r = aspects.r0
        modeller.susceptible = (aspects.population - 1)
        susceptibleDataEntries.append(ChartDataEntry(x: 0, y: Double(modeller.susceptible)))
        infectedDataEntries.append(ChartDataEntry(x: 0, y: 1))
        survivedDataEntries.append(ChartDataEntry(x: 0, y: 0))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.modeller.infected == 0 {
                timer.invalidate()
            }
            let tuple = self.modeller.simulate(data: self.aspects)
            self.susceptibleLabel.text = "Susceptible: \(tuple.0)"
            self.infectedLabel.text = "Infected: \(tuple.1)"
            self.removedLabel.text = "Removed: \(tuple.2)"
            self.day += 1
            self.deceased = round(Double(tuple.2) * self.aspects.averageMortalityRate)
            self.susceptibleDataEntries.append(ChartDataEntry(x: self.day, y: Double(tuple.0)))
            self.infectedDataEntries.append(ChartDataEntry(x: self.day, y: Double(tuple.1)))
            self.survivedDataEntries.append(ChartDataEntry(x: self.day, y: Double(tuple.2) - Double(self.deceased)))
            self.deceasedDataEntries.append(ChartDataEntry(x: self.day, y: Double(self.deceased)))
            self.updateChartData()
        }
        
    }
    
    @IBAction func simulateButton(_ sender: Any) {
        lineChart.clear()
        lineChart.clearValues()
        simulation()
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
        let chartData = LineChartData(dataSets: [susChartDataSet, infChartDataSet, survChartDataSet, decChartDataSet])
        dataSetFormatting(chartDataSet: infChartDataSet, colour: .red)
        dataSetFormatting(chartDataSet: susChartDataSet, colour: .blue)
        dataSetFormatting(chartDataSet: survChartDataSet, colour: .gray)
        dataSetFormatting(chartDataSet: decChartDataSet, colour: .black)
        lineChart.data = chartData
    }
}


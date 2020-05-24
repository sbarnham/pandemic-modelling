//
//  ViewController.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 11/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet var lineChart: LineChartView!

    
    var aspects = Aspects()
    var modeller = Modeller()
    var dataEntries: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 0)]
    var day: Double = 0
    
    
    @IBOutlet var susceptibleLabel: UILabel!
    
    @IBOutlet var infectedLabel: UILabel!
    
    @IBOutlet var removedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        susceptibleLabel.text = "Susceptible: nil"
        infectedLabel.text = "Infected: nil"
        removedLabel.text = "Removed: nil"
        lineChart.backgroundColor = .white
        lineChart.drawGridBackgroundEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.axisMinimum = 0
        lineChart.xAxis.spaceMax = 0.1
        lineChart.leftAxis.axisMinimum = 0
        updateChartData()
        
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
            self.day += 1
            self.dataEntries.append(ChartDataEntry(x: self.day, y: Double(tuple.1)))
            self.updateChartData()
        }
        
    }
    
    @IBAction func simulateButton(_ sender: Any) {
        simulation()
    }
    
    func updateChartData() {
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Infected")
        let chartData = LineChartData(dataSet: chartDataSet)
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 3
        chartDataSet.circleRadius = 2.5
        chartDataSet.setColor(.red)
        chartDataSet.fill = Fill(color: .red)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.setCircleColor(.red)
        lineChart.data = chartData
        
        
        
    }
}


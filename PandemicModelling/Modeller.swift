//
//  Modeller.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 11/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import Foundation

class Modeller {
    var infected: Int = 1
    var r: Double = 0
    var removed: Int = 0
    var day: Int = 1
    var susceptible: Int = 0
    var infectedNumbers: [Int] = []
    var newInfected: Int = 0
    
    func simulate(data: Aspects) -> (Int, Int, Int) {
        r = r * Double((susceptible / data.population))
        newInfected = Int(round(Double(infected) * r))
        infected += newInfected
        if infectedNumbers.count != data.diseaseLength {
            infectedNumbers.append(newInfected)
        } else {
            removed += infectedNumbers[0]
            infected -= infectedNumbers.remove(at: 0)
            infectedNumbers.append(newInfected)
        }
        susceptible = data.population - infected - removed
        return (susceptible, infected, removed)
    }
    }


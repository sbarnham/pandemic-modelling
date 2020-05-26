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
    var susceptible: Int = 0
    var infectedNumbers: [Int] = [1]
    var newInfected: Int = 0
    
    //The basic simulation function.
    func simulate(data: Aspects) -> (Int, Int, Int) {
        r = r * Double(susceptible) / Double(data.population)
        newInfected = Int(round(Double(infected) * r))
        infected += newInfected
        if infected > data.population {
            infected = data.population
        }
        if infectedNumbers.count != data.diseaseLength {
            infectedNumbers.append(newInfected)
        } else {
            removed += infectedNumbers[0]
            if removed > data.population {
                removed = data.population
            }
            infected -= infectedNumbers.remove(at: 0)
            if infected < 0 {
                infected = 0
            }
            infectedNumbers.append(newInfected)
        }
        if susceptible > 0 {
            susceptible = data.population - infected - removed
            if susceptible < 0 {
                susceptible = 0
            }
        }
        return (susceptible, infected, removed)
    }
    
    
    //Resets default values for variables not automatically reset by the simulation() method in the SimulationViewController class.
    func reset() {
        removed = 0
        infectedNumbers = [1]
        infected = 1
    }
    }


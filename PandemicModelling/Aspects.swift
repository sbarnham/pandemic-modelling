//
//  Aspects.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 11/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import Foundation

class Aspects {
    let name: String = "Virus X"
    var r0: Double = 1.2
    var averageMortalityRate: Double = 0.05
    var population: Int = 5000
    var lockdownAbidingRate: Double = 0
    var socialDistancing: Bool = false
    var over65Proportion: Double = 0
    var over65MortalityRate: Double = 0
    var teenageProportion: Double = 0
    var teenageMortalityRate: Double = 0
    var vaccinationRate: Double = 0
}

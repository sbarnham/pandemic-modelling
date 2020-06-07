//
//  Aspects.swift
//  PandemicModelling
//
//  Created by Barnham, Samuel (ABH) on 11/05/2020.
//  Copyright © 2020 Barnham, Samuel (ABH). All rights reserved.
//

import Foundation

//Static class; no need for instantiation and is accessed throughout all ViewControllers, requiring values to be maintained and not reset.
class Aspects {
    static var r0: Double = 3
    static var averageMortalityRate: Double = 20
    static var population: Int = 50000
    static var diseaseLength: Int = 6
    static var socialDistancing: Bool = true
    static var socialDistancingEffect: Double = 50
    static var socialDistancingActivationThreshold: Int = 20000
    static var lockdown: Bool = false
    static var lockdownStart: Int = 6
    static var lockdownLength: Int = 14
    static var lockdownEffect: Double = 50
    static var vaccinationRate: Double = 0
    static var invalidData: Bool = false
}

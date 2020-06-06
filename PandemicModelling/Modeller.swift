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
    var SDr: Double = 0
    var lockdownR: Double = 0
    var SDLr: Double = 0
    var removed: Int = 0
    var susceptible: Int = 0
    var infectedNumbers: [Int] = [1]
    var newInfected: Int = 0
    var day: Int = 0
    var SDActivated: Bool = false
    var lockdownActivated: Bool = false
    
    /*
    The simulation function, taking into account all user inputs or default values. The simulation uses basic mathematics to calculate susceptible, infected and 'removed' persons per day. The loop continues, slowly diminishing the r (reproductive number) value until the virus cannot spread anymore.
     The model assumes various things:
      - People who have survived the disease have immunity, and cannot spread it again.
      - The virus is spread by contact with infected persons. It is not spread through sexual contact.
      - All infected persons experience the disease for the same amount of days, for which they can all spread the disease within this period.
      - The mortality rate is fixed, and every member of the population has the same susceptibility to it (ie. no age or underlying health conditions are given in this simulation)
     
    */
    func simulate() -> (Int, Int, Int) {
        SDActivated = false
        lockdownActivated = false
        newInfected = Int(round(Double(infected) * chooseR()))
        infected += newInfected
        if infected > Aspects.population {
            infected = Aspects.population
        }
        if infectedNumbers.count != Aspects.diseaseLength {
            infectedNumbers.append(newInfected)
        } else {
            removed += infectedNumbers[0]
            if removed > Aspects.population {
                removed = Aspects.population
            }
            infected -= infectedNumbers.remove(at: 0)
            if infected < 0 {
                infected = 0
            }
            infectedNumbers.append(newInfected)
        }
        if susceptible > 0 {
            susceptible = Aspects.population - infected - removed
            if susceptible < 0 {
                susceptible = 0
            }
        }
        return (susceptible, infected, removed)
    }
    
    func chooseR() -> Double {
        r = r * Double(susceptible) / Double(Aspects.population)
        if SDActivated && lockdownActivated {
            SDLr = SDLr * Aspects.socialDistancingEffect * Aspects.lockdownEffect
            return SDLr
        }
        if infected >= Aspects.socialDistancingActivationThreshold && Aspects.socialDistancing {
           if SDActivated {
                SDr = SDr * Aspects.socialDistancingEffect
           }
           SDr = r * Aspects.socialDistancingEffect
           SDActivated = true
       }
       if day >= Aspects.lockdownStart && (day - Aspects.lockdownStart) < Aspects.lockdownLength && Aspects.lockdown {
            if lockdownActivated {
                lockdownR = lockdownR * Aspects.lockdownEffect
            }
           lockdownR = r * Aspects.lockdownEffect
           lockdownActivated = true
       }
       if SDActivated && lockdownActivated {
           SDLr = r * Aspects.lockdownEffect * Aspects.socialDistancingEffect
           return SDLr
       }
       if SDActivated {
            return SDr
       }
       if lockdownActivated {
            return lockdownR
       }
       return r
    }
    
    
    //Resets default values for variables not automatically reset by the simulation() method in the SimulationViewController class.
    func reset() {
        removed = 0
        infectedNumbers = [1]
        infected = 1
    }
    }


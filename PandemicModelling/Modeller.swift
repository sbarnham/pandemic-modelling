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
    var removed: Int = 0 //The amount of people that have been infected but are no longer contagious.
    var susceptible: Int = 0
    var infectedNumbers: [Int] = [1] //An array to store the number of people infected per day.
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
        newInfected = Int(round(Double(infected) * chooseR())) //Multiplying the amount of people currently infected by the chosen reproduction number.
        infected += newInfected //Incrementing the current infected amount by the newly infected people of the day.
        if infected > Aspects.population { //Making sure that the infected number does not exceed the population count. If so, it means the entire population is infected.
            infected = Aspects.population
        }
        if infectedNumbers.count != Aspects.diseaseLength { //If the array has not let reached the length of the 'Disease Length' as set by the user.
            infectedNumbers.append(newInfected) //Adds the new infected count for the day to the end of the array.
        } else {
            removed += infectedNumbers[0] //Increments by the value of infected people that have outlasted the 'Disease Length'.
            if removed > Aspects.population { //Making sure the amount of people who have had the virus does not exceed population.
                removed = Aspects.population
            }
            infected -= infectedNumbers.remove(at: 0) //Pops array and decrements the infected count by the newly removed count.
            if infected < 0 { //Making sure infection numbers do not become negative.
                infected = 0
            }
            infectedNumbers.append(newInfected)
        }
        if susceptible > 0 {
            susceptible = Aspects.population - infected - removed //Calculate the remaining susceptible population.
            if susceptible < 0 { //Making sure the susceptible numbers do not become negative.
                susceptible = 0
            }
        }
        return (susceptible, infected, removed)
    }
    
    /*
     The chooseR() function makes sure that the correct reproduction number is being used.
     This is by checking whether Social Distancing or Lockdown or both measures are currently being implemented.
     */
    func chooseR() -> Double {
        r = r * Double(susceptible) / Double(Aspects.population) //Reproduction number is multiplied by itself and the susceptibility ratio of the population.
        if SDActivated && lockdownActivated { //If SD + L are being enforced BUT NOT for the first time.
            SDLr = SDLr * Aspects.socialDistancingEffect * Aspects.lockdownEffect //Multiply the social distancing + lockdown reproduction number using the formula.
            return SDLr
        }
        if infected >= Aspects.socialDistancingActivationThreshold && Aspects.socialDistancing { //If the quota set by the user is met and social distancing is enforced
           if SDActivated { //If SD is being enforced BUT NOT for the first time
                SDr = SDr * Aspects.socialDistancingEffect
           }
           SDr = r * Aspects.socialDistancingEffect //If this is the first day SD is being enforced, multiply the current R value by the social distancing effect.
           SDActivated = true
       }
       if day >= Aspects.lockdownStart && (day - Aspects.lockdownStart) < Aspects.lockdownLength && Aspects.lockdown { //If the quota set by the user is met and lockdown is enforced
            if lockdownActivated { //If L is being enforced BUT NOT for the first time
                lockdownR = lockdownR * Aspects.lockdownEffect
            }
           lockdownR = r * Aspects.lockdownEffect //If this is the first day L is being enforced, multiply the current R value by the lockdown effect.
           lockdownActivated = true
       }
       if SDActivated && lockdownActivated { //If SD + L are being enforced for the first time, together at the same time. (Unlikely)
           SDLr = r * Aspects.lockdownEffect * Aspects.socialDistancingEffect
           return SDLr
       }
       if SDActivated {
            return SDr
       }
       if lockdownActivated {
            return lockdownR
       }
        //If neither lockdown or social distancing is currently being enforced.
       return r
    }
    
    
    //Resets default values for variables not automatically reset by the simulation() method in the SimulationViewController class.
    func reset() {
        removed = 0
        infectedNumbers = [1]
        infected = 1
    }
    }


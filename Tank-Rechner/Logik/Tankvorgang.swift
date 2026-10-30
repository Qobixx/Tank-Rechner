//
//  Tankvorgang.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 23.10.26.
//

import Foundation
import SwiftData

@Model
class Tankvorgang{
    var Datum: Date
    var liter: Double
    var gesamtpreis: Double
    
    init(Datum: Date = .now, liter: Double, gesamtpreis: Double) {
        self.Datum = Datum
        self.liter = liter
        self.gesamtpreis = gesamtpreis
    }
    
    var literpreis: Double{
        liter > 0 ? gesamtpreis / liter : 0
    }
}

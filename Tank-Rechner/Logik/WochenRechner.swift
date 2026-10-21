//
//  WochenRechner.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 18.10.26.
//

import SwiftUI

struct WochenRechner: View{
    let titel: String
    @Binding var Wert: Double
    let einheit: String
    
    var body: some View{
        HStack{
            Text(titel)
            Spacer()
            TextField("0", value: $Wert, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
                .contentShape(Rectangle())
            Text(einheit)
        }
        .contentShape(Rectangle())
    }
    
}

func VerbauchRechner(montag:Double, dienstag:Double, mittwoch:Double, donnerstag:Double, freitag:Double, samstag:Double, sonntag:Double) -> String{
    let wochenkm = montag + dienstag + mittwoch + donnerstag + freitag + samstag + sonntag
    let formatiert = String(format: "%.0f", wochenkm)
    return formatiert
}

func PreisRechner(wochenkm:String, verbrauch_prokm:Double, preis_l:Double) -> String{
    guard let wochen_km = Double(wochenkm) else {
        return "Falsche Eingabe"
    }
    let preis = (wochen_km/100) * verbrauch_prokm * preis_l
    let formatiert = String(format: "%.2f", preis)
    return formatiert
}

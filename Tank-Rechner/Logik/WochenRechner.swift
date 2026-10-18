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

func VerbauchRechner() -> String{
    let ergebnis: Double = 0.8
    return "\(ergebnis)"
}

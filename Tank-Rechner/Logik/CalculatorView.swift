//
//  CalculatorView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI

struct CalculatorView: View {
    @AppStorage("Montag") private var km_montag: Double = 0.0
    @AppStorage("Dienstag") private var km_dienstag: Double = 0.0
    @AppStorage("Mittwoch") private var km_mittwoch: Double = 0.0
    @AppStorage("Donnerstag") private var km_donnerstag: Double = 0.0
    @AppStorage("Freitag") private var km_freitag: Double = 0.0
    @AppStorage("Samstag") private var km_samstag: Double = 0.0
    @AppStorage("Sonntag") private var km_sonntag: Double = 0.0
    
    @AppStorage("100kmHVerbauch") private var kmh_Verbrauch: Double = 0.0
    var body: some View {
        NavigationStack{
            Form{
                Section("Verbrauch der Woche"){
                    WochenRechner(titel: "Montag", Wert: $km_montag, einheit: "Km")
                    WochenRechner(titel: "Dienstag", Wert: $km_dienstag, einheit: "Km")
                    WochenRechner(titel: "Mittwoch", Wert: $km_mittwoch, einheit: "Km")
                    WochenRechner(titel: "Donnerstag", Wert: $km_donnerstag, einheit: "Km")
                    WochenRechner(titel: "Freitag", Wert: $km_freitag, einheit: "Km")
                    WochenRechner(titel: "Samstag", Wert: $km_samstag, einheit: "Km")
                    WochenRechner(titel: "Sonntag", Wert: $km_sonntag, einheit: "Km")
                }
                Section("Daten"){
                    WochenRechner(titel: "Ø Verbauch 100/km", Wert: $kmh_Verbrauch, einheit: "L/100km")
                }
            }
            // Zwingt das iPhone, die Tastatur bei jedem Tippen auf den Hintergrund zu schließen:
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            
        }
        
    }
}

#Preview {
    CalculatorView()
}

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
    @AppStorage("SpritPreis") private var sprit_preis: Double = 0.0
    
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
                    WochenRechner(titel: "Verbrauch", Wert: $kmh_Verbrauch, einheit: "L/100km")
                    WochenRechner(titel: "Sprit", Wert: $sprit_preis, einheit: "€")
                }
                Section("Ausgabe"){
                    HStack{
                        Text("Wochen Km")
                        Spacer()
                        Text(VerbauchRechner(montag: km_montag, dienstag: km_dienstag, mittwoch: km_mittwoch, donnerstag: km_donnerstag, freitag: km_freitag, samstag: km_samstag, sonntag: km_sonntag))
                    }
                    HStack{
                        Text("Preis")
                        Spacer()
                        Text(PreisRechner(wochenkm: VerbauchRechner(montag: km_montag, dienstag: km_dienstag, mittwoch: km_mittwoch, donnerstag: km_donnerstag, freitag: km_freitag, samstag: km_samstag, sonntag: km_sonntag),verbrauch_prokm: kmh_Verbrauch, preis_l: sprit_preis))
                    }
                    
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

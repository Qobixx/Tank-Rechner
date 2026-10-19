//
//  ContentView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 14.10.26.
//

import SwiftUI
    
struct ContentView: View {
    @AppStorage("savedAppColor") private var darstellung_farbe: Color = .blue
    
    var body: some View {
        TabView{
            Tab("Rechner", systemImage: "fuelpump.fill"){
                CalculatorView()
            }
            Tab("Verbrauch", systemImage: "car.fill"){
                ConsumptionView()
            }
            Tab("Einstellung", systemImage: "gear"){
                SettingView(rgbColor: $darstellung_farbe)
            }
        }
        .tint(darstellung_farbe)
         

    }
        
}

#Preview {
    ContentView()
}

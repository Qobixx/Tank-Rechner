//
//  ContentView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 14.10.26.
//

import SwiftUI
    
struct ContentView: View {	
    @AppStorage("savedAppColor") private var darstellung_farbe: Color = .blue
    @AppStorage("FormColor") private var form_farbe: Color = Color(.systemGray6)
    
    var body: some View {
        TabView{
            Tab("Rechner", systemImage: "fuelpump.fill"){
                CalculatorView(Form_Color: $form_farbe)
            }
            Tab("Verbrauch", systemImage: "car.fill"){
                ConsumptionView()
            }
            Tab("Einstellung", systemImage: "gear"){
                SettingView(rgbColor_HotBar: $darstellung_farbe, rgbColor_Form: $form_farbe)
            }
        }
        .tint(darstellung_farbe)
    }
}

#Preview {
    ContentView()
}

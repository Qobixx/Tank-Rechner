//
//  TankstellenZeile.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 08.11.26.
//

import SwiftUI

struct TankstellenZeile: View {
    let TankstelleName: String
    let preis: Double
    let strasse: String
    let ort: String
    let open: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
                    // Erste Zeile: Tankstellenname & Offen/Geschlossen-Badge
                    HStack(alignment: .center) {
                        Label(TankstelleName, systemImage: "fuelpump.fill")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(open ? "Offen" : "Geschlossen")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(open ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                            .foregroundColor(open ? .green : .red)
                            .cornerRadius(6)
                    }
                    
                    // Zweite Zeile: Adresse & Hervorgehobener Preis
                    HStack(alignment: .bottom) {
                        Label("\(strasse), \(ort)", systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2) // Erlaubt bis zu 2 Zeilen, falls die Adresse lang ist
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.2f", preis)) €/L")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 4)
                .contextMenu{
                    Button("Preis übernehmen", systemImage: "eurosign"){
                        UserDefaults.standard.set(String(format: "%.2f", preis),forKey: "SpritPreis")
                    }
                }
        }
       
        
        
            
        
    }

#Preview {
    TankstellenZeile(TankstelleName: "Aral", preis: 2.923, strasse: "HATZPERSTR.221", ort: "Essen", open: true)
}

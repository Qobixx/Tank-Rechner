//
//  TankvorgangZeile.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 23.10.26.
//

import SwiftUI

struct TankvorgangZeile: View {
    let tanken: Tankvorgang
    
    var body: some View {
        HStack(spacing: 12) {
            // Ein kleines Symbol auf der linken Seite für den visuellen Look
            Image(systemName: "fuelpump.fill")
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                // Erste Zeile: Datum & Gesamtpreis
                HStack(alignment: .firstTextBaseline) {
                    Text(tanken.Datum, format: .dateTime.day().month().year())
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(tanken.gesamtpreis, format: .currency(code: "EUR"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                // Zweite Zeile: Liter & Literpreis (Details)
                HStack(alignment: .firstTextBaseline) {
                    Label("\(tanken.liter, format: .number.precision(.fractionLength(2))) Liter", systemImage: "drop.fill")
                    
                    Spacer()
                    
                    Text("\(tanken.literpreis, format: .currency(code: "EUR")) / L")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        TankvorgangZeile(tanken: Tankvorgang(liter: 42.5, gesamtpreis: 78.90))
    }
}

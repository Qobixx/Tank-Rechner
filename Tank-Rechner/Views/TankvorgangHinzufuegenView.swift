//
//  TankvorgangHinzufuegenView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 23.10.26.
//

import SwiftUI
import SwiftData

struct TankvorgangHinzufuegenView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // Optionaler Tankvorgang: Wenn nil, sind wir im "Hinzufügen"-Modus. Wenn vorhanden, im "Bearbeiten"-Modus.
    var bestehenderVorgang: Tankvorgang?
    
    @State private var datum: Date
    @State private var liter: Double?
    @State private var gesamtpreis: Double?
    
    // Initializer, um die bestehenden Werte beim Start in die @State-Variablen zu laden
    init(bestehenderVorgang: Tankvorgang? = nil) {
        self.bestehenderVorgang = bestehenderVorgang
        
        // Wenn ein Vorgang übergeben wurde, fülle die States mit den Werten, sonst nimm Standardwerte
        _datum = State(initialValue: bestehenderVorgang?.Datum ?? Date.now)
        _liter = State(initialValue: bestehenderVorgang?.liter)
        _gesamtpreis = State(initialValue: bestehenderVorgang?.gesamtpreis)
    }
    
    private func istGueltig() -> Bool {
        return (liter ?? 0) > 0 && (gesamtpreis ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Datum", selection: $datum, displayedComponents: .date)
                HStack {
                    Text("Liter")
                    Spacer()
                    TextField("0", value: $liter, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("L")
                }
                HStack {
                    Text("Gesamtpreis")
                    Spacer()
                    TextField("0", value: $gesamtpreis, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("€")
                }
            }
            // Titel dynamisch anpassen je nach Modus
            .navigationTitle(bestehenderVorgang == nil ? "Neue Tankfüllung" : "Tankvorgang bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sichern") {
                        if let vorgang = bestehenderVorgang {
                            // Bestehenden Datensatz aktualisieren
                            vorgang.Datum = datum
                            vorgang.liter = liter ?? 0
                            vorgang.gesamtpreis = gesamtpreis ?? 0
                        } else {
                            // Neuen Datensatz einfügen
                            let neuerVorgang = Tankvorgang(Datum: datum, liter: liter ?? 0, gesamtpreis: gesamtpreis ?? 0)
                            context.insert(neuerVorgang)
                        }
                        dismiss()
                    }
                    .disabled(!istGueltig())
                }
            }
        }
    }
}

#Preview {
    TankvorgangHinzufuegenView()
        .modelContainer(for: Tankvorgang.self, inMemory: true)
}

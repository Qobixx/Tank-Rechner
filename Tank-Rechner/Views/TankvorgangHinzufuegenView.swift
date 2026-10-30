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
    
    @State private var datum = Date.now
    @State private var liter: Double?
    @State private var gesamtpreis: Double?
    
    private func istGueltig() -> Bool{
        return (liter ?? 0) > 0 && (gesamtpreis ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack{
            Form{
                DatePicker("Datum", selection: $datum, displayedComponents: .date)
                HStack{
                    Text("Liter")
                    Spacer()
                    TextField("0", value: $liter, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("L")
                }
                HStack{
                    Text("Gesamtpreis")
                    Spacer()
                    TextField("0", value: $gesamtpreis, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("€")
                }
            }
            .navigationTitle("Neue Tankfüllung")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Sichern"){
                        context.insert(Tankvorgang(Datum: datum, liter: liter ?? 0, gesamtpreis: gesamtpreis ?? 0))
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

//
//  ConsumptionView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI
import SwiftData

struct VerbrauchView: View {
    @Query(sort: \Tankvorgang.Datum, order: .reverse) var tankvorgaenge: [Tankvorgang]
    @Environment(\.modelContext) private var context
    
    // States für die Sheets
    @State private var zeigeHinzufuegen = false
    @State private var ausgewaehlterVorgang: Tankvorgang? = nil // Hält den Vorgang fest, der bearbeitet werden soll
    @State private var zeigeTankstellen = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tankvorgaenge) { tanken in
                    Button {
                        // Wenn auf eine Zeile getippt wird, öffnen wir den Bearbeitungsmodus
                        ausgewaehlterVorgang = tanken
                    } label: {
                        TankvorgangZeile(tanken: tanken)
                    }
                    .buttonStyle(.plain) // Verhindert, dass die ganze Zeile standardmäßig grau/blau eingefärbt wird
                }
                .onDelete { offsets in
                    for index in offsets {
                        context.delete(tankvorgaenge[index])
                    }
                }
            }
            .overlay {
                if tankvorgaenge.isEmpty {
                    ContentUnavailableView("Noch nichts getankt", systemImage: "fuelpump", description: Text("Tipp auf +, um einen Tankvorgang hinzuzufügen."))
                }
            }
            .navigationTitle("Verbrauch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Tanken", systemImage: "plus") {
                        ausgewaehlterVorgang = nil // Sicherstellen, dass kein alter Vorgang im Speicher hängt -> Hinzufügen-Modus
                        zeigeHinzufuegen = true
                    }
                    NavigationLink {
                        TankstellenView()
                    } label: {
                        Image(systemName: "fuelpump")
                    }
                }
            }
            // Sheet fürs Hinzufügen (wenn auf das "+"-Icon geklickt wird)
            .sheet(isPresented: $zeigeHinzufuegen) {
                TankvorgangHinzufuegenView(bestehenderVorgang: nil)
            }
            // Sheet fürs Bearbeiten (wenn auf eine Zeile geklickt wird)
            .sheet(item: $ausgewaehlterVorgang) { vorgang in
                TankvorgangHinzufuegenView(bestehenderVorgang: vorgang)
            }
        }
    }
}

#Preview {
    VerbrauchView()
        .modelContainer(for: Tankvorgang.self, inMemory: true)
}

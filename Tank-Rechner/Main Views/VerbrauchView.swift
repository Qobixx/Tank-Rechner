//
//  ConsumptionView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI
import SwiftData

struct ConsumptionView: View {
    @Query(sort: \Tankvorgang.Datum, order: .reverse) var tankvorgaenge: [Tankvorgang]
    @Environment(\.modelContext) private var context
    @State private var zeigeHinzufuegen = false
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(tankvorgaenge) { tanken in
                    TankvorgangZeile(tanken: tanken)
                }
                .onDelete{
                    offsets in for index in offsets{
                        context.delete(tankvorgaenge[index])
                    }
                }
            }
            .overlay{
                if tankvorgaenge.isEmpty {
                    ContentUnavailableView("Noch nichts getankt", systemImage: "fuelpump", description: Text("Tipp auf +, um ein Tankvorgang hinzufügen."))
                }
            }
            .navigationTitle("Verbrauch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Tanken", systemImage: "plus"){
                        zeigeHinzufuegen = true
                    }
                }
            }
            .sheet(isPresented: $zeigeHinzufuegen){
                TankvorgangHinzufuegenView()
            }
        }
    }
}

#Preview {
    ConsumptionView()
        .modelContainer(for: Tankvorgang.self, inMemory: true)
}


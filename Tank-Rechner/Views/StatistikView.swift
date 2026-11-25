//
//  StatistikView.swift
//  Tank-Rechner
//

import SwiftUI
import SwiftData
import Charts

struct StatistikView: View {
    @Binding var Form_Color: Color

    @Query(sort: \Tankvorgang.Datum) private var tankvorgaenge: [Tankvorgang]

    private var statistik: Statistik {
        Statistik(vorgaenge: tankvorgaenge)
    }

    private func euro(_ wert: Double, stellen: Int = 2) -> String {
        String(format: "%.\(stellen)f €", wert)
    }

    private func liter(_ wert: Double) -> String {
        String(format: "%.1f L", wert)
    }

    var body: some View {
        NavigationStack{
            Form{
                if tankvorgaenge.isEmpty {
                    Section{
                        ContentUnavailableView("Noch keine Daten",
                                               systemImage: "chart.bar",
                                               description: Text("Trage Tankvorgänge ein, um Statistiken zu sehen."))
                    }.listRowBackground(Form_Color)
                } else {
                    //Gesamtübersicht
                    Section("Gesamt"){
                        LabeledContent("Gesamtkosten", value: euro(statistik.gesamtKosten))
                        LabeledContent("Gesamtliter", value: liter(statistik.gesamtLiter))
                        LabeledContent("Tankvorgänge", value: "\(statistik.anzahl)")
                        LabeledContent("Dieser Monat", value: euro(statistik.kostenDiesenMonat))
                    }.listRowBackground(Form_Color)

                    //Durchschnittswerte
                    Section("Durchschnitt"){
                        LabeledContent("Literpreis", value: euro(statistik.durchschnittLiterpreis, stellen: 3))
                        LabeledContent("Kosten pro Tanken", value: euro(statistik.durchschnittKostenProTanken))
                        LabeledContent("Menge pro Tanken", value: liter(statistik.durchschnittLiterProTanken))
                    }.listRowBackground(Form_Color)

                    //Preisspanne
                    Section("Literpreis"){
                        LabeledContent("Günstigster", value: euro(statistik.guenstigsterLiterpreis ?? 0, stellen: 3))
                        LabeledContent("Teuerster", value: euro(statistik.teuersterLiterpreis ?? 0, stellen: 3))
                    }.listRowBackground(Form_Color)

                    //Diagramm Kosten pro Monat
                    Section("Kosten pro Monat"){
                        Chart(statistik.monate){ monat in
                            BarMark(x: .value("Monat", monat.monat, unit: .month),
                                    y: .value("Kosten", monat.kosten))
                                .foregroundStyle(.tint)
                                .cornerRadius(4)
                        }
                        .frame(height: 200)
                    }.listRowBackground(Form_Color)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var preview = Color(.systemGray6)
    StatistikView(Form_Color: $preview)
        .modelContainer(for: Tankvorgang.self, inMemory: true)
}

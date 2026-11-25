//
//  StatistikView.swift
//  Tank-Rechner
//

import SwiftUI
import SwiftData
import Charts

struct StatistikView: View {
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
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    //Statistik-Kacheln (wie in VerbrauchView)
                    Section {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                StatistikKarte(titel: "Gesamtkosten", wert: euro(statistik.gesamtKosten), icon: "eurosign.circle.fill", farbe: .blue)
                                StatistikKarte(titel: "Gesamtliter", wert: liter(statistik.gesamtLiter), icon: "fuelpump.fill", farbe: .orange)
                            }
                            HStack(spacing: 12) {
                                StatistikKarte(titel: "Ø Literpreis", wert: euro(statistik.durchschnittLiterpreis, stellen: 3), icon: "chart.line.uptrend.xyaxis", farbe: .purple)
                                StatistikKarte(titel: "Tankvorgänge", wert: "\(statistik.anzahl)", icon: "number.circle.fill", farbe: .green)
                            }
                            HStack(spacing: 12) {
                                StatistikKarte(titel: "Ø pro Tanken", wert: euro(statistik.durchschnittKostenProTanken), icon: "creditcard.fill", farbe: .teal)
                                StatistikKarte(titel: "Ø Menge", wert: liter(statistik.durchschnittLiterProTanken), icon: "drop.fill", farbe: .cyan)
                            }
                            HStack(spacing: 12) {
                                StatistikKarte(titel: "Günstigster Preis", wert: euro(statistik.guenstigsterLiterpreis ?? 0, stellen: 3), icon: "arrow.down.circle.fill", farbe: .green)
                                StatistikKarte(titel: "Teuerster Preis", wert: euro(statistik.teuersterLiterpreis ?? 0, stellen: 3), icon: "arrow.up.circle.fill", farbe: .red)
                            }
                            StatistikKarte(titel: "Dieser Monat", wert: euro(statistik.kostenDiesenMonat), icon: "calendar", farbe: .indigo)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }

                    //Diagramm Kosten pro Monat
                    Section("Kosten pro Monat") {
                        Chart(statistik.monate) { monat in
                            BarMark(x: .value("Monat", monat.monat, unit: .month),
                                    y: .value("Kosten", monat.kosten))
                                .foregroundStyle(.tint)
                                .cornerRadius(4)
                        }
                        .frame(height: 200)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
            .overlay {
                if tankvorgaenge.isEmpty {
                    ContentUnavailableView(
                        "Keine Einträge",
                        systemImage: "chart.bar",
                        description: Text("Trage Tankvorgänge ein, um Statistiken zu sehen.")
                    )
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StatistikView()
        .modelContainer(for: Tankvorgang.self, inMemory: true)
}

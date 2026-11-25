//
//  StatistikView.swift
//  Tank-Rechner
//

import SwiftUI
import SwiftData
import Charts

struct StatistikView: View {
    @Query(sort: \Tankvorgang.Datum) private var tankvorgaenge: [Tankvorgang]

    private var statistik: Statistik { Statistik(vorgaenge: tankvorgaenge) }

    private let spalten = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                if tankvorgaenge.isEmpty {
                    ContentUnavailableView("Noch keine Daten",
                                           systemImage: "chart.bar",
                                           description: Text("Trage Tankvorgänge ein, um Statistiken zu sehen."))
                        .padding(.top, 60)
                } else {
                    VStack(spacing: 16) {
                        LazyVGrid(columns: spalten, spacing: 12) {
                            kachel("Gesamtkosten", euro(statistik.gesamtKosten), "eurosign.circle.fill", .blue)
                            kachel("Gesamtliter", liter(statistik.gesamtLiter), "fuelpump.fill", .orange)
                            kachel("Ø Literpreis", euro(statistik.durchschnittLiterpreis, stellen: 3), "chart.line.uptrend.xyaxis", .purple)
                            kachel("Tankvorgänge", "\(statistik.anzahl)", "number.circle.fill", .green)
                            kachel("Ø pro Tanken", euro(statistik.durchschnittKostenProTanken), "creditcard.fill", .teal)
                            kachel("Ø Menge", liter(statistik.durchschnittLiterProTanken), "drop.fill", .cyan)
                            kachel("Günstigster Preis", euro(statistik.guenstigsterLiterpreis ?? 0, stellen: 3), "arrow.down.circle.fill", .green)
                            kachel("Teuerster Preis", euro(statistik.teuersterLiterpreis ?? 0, stellen: 3), "arrow.up.circle.fill", .red)
                        }

                        kachel("Dieser Monat", euro(statistik.kostenDiesenMonat), "calendar", .indigo)

                        diagramm
                    }
                    .padding()
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Statistik")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var diagramm: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kosten pro Monat").font(.headline)
            Chart(statistik.monate) { m in
                BarMark(x: .value("Monat", m.monat, unit: .month),
                        y: .value("Kosten", m.kosten))
                    .foregroundStyle(.tint)
                    .cornerRadius(4)
            }
            .chartYAxisLabel("€")
            .frame(height: 200)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func kachel(_ titel: String, _ wert: String, _ icon: String, _ farbe: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(farbe)
                .frame(width: 32, height: 32)
                .background(farbe.opacity(0.12))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(titel).font(.caption).foregroundStyle(.secondary)
                Text(wert).font(.subheadline).fontWeight(.bold)
                    .minimumScaleFactor(0.7).lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func euro(_ w: Double, stellen: Int = 2) -> String { String(format: "%.\(stellen)f €", w) }
    private func liter(_ w: Double) -> String { String(format: "%.1f L", w) }
}

#Preview {
    StatistikView().modelContainer(for: Tankvorgang.self, inMemory: true)
}

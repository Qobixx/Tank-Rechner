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
    @State private var ausgewaehlterVorgang: Tankvorgang? = nil
    @State private var zeigeTankstellen = false
    
    // Filter-Zustände
    @State private var alleAnzeigen: Bool = false
    @State private var ausgewaehlterMonat: Int = Calendar.current.component(.month, from: Date())
    @State private var ausgewaehltesJahr: Int = Calendar.current.component(.year, from: Date())
    
    let monate = [
        (1, "Januar"), (2, "Februar"), (3, "März"), (4, "April"),
        (5, "Mai"), (6, "Juni"), (7, "Juli"), (8, "August"),
        (9, "September"), (10, "Oktober"), (11, "November"), (12, "Dezember")
    ]
    
    let jahre = [2026, 2027]
    
    var aktuellerMonatsName: String {
        monate.first(where: { $0.0 == ausgewaehlterMonat })?.1 ?? ""
    }
    
    var gefilterteVorgaenge: [Tankvorgang] {
        if alleAnzeigen {
            return tankvorgaenge
        } else {
            let calendar = Calendar.current
            return tankvorgaenge.filter { vorgang in
                let komponenten = calendar.dateComponents([.year, .month], from: vorgang.Datum)
                return komponenten.year == ausgewaehltesJahr &&
                komponenten.month == ausgewaehlterMonat
            }
        }
    }
    
    var gesamtKosten: Double {
        gefilterteVorgaenge.reduce(0) { $0 + ($1.gesamtpreis) }
    }
    
    var gesamtLiter: Double {
        gefilterteVorgaenge.reduce(0) { $0 + ($1.liter) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 1. Filter-Header
                VStack(spacing: 12) {
                    HStack {
                        Button {
                            if alleAnzeigen {
                                alleAnzeigen = false
                            } else {
                                monatWechseln(um: -1)
                            }
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                alleAnzeigen = true
                            } label: {
                                Label("Alle anzeigen", systemImage: "infinity")
                            }
                            
                            Divider()
                            
                            Picker("Monat", selection: $ausgewaehlterMonat) {
                                ForEach(monate, id: \.0) { nummer, name in
                                    Text(name).tag(nummer)
                                }
                            }
                            Picker("Jahr", selection: $ausgewaehltesJahr) {
                                ForEach(jahre, id: \.self) { jahr in
                                    Text(String(jahr)).tag(jahr)
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: alleAnzeigen ? "infinity" : "calendar")
                                    .foregroundStyle(.tint)
                                Text(alleAnzeigen ? "Alle Einträge" : "\(aktuellerMonatsName) \(String(ausgewaehltesJahr))")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Capsule())
                        }
                        .onChange(of: ausgewaehlterMonat) { alleAnzeigen = false }
                        .onChange(of: ausgewaehltesJahr) { alleAnzeigen = false }
                        
                        Spacer()
                        
                        Button {
                            if alleAnzeigen {
                                alleAnzeigen = false
                            } else {
                                monatWechseln(um: 1)
                            }
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if !alleAnzeigen {
                        Button("Gesamte Historie anzeigen") {
                            withAnimation(.snappy) {
                                alleAnzeigen = true
                            }
                        }
                        .font(.caption)
                        .tint(.secondary)
                    } else {
                        Button("Zum Monatsfilter zurückkehren") {
                            withAnimation(.snappy) {
                                alleAnzeigen = false
                            }
                        }
                        .font(.caption)
                        .tint(.accentColor)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // 2. Statistik-Kacheln (JETZT OHNE TEXT, nur Icon + Wert)
                if !gefilterteVorgaenge.isEmpty {
                    HStack(spacing: 12) {
                        StatistikKarte(
                            wert: String(format: "%.2f €", gesamtKosten),
                            icon: "eurosign.circle.fill",
                            farbe: .blue
                        )
                        StatistikKarte(
                            wert: String(format: "%.1f L", gesamtLiter),
                            icon: "fuelpump.fill",
                            farbe: .orange
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                
                // 3. Liste der Tankvorgänge
                List {
                    ForEach(gefilterteVorgaenge) { tanken in
                        Button {
                            ausgewaehlterVorgang = tanken
                        } label: {
                            TankvorgangZeile(tanken: tanken)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            context.delete(gefilterteVorgaenge[index])
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
            .overlay {
                if gefilterteVorgaenge.isEmpty {
                    ContentUnavailableView(
                        "Keine Einträge",
                        systemImage: "fuelpump",
                        description: Text(alleAnzeigen ? "Es sind noch keine Tankvorgänge vorhanden." : "Für diesen Zeitraum wurden keine Tankvorgänge gefunden.")
                    )
                    .offset(y: 30)
                }
            }
            .navigationTitle("Verbrauch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Tanken", systemImage: "plus") {
                        ausgewaehlterVorgang = nil
                        zeigeHinzufuegen = true
                    }
                    NavigationLink {
                        TankstellenView()
                    } label: {
                        Image(systemName: "fuelpump")
                    }
                }
            }
            .sheet(isPresented: $zeigeHinzufuegen) {
                TankvorgangHinzufuegenView(bestehenderVorgang: nil)
            }
            .sheet(item: $ausgewaehlterVorgang) { vorgang in
                TankvorgangHinzufuegenView(bestehenderVorgang: vorgang)
            }
        }
    }
    
    private func monatWechseln(um schritt: Int) {
        withAnimation(.snappy) {
            var neuerMonat = ausgewaehlterMonat + schritt
            if neuerMonat > 12 {
                neuerMonat = 1
                ausgewaehltesJahr += 1
            } else if neuerMonat < 1 {
                neuerMonat = 12
                ausgewaehltesJahr -= 1
            }
            ausgewaehlterMonat = neuerMonat
        }
    }
}

// Statistik-Karte
struct StatistikKarte: View {
    var titel: String? = nil
    let wert: String
    let icon: String
    let farbe: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(farbe)
                .frame(width: 32, height: 32)
                .background(farbe.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                if let titel {
                    Text(titel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(wert)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VerbrauchView()
        .modelContainer(for: Tankvorgang.self, inMemory: true)
}

//
//  Statistik.swift
//  Tank-Rechner
//

import Foundation

struct MonatsSumme: Identifiable {
    let monat: Date
    let kosten: Double
    let liter: Double
    var id: Date { monat }
}

struct Statistik {
    let vorgaenge: [Tankvorgang]

    var anzahl: Int { vorgaenge.count }
    var gesamtKosten: Double { vorgaenge.reduce(0) { $0 + $1.gesamtpreis } }
    var gesamtLiter: Double { vorgaenge.reduce(0) { $0 + $1.liter } }

    /// Durchschnittlicher Literpreis (gewichtet nach Liter)
    var durchschnittLiterpreis: Double {
        gesamtLiter > 0 ? gesamtKosten / gesamtLiter : 0
    }
    var durchschnittKostenProTanken: Double {
        anzahl > 0 ? gesamtKosten / Double(anzahl) : 0
    }
    var durchschnittLiterProTanken: Double {
        anzahl > 0 ? gesamtLiter / Double(anzahl) : 0
    }
    private var preise: [Double] { vorgaenge.filter { $0.liter > 0 }.map(\.literpreis) }
    var guenstigsterLiterpreis: Double? { preise.min() }
    var teuersterLiterpreis: Double? { preise.max() }

    /// Kosten/Liter je Kalendermonat, aufsteigend (nur Monate mit Einträgen)
    var monate: [MonatsSumme] {
        let cal = Calendar.current
        let gruppen = Dictionary(grouping: vorgaenge) { v in
            cal.date(from: cal.dateComponents([.year, .month], from: v.Datum)) ?? v.Datum
        }
        return gruppen
            .map { MonatsSumme(monat: $0.key,
                               kosten: $0.value.reduce(0) { $0 + $1.gesamtpreis },
                               liter: $0.value.reduce(0) { $0 + $1.liter }) }
            .sorted { $0.monat < $1.monat }
    }

    /// Kosten des aktuellen Monats
    var kostenDiesenMonat: Double {
        monate.first { Calendar.current.isDate($0.monat, equalTo: .now, toGranularity: .month) }?.kosten ?? 0
    }
}

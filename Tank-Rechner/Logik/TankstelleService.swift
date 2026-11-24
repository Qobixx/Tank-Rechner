//
//  TankstellenModel.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 08.11.26.
//

import Foundation

// API Antwort Struktur
struct TankstellenAntwort: Codable {
    let ok: Bool
    let message: String?
    let license: String?
    let data: String?
    let stations: [Tankstelle]?
}

// Einzelne Tankstelle Struktur
struct Tankstelle: Codable, Identifiable {
    let id: String
    let name: String
    let brand: String
    let street: String
    let place: String
    let lat: Double
    let lng: Double
    let dist: Double
    let price: Double?
    let isOpen: Bool
    let e5: Double?
    let e10: Double?
    let diesel: Double?
}

// Globaler API-Key
let tankerKoenigApiKey = "32ce2eee-2d9c-48eb-acc4-19e6bc7360fa"

// Funktion zum Laden der Daten von Tankerkönig
func ladeTankstellenDaten(lat: Double, lng: Double, rad: Int) async throws -> [Tankstelle] {
    let urlString = "https://creativecommons.tankerkoenig.de/json/list.php?lat=\(lat)&lng=\(lng)&rad=\(rad)&sort=dist&type=all&apikey=\(tankerKoenigApiKey)"
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let ergebnis = try decoder.decode(TankstellenAntwort.self, from: data)
    
    if ergebnis.ok, let stations = ergebnis.stations {
        return stations
    } else {
        let msg = ergebnis.message ?? "Unbekannter API-Fehler"
        throw NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
    }
}

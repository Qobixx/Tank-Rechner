//
//  TankstellenView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 07.11.26.
//

import SwiftUI

struct TankstellenView: View {
    @State private var errorMessage: String? = nil
    @StateObject private var standortManager = StandortManager()
    @State private var tankstellenList: [Tankstelle] = []
    @AppStorage("Kraftsoff") private var kraftstoff: KraftstoffArt = .e5
    @AppStorage("Radius") private var rad: Int = 5
    
    // Hält den aktuellen Verzögerungs-Task im Speicher
    @State private var debounceTask: Task<Void, Never>? = nil
    
    enum KraftstoffArt: String, CaseIterable, Identifiable {
        case e5 = "E5"
        case e10 = "E10"
        case diesel = "Diesel"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Der Picker als Auswahlleiste oben
                Picker("Kraftstoff", selection: $kraftstoff) {
                    ForEach(KraftstoffArt.allCases) { kraftstoff in
                        Text(kraftstoff.rawValue).tag(kraftstoff)
                    }
                }
                .pickerStyle(.segmented)
                
                Stepper("\(rad) km", value: $rad, in: 1...25, step: 1)
                    .padding(.horizontal)
                
                // 1. Wenn ein Fehler aufgetreten ist -> Fehleransicht zeigen
                if let error = errorMessage {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Erneut versuchen") {
                            Task {
                                await ladeDaten()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Spacer()
                }
                // 2. Prüfen, ob Standort da ist -> Liste anzeigen
                else if standortManager.userLocation != nil {
                    List(tankstellenList) { tankstelle in
                        let aktuellerPreis = preisFuerKraftstoff(tankstelle: tankstelle)
                        if let preis = aktuellerPreis {
                            TankstellenZeile(TankstelleName: tankstelle.name, preis: preis, strasse: tankstelle.street, ort: tankstelle.place, open: tankstelle.isOpen)
                        } else {
                            Text("Preis derzeit nicht verfügbar").foregroundColor(.gray)
                        }
                    }
                }
                // 3. Solange der Standort noch ermittelt wird
                else {
                    Spacer()
                    ProgressView("Ermittle Standort für Tankstellen...")
                    Spacer()
                }
            }
            .navigationTitle("Tankstellen in der Nähe")
            .task(id: standortManager.userLocation?.latitude) {
                await ladeDaten()
            }
            .onChange(of: rad) { _, _ in
                triggerDebouncedLoad()
            }
            .onChange(of: rad) { _, _ in
                triggerDebouncedLoad()
            }
        }
    }
    
    
    
    
    // Die Debounce-Funktion
        private func triggerDebouncedLoad() {
            // Vorherigen Timer sofort abbrechen, falls der Nutzer weitergeklickt hat
            debounceTask?.cancel()
            
            debounceTask = Task {
                // 0,6 Sekunden (600 Millisekunden) warten, ob der Nutzer noch klickt
                try? await Task.sleep(nanoseconds: 600_000_000)
                
                // Prüfen, ob der Task in der Zwischenzeit abgebrochen wurde
                if Task.isCancelled { return }
                
                // Erst jetzt wird die echte Ladefunktion ausgeführt!
                await ladeDaten()
            }
        }
    
    // Zentrale Lade-Funktion mit funktionierendem try/catch
    private func ladeDaten() async {
        guard let coordinate = standortManager.userLocation else { return }
        
        do {
            let neueStationen = try await ladeTankstellenDaten(lat: coordinate.latitude, lng: coordinate.longitude, rad: rad)
            
            await MainActor.run {
                self.tankstellenList = neueStationen
                if neueStationen.isEmpty {
                    self.errorMessage = "Keine Tankstellen im gewählten Radius gefunden."
                } else {
                    self.errorMessage = nil // Fehler zurücksetzen
                }
            }
        } catch {
            let nsError = error as NSError
            // Planmäßigen Task-Abbruch (-999) ignorieren
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                return
            }
            
            await MainActor.run {
                self.errorMessage = "Server nicht erreichbar oder Netzwerkfehler."
                self.tankstellenList = []
            }
        }
    }
    
    func preisFuerKraftstoff(tankstelle: Tankstelle) -> Double? {
        switch kraftstoff {
        case .e5: return tankstelle.e5
        case .e10: return tankstelle.e10
        case .diesel: return tankstelle.diesel
        }
    }
}

#Preview {
    TankstellenView()
}

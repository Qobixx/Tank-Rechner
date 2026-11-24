//
//  StandortManager.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 07.11.26.
//

import Foundation
import CoreLocation
import Combine

class StandortManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization() // Fragt nach der Erlaubnis
        manager.startUpdatingLocation()         // Startet die Standortsuche
    }

    // Diese Methode wird automatisch aufgerufen, sobald sich der Standort ändert
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    // Überprüft, ob der Nutzer den Zugriff erlaubt hat
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

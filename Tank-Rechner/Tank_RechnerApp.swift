//
//  Tank_RechnerApp.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 14.10.26.
//

import SwiftUI
import SwiftData

@main
struct Tank_RechnerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Tankvorgang.self)
    }
}

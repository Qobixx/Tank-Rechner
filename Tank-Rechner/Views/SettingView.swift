//
//  SettingView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI

struct SettingView: View {
    @Binding var rgbColor: Color
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Allgemein"){
                    ColorPicker("Darstellung",selection: $rgbColor)
                        
                    }
                }
            }
        }
    }


#Preview {
    // Hier erstellen wir einen temporären State für die Vorschau,
    // damit Xcode glücklich ist und die Ansicht anzeigen kann.
    @Previewable @State var previewColor = Color.blue
    SettingView(rgbColor: $previewColor)
}

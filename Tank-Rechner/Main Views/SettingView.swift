//
//  SettingView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI

struct SettingView: View {
    @Binding var rgbColor_HotBar: Color
    @Binding var rgbColor_Form: Color
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Allgemein"){
                    ColorPicker("Darstellung Hot-Bar",selection: $rgbColor_HotBar)
                    ColorPicker("Darstellung Form", selection: $rgbColor_Form)
                        
                    }
                }
            }
        }
    }


#Preview {
    // Hier erstellen wir einen temporären State für die Vorschau,
    // damit Xcode glücklich ist und die Ansicht anzeigen kann.
    @Previewable @State var previewColor = Color.blue
    @Previewable @State var previewColor1 = Color(.systemGray6)
    SettingView(rgbColor_HotBar: $previewColor, rgbColor_Form: $previewColor1)
}

//
//  CalculatorView.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI

struct CalculatorView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("Dein Tankrechner")
                    .font(.largeTitle.bold())
            }
            .navigationTitle("Tankrechner")
            
        }
        
    }
}

#Preview {
    CalculatorView()
}

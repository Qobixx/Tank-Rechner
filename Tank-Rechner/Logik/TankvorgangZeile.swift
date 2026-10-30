//
//  TankvorgangZeile.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 23.10.26.
//

import SwiftUI

struct TankvorgangZeile: View {
    let tanken: Tankvorgang
    
    var body: some View {
        VStack(alignment: .leading, spacing:4){
            HStack{
                Text(tanken.Datum, format: .dateTime.day().month().year())
                    .font(.headline)
                Spacer()
                Text(tanken.gesamtpreis, format: .currency(code: "EUR"))
                    .font(.headline)
            }
            HStack {
                Text("\(tanken.liter, format: .number.precision(.fractionLength(2))) L")
                Spacer()
                Text("\(tanken.literpreis, format: .currency(code: "EUR")) / L")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}
#Preview {
    TankvorgangZeile(tanken: Tankvorgang(liter: 42.5, gesamtpreis: 78.90))
        .padding()
}

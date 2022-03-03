//
//  DetailRow.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import SwiftUI

struct DetailRow: View {
    var heroe: Heroe
    var body: some View {
        VStack {
            
        }
    }
}

struct DetailRow_Previews: PreviewProvider {
    @JSONFile(named: "response")
    static var response: HeroeResponse?

    static var previews: some View {
        response?.data.heroes.first.map { DetailRow(heroe: $0)}
    }
}

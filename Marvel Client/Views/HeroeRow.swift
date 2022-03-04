//
//  HeroeRow.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import SwiftUI
import CachedAsyncImage

struct HeroeRow: View {
    var heroe: HeroeDTO
    var body: some View {

        HStack {
            CachedAsyncImage(url: heroe.imageURL, content: { image in
                image.brandedThmbnail()
            }, placeholder: {
                Image("placeholder").brandedThmbnail()
            })

            VStack(alignment: .leading, spacing: 5) {
                Text(heroe.name)
                    .lineLimit(1)

                if heroe.description != "" {
                    Text(heroe.description)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .font(.footnote)
                } else {
                    Spacer()
                }
            }.padding()

        }
    }
}

extension Image {
    func brandedThmbnail() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 100)
            .cornerRadius(8)
    }
}

struct HeroeRow_Previews: PreviewProvider {
    @JSONFile(named: "response")
    static var response: HeroeResponseDTO?

    static var previews: some View {
        response?.heroes.first.map { HeroeRow(heroe: $0)}
    }
}

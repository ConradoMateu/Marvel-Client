//
//  HeroeRow.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import SwiftUI
import CachedAsyncImage

struct HeroeRow: View {
    var hero: HeroDTO
    var body: some View {

        HStack {
            CachedAsyncImage(url: hero.imageURL, content: { image in
                image.brandedThumbnail()
            }, placeholder: {
                Image("placeholder").brandedThumbnail()
            })

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(hero.name)
                        .lineLimit(1)

                    Spacer()
                    if hero.isFavorite {
                        Image(systemName: "star.fill")
                            .renderingMode(.template)
                            .foregroundColor(.yellow)
                    }

                }

                if hero.description != "" {
                    Text(hero.description)
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
    func brandedThumbnail() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 100)
            .cornerRadius(8)
    }
}

// struct HeroeRow_Previews: PreviewProvider {
//    @JSONFile(named: "response")
//    static var response: HeroeResponseDTO?
//
//    static var previews: some View {
//        response?.heroes.first.map { HeroeRow(heroe: $0)}
//    }
// }

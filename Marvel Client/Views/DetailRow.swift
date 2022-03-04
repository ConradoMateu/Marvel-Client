//
//  DetailRow.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import SwiftUI
import CachedAsyncImage

struct DetailRow: View {
    @State var heroe: Heroe
    var body: some View {
        VStack {
            CachedAsyncImage(url: heroe.imageURL, content: { image in
                image.brandedDetail()
            }, placeholder: {
                Image("placeholder").brandedDetail()
            })

            List(heroe.comics) { comic in
                Text(comic.name)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: triggerFavoriteButton) {
                        Label("Add Favorite Heroe", systemImage: heroe.isFavorite ? "star.fill" : "star")
                    }
                }
            }
        }.padding(.top, 50)
         .navigationTitle(heroe.name)
         .navigationBarTitleDisplayMode(.inline)
    }

    func triggerFavoriteButton() {
        heroe.isFavorite.toggle()
    }
}

extension Image {
    func brandedDetail() -> some View {
        self.resizable()
            .aspectRatio(contentMode: ContentMode.fill)
            .frame(maxWidth: .infinity, maxHeight: 300)
    }
}

struct DetailRow_Previews: PreviewProvider {
    @JSONFile(named: "response")
    static var response: HeroeResponse?

    static var previews: some View {
        response?.heroes.randomElement().map { DetailRow(heroe: $0)}
    }
}

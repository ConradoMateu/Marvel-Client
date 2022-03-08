//
//  DetailRow.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import SwiftUI
import CachedAsyncImage
import UIKit

struct DetailRow: View {
    @State var hero: HeroDTO

    @AppStorage("isDarkMode") private var isDarkMode = false

    var onFavoriteToggled: (HeroDTO) async -> Void

    var body: some View {
        VStack(spacing: 0) {

            CachedAsyncImage(url: hero.imageURL, content: { image in
                image.brandedDetail()
            }, placeholder: {
                Image("placeholder").brandedDetail()
            })

            if hero.comics.isEmpty {
                Spacer()
                Text("This hero has no comics")
                Spacer()
            } else {
                List(hero.comics) { comic in
                    Text(comic.name)
                }

            }
        }.toolbar {
            ToolbarItem {
                Button(action: {
                    hero.isFavorite.toggle()
                    Task {
                        await triggerFavoriteButton()
                    }

                }, label: {

                    Label("Add Favorite Heroe", systemImage: hero.isFavorite ? "star.fill" : "star")
                })
            }
        }
        .navigationTitle(hero.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    func triggerFavoriteButton() async {
        await onFavoriteToggled(hero)
    }
}

extension Image {
    func brandedDetail() -> some View {
        self.resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: 400)
            .clipped()
    }
}

// struct DetailRow_Previews: PreviewProvider {
//    @JSONFile(named: "response")
//    static var response: HeroeResponseDTO?
//
//    static var previews: some View {
//        response?.heroes.randomElement().map { DetailRow(heroe: $0)}
//    }
// }

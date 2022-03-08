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
    @State var heroe: HeroeDTO

    @AppStorage("isDarkMode") private var isDarkMode = false

    var onFavoriteToggled: (HeroeDTO) async -> Void

    var body: some View {
        VStack(spacing: 0) {
                CachedAsyncImage(url: heroe.imageURL, content: { image in
                    image.brandedDetail()
                }, placeholder: {
                    Image("placeholder").brandedDetail()
                })

            if heroe.comics.isEmpty {
                Spacer()
                Text("This hero has no comics")
                Spacer()
            } else {
                List(heroe.comics) { comic in
                    Text(comic.name)
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            heroe.isFavorite.toggle()
                            Task {
                                await triggerFavoriteButton()
                            }

                        }, label: {

                            Label("Add Favorite Heroe", systemImage: heroe.isFavorite ? "star.fill" : "star")
                        })
                    }
                }
            }
        }

         .navigationTitle(heroe.name)
         .padding(.top, 50)
         .navigationBarTitleDisplayMode(.inline)
    }

    func triggerFavoriteButton() async {

            await onFavoriteToggled(heroe)

    }
}

extension Image {
    func brandedDetail() -> some View {
        self.resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: 300)
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

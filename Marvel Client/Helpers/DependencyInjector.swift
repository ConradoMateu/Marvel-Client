//
//  DependencyInjector.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 8/3/22.
//

import Foundation

struct DependencyInjector {
    static func getHeroesRepository() -> HeroesRepository {
        return HeroesRepository(service: HeroeService(), dao: HeroesDao())
    }
}

//
//  HeroeResponse.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 3/3/22.
//

import Foundation
import BackedCodable

/// Using BackedDecodable in order to decode nested JSON with property wrappers
struct HeroeResponseDTO: BackedDecodable {

    /// Default init for Backed Framework
    init(_: DeferredDecoder) {}

    /// Uses custom path for nested JSON
    @Backed(Path("data", "results"))
    var heroes: [HeroDTO]
}

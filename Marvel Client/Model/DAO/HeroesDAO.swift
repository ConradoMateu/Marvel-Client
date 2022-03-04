//
//  HeroesDAO.swift
//  Marvel Client
//
//  Created by Conrado Mateu Gisbert on 4/3/22.
//

//import Foundation
//
//class HeroesDAO: BaseDAO {
//
//    
//    typealias Item = Heroe
//    
//    typealias ItemDTO = HeroeDTO
//    
//    func encode(entity e: HeroeDTO, into obj: inout Heroe) {
//        obj.name = e.name
//        obj.comics = NSSet(arrayLiteral: e.comics)
//        obj.heroeDescription = e.description
//        obj.id = e.id
//        obj.imageURLString = "\(e.imagePath).\(e.imageExtension)"
//        obj.isFavorite = e.isFavorite
//    }
//    
//   func decode(object o: Heroe) -> HeroeDTO {
//       let set = o.comics as? Set<Comic> ?? []
//       let comics =  set.sorted {
//           $0.name ?? "" < $1.name ?? ""
//       }
//
//
//       HeroeDTO(id: o.id, name: o.name ?? <#default value#>, description: o.description, imageURLString: <#T##String#>, comics: <#T##[ComicDTO]#>, isFavorite: <#T##Bool#>)
//    }
//}
//

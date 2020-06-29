//
//  GenreId.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 12/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation

class GenreId{
    
    
    class func configureGenre(genreId:Int)->String{
        switch (genreId) {
        case 28:
            return "Ação"
        case 12:
            return "Aventura"
        case 16:
            return "Animação"
        case 35:
            return "Comédia"
        case 80:
            return "Crime"
        case 99:
            return "Documentário"
        case 18:
            return "Drama"
        case 10751:
            return "Família"
        case 14:
            return "Fantasia"
        case 36:
            return "História"
        case 27:
            return "Terror"
        case 10402:
            return "Música"
        case 9648:
            return "Mistério"
        case 10749:
            return "Romance"
        case 878:
            return "Ficção Científica"
        case 10770:
            return "Cinema Tv"
        case 53:
            return "Thiller"
        case 10752:
            return "Guerra"
        default:
            return "Faroeste"
            
        }
    }
    
}

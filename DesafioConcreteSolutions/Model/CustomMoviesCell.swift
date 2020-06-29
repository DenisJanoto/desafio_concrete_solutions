//
//  CustomCollectionViewCell.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 08/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit
import Kingfisher


class CustomMoviesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageLike: UIImageView!
    @IBOutlet weak var imageViewMovies: UIImageView!
    
    let baseURL = "https://image.tmdb.org/t/p/original"
    var favoritedMovie:[MovieLocalStorage]?
    var compareMovie:Result?
    var isFavorited = false
    
    func prepareCell(movie:Result, favoritesMovie:[MovieLocalStorage]){
        isFavorited = false
        favoritedMovie = favoritesMovie
        compareMovie = movie
        let urlImage = movie.posterPath
        getImage(pathImage: urlImage)
    }
    
    
    
    func getImage(pathImage:String?){
        //verify if current movie is favorited
        for i in 0..<favoritedMovie!.count{
            if compareMovie?.id == favoritedMovie![i].movieId{
                isFavorited = true
                break
            }
        }
        
        if pathImage != nil{
            
            let completeUrl = baseURL+pathImage!
            let url = URL(string: completeUrl)
            imageViewMovies.kf.setImage(with: url)
            imageViewMovies.kf.indicatorType = .activity
            
            //if movie is favorited
            if isFavorited{
                imageLike.image = UIImage(named: "favorite_yellow_icon")
            }else{
                imageLike.image = nil
            }
            
            
        }else{
            imageViewMovies.image = nil
        }
        
    }
}

//
//  CoreData.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 09/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreData{
    var localMovies:MovieLocalStorage?
    var allLocalMovies:[MovieLocalStorage]=[]
    
    //MARK: - save movie in local storage
    func saveFavoritesMovie(movie:Result){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let movies = NSEntityDescription.insertNewObject(forEntityName: "MovieTable", into: context)
        
        movies.setValue(movie.overview, forKey: "movieDescription")
        movies.setValue(movie.posterPath, forKey: "movieImagePath")
        movies.setValue(movie.releaseDate, forKey: "movieYear")
        movies.setValue(movie.title, forKey: "movieTitle")
        
        let movieGenre = String(movie.genreIDS[0])
        movies.setValue(movieGenre, forKey: "movieGenre")
        
        
        let movieId = String(movie.id)
        movies.setValue(movieId, forKey: "movieId")
        
        do {
            try context.save()
            print("data has been saved")
        } catch{
            print("data has not been saved")
        }
    }
    
    //MARK: - save movie in local storage (from favorited screen)
    func saveFavoritesMovie(movie:MovieLocalStorage){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let movies = NSEntityDescription.insertNewObject(forEntityName: "MovieTable", into: context)
        
        movies.setValue(movie.movieDescription, forKey: "movieDescription")
        movies.setValue(movie.movieImagePath, forKey: "movieImagePath")
        movies.setValue(movie.movieYear, forKey: "movieYear")
        movies.setValue(movie.movieTitle, forKey: "movieTitle")
        
        let movieGenre = String(movie.movieGenre)
        movies.setValue(movieGenre, forKey: "movieGenre")
        
        
        let movieId = String(movie.movieId)
        movies.setValue(movieId, forKey: "movieId")
        
        do {
            try context.save()
            print("data has been saved")
        } catch{
            print("data has not been saved")
        }
    }
    
    //MARK: - select all favorites movies from local storage
    func selectAllMovie()->[MovieLocalStorage]{
        
        allLocalMovies = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieTable")
        
        do {
            let movies = try context.fetch(requisition)
            if movies.count > 0{
                for allMovies in movies as! [NSManagedObject]{
                    localMovies = MovieLocalStorage()
                    localMovies?.movieDescription = (allMovies.value(forKey: "movieDescription") as! String)
                    localMovies?.movieImagePath = (allMovies.value(forKey: "movieImagePath") as! String)
                    localMovies?.movieYear = (allMovies.value(forKey: "movieYear") as! String)
                    localMovies?.movieId = Int((allMovies.value(forKey: "movieId") as! String))
                    localMovies?.movieGenre = Int((allMovies.value(forKey: "movieGenre") as! String))
                    localMovies?.movieTitle = (allMovies.value(forKey: "movieTitle") as! String)
                    allLocalMovies.append(localMovies!)
                    
                }
                
            }
        } catch{
            print("Erro ao listar os Dados")
        }
        return allLocalMovies
    }
    
    
    //MARK: - delete favorite movie from local storage
    func deleteMovie(movieId:Int){
        
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieTable")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        let movieIdConverted = String(movieId)
        
        let predicate = NSPredicate(format: "movieId == %@", movieIdConverted)
        fetchRequest.predicate = predicate
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                try context.save()
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
            
            
        }
}

}

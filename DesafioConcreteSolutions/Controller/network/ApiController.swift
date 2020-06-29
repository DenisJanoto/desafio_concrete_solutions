//
//  File.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 08/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation

class ApiController{
    
    private static let session = URLSession.shared
    
    class func loadMovies(page:Int, onComplete:@escaping(GetResponse?)->Void){
        let baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key=b8d58ce4a329a3412ceee4b25eba774f&language=pt-BR&page="
        let pageNumber = String(page)
        let completeUrl = baseUrl+pageNumber
        
        guard let url = URL(string: completeUrl) else {
            onComplete(nil)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil{
                //used to see status code returned from server
                guard let responseServer = response as? HTTPURLResponse else{
                    onComplete(nil)
                    return}
                
                if responseServer.statusCode == 200{
                    guard let responseData = data else{return}
                    
                    do{
                        let movies = try JSONDecoder().decode(GetResponse?.self, from: responseData)
                        onComplete(movies)
                    }catch{
                        print("decode error",error)
                    }
                }else{
                    print("http error status code:",responseServer.statusCode)
                }
            }
        }
        dataTask.resume()
    }
}






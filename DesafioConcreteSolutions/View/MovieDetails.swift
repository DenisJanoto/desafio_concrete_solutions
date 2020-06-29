//
//  MovieDetails.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 08/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit
import CoreData

class MovieDetails: UIViewController,UITabBarControllerDelegate {
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var ImageMovie: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    var movie:Result?
    var selectedFavoriteMovie:MovieLocalStorage?
    var fromFavoritesView:Bool = false
    var favoritedMovie:[MovieLocalStorage]?
    var isFavorited = false
    
    let baseURL = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        isFavorited = false
        verifyIsFavorited()
        configureImage()
        configureLabel()
        configureNavBar()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fromFavoritesView = false
    }
    
    //MARK: - verify if current movie is favorited
    func verifyIsFavorited(){
        
        //like button always started with unlike image
        let image = UIImage(named: "favorite_gray_icon") as UIImage?
        btnLike.setImage(image, for: .normal)
        
        //select local movie in core data
        let coredata = CoreData()
        favoritedMovie = coredata.selectAllMovie()
        
        //verify if movie selected by user contain in all favorited movie
        
        
        
        if fromFavoritesView{
            
            
            
            for i in 0..<favoritedMovie!.count{
                if selectedFavoriteMovie?.movieId == favoritedMovie![i].movieId {
                    isFavorited = true
                    let image = UIImage(named: "favorite_yellow_icon") as UIImage?
                    btnLike.setImage(image, for: .normal)
                    break
                }
            }
            
        }else{
            
            for i in 0..<favoritedMovie!.count{
                if movie?.id == favoritedMovie![i].movieId{
                    isFavorited = true
                    let image = UIImage(named: "favorite_yellow_icon") as UIImage?
                    btnLike.setImage(image, for: .normal)
                    break
                }
            }
        }
    }
    
    //MARK: - configure imageview
    func configureImage(){
        if fromFavoritesView{
            setImage(pathImage: (selectedFavoriteMovie?.movieImagePath)!)
        }else{
            
            setImage(pathImage: (movie?.posterPath)!)
            
        }
    }
    
    //MARK: - configure movie info in labels
    func configureLabel(){
        
        //configure title
        if fromFavoritesView{
            movieTitle.text = selectedFavoriteMovie?.movieTitle
        }else{
            movieTitle.text = movie?.title
        }
        
        //configure genre
        if fromFavoritesView{
            //configure genre by id
            movieGenre.text = GenreId.configureGenre(genreId: (selectedFavoriteMovie?.movieGenre)!)
        }else{
            //configure genre by id
            movieGenre.text = GenreId.configureGenre(genreId: (movie?.genreIDS[0])!)
        }
        
        
        //configure description
        if fromFavoritesView{
            if selectedFavoriteMovie?.movieDescription == ""{
                movieDescription.text = "Descrição Indisponível"
            }else{
                movieDescription.textAlignment = NSTextAlignment.justified
                movieDescription.text = selectedFavoriteMovie?.movieDescription
            }
        }else{
            if movie?.overview == ""{
                movieDescription.text = "Descrição Indisponível"
            }else{
                movieDescription.textAlignment = NSTextAlignment.justified
                movieDescription.text = movie?.overview
            }
        }
        
        //configure date
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat =  "yyyy-MM-dd"
        
        if fromFavoritesView{
            let date = dateFmt.date(from: (selectedFavoriteMovie?.movieYear)!)
            //convert date in brazillian pattern
            if let data = date{
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.locale = Locale(identifier: "pt_BR")
                movieYear.text = formatter.string(from: data)
            }
        }else{
            let date = dateFmt.date(from: (movie?.releaseDate) as! String)
            //convert date in brazillian pattern
            if let data = date{
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.locale = Locale(identifier: "pt_BR")
                movieYear.text = formatter.string(from: data)
            }
        }
        movieTitle.textColor = UIColor.white
        movieYear.textColor = UIColor.white
        movieGenre.textColor = UIColor.white
        movieDescription.textColor = UIColor.white
        movieDescription.backgroundColor = UIColor(named: "backGroundColor")
        
    }
    //MARK: - configure navbar
    func configureNavBar(){
        //show navibar
        navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //change background color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
        //change title color
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - configure view
    func configureView(){
        view.backgroundColor = UIColor(named: "backGroundColor")
        
    }
    //MARK: - like button
    
    @IBAction func likeButton(_ sender: Any) {
        
        if isFavorited{
            //yellow heart button image
            let image = UIImage(named: "favorite_gray_icon") as UIImage?
            btnLike.setImage(image, for: .normal)
            
            //delete favorite movie in local storage
            let coredata = CoreData()
            if fromFavoritesView{
                coredata.deleteMovie(movieId: (selectedFavoriteMovie?.movieId)!)
                
            }else{
                coredata.deleteMovie(movieId: movie!.id)
                
            }
            
            
        }else{
            
            //lightgray heart button image
            let image = UIImage(named: "favorite_yellow_icon") as UIImage?
            btnLike.setImage(image, for: .normal)
            
            //save favorite movie in local storage
            let coredata = CoreData()
            
            if fromFavoritesView{
                coredata.saveFavoritesMovie(movie: selectedFavoriteMovie!)
                
            }else{
                coredata.saveFavoritesMovie(movie: movie!)
            }
            
        }
    }
    
    
    //MARK: - kingfisher
    func setImage(pathImage:String){
        if pathImage != nil{
            let completeUrl = baseURL+pathImage
            let url = URL(string: completeUrl)
            ImageMovie.kf.setImage(with: url)
            ImageMovie.kf.indicatorType = .activity
            ImageMovie.layer.cornerRadius = ImageMovie.frame.size.height/2 //Deixa imagem redonda
            
        }else{
            ImageMovie.image = nil
        }
    }
    
    
}

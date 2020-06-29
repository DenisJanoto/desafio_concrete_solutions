//
//  InitialScreen.swift
//  
//
//  Created by Denis Janoto on 08/06/20.
//

import UIKit
import CoreData
class InitialScreen: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var collection_view: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var pageNumber:Int = 0
    var returnedMovies:[Result]=[]
    var filteredData:[Result]=[]
    var selectedMovie:Result!
    var allMovies:[MovieLocalStorage]=[]
    
    
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DELETE ALL COREDATA DATA
//                                                   let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
//                                                   let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
//                                                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieTable")
//                                                   fetchRequest.returnsObjectsAsFaults = false
//
//                                                   do
//                                                   {
//                                                       let results = try context.fetch(fetchRequest)
//                                                       for managedObject in results
//                                                       {
//                                                           let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                                                           context.delete(managedObjectData)
//                                                           try context.save()
//                                                       }
//                                                   } catch let error as NSError {
//                                                       print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
//                                                   }
         
        apiServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collection_view.reloadData()
        let coredata = CoreData()
        self.allMovies = coredata.selectAllMovie()
        
        configNavBar()
        configColectionView()
        configStatusBar()
        configTabBar()
        configSearchBar()
    }

    
    //MARK: - call api services
    func apiServices(){
        pageNumber+=1
        ApiController.loadMovies(page: pageNumber) { (response) in
            self.returnedMovies += response!.results
            
            DispatchQueue.main.async {
                self.collection_view.reloadData()
                
            }
        }
    }
    
    //MARK: - config navbar
    func configNavBar(){
        
        //hide navibar when scrolldown
        navigationController?.hidesBarsOnSwipe = true
        
        //change background color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
        //change title color
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - config searcbar
    func configSearchBar(){
        //general configs
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Procurar Filmes"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        navigationItem.searchController = searchController
        
    }
    
    //MARK: - search movies from searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = returnedMovies //filteredData always have all movies data
        
        //if searchbar is empity, all data is loaded
        if searchText.isEmpty{
            searchActive = false
            collection_view.reloadData()
        }else{
            searchActive=true
            filteredData = filteredData.filter({(dados) -> Bool in
                let x = dados.title.range(of:searchText,options: .caseInsensitive) //filtered data by movie title
                return x != nil
            })
            collection_view.reloadData()
        }
    }
    
    //MARK: - search bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //show all movies
        searchActive = false
        collection_view.reloadData()
    }
    
    //MARK: - config colectionview
    func configColectionView(){
        
        collection_view.delegate = self
        collection_view.dataSource = self
        
        collection_view.backgroundColor = UIColor(named: "backGroundColor")
        
    }
    
    //MARK: - config statusbar
    func configStatusBar(){
        
        //change text color to white
        navigationController?.navigationBar.barStyle = .black
        setNeedsStatusBarAppearanceUpdate()
        var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent //Configurar para branco
            
        }
        
    }
    
    
    
    //MARK: - config tabbar
    func configTabBar(){
        tabBarController?.tabBar.isTranslucent = false
        tabBarController!.tabBar.barTintColor =  UIColor(named: "backGroundColor")
        
    }
    
    
    //MARK:- like button
    @IBAction func btnLike(_ sender: Any) {
        
    }
    
    
    //MARK: - selected collectionview cell (call details screen movie)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchActive{
            selectedMovie = filteredData[indexPath.row]
        }else{
            selectedMovie = returnedMovies[indexPath.row]
        }
        
        performSegue(withIdentifier: "MovieDetailsSegue", sender: nil)
    }
    
    //MARK: - collectionview build
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive{
            return filteredData.count
        }else{
            return returnedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! CustomMoviesCell
        
        
        if searchActive{
            cell.prepareCell(movie: filteredData[indexPath.row], favoritesMovie: allMovies)
        }else{
            cell.prepareCell(movie: returnedMovies[indexPath.row], favoritesMovie: allMovies)
            
        }
        return cell
    }
    
    //send data do details viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailsSegue"{
            let destiny = segue.destination as! MovieDetails
            destiny.movie = selectedMovie
//            destiny.favoritedMovie = allMovies
        }
    }
    
    //MARK: - infinity scroll
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == returnedMovies.count - 10{
            
            apiServices()
            
        }
    }
}


//
//  FavoritesScreen.swift
//  
//
//  Created by Denis Janoto on 08/06/20.
//

import UIKit
import CoreData

class FavoritesScreen: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var table_view: UITableView!
    
    var allMovies:[MovieLocalStorage]=[]
    var allTitle_and_Genre:[MovieLocalStorage]=[]
    var selectedMovie:MovieLocalStorage?
    let labelNoFavoritedMovie = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    
    //CONTINUAÇÃO: ERRO, PROVAVELMENTE N ESTA ADICIONANOD NO PADRAO DO ARRAY ABAIXO (VERIFICAR METODO GETGENRE)
    
    var MovieData = [
        ["title": "Jason Bourne","genre": "Ação"],
        ["title": "filme de drama","genre": "Drama"],
    ]
    
    enum TableSection: Int {
        case Ação = 0, Comédia, Drama,Aventura, Animação,Crime,Documentário,Família,Fantasia,História,
        Terror, Música,Mistério,Romance,FicçãoCientifica,CinemaTv,Thiller,Guerra,Faroeste,total
    }
    
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 25
    
    
    // Data variable to track our sorted data.
    var data = [TableSection: [[String: String]]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ADD NEW ELEMENT TO ARRAY AND THE CODE ADD AUTOMATICALLY IN SECTION DEPENDING YOUR GENRE
        //        MovieData.append(["title": "denis", "cast": "Seth Rogen, Rose Byrne", "genre": "Drama"])
        //        MovieData.append(["title" : "\(allMovies.)"])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configTableView()
        configStatusBar()
        configureNavBar()
        
        MovieData = []
        getAllGenre()
        sortData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table_view.reloadData()
    }
    
    func sortData() {
        data[.Ação] = MovieData.filter({ $0["genre"] == "Ação" })
        data[.Aventura] = MovieData.filter({ $0["genre"] == "Aventura" })
        data[.Animação] = MovieData.filter({ $0["genre"] == "Animação" })
        data[.Comédia] = MovieData.filter({ $0["genre"] == "Comédia" })
        data[.Crime] = MovieData.filter({ $0["genre"] == "Crime" })
        data[.Documentário] = MovieData.filter({ $0["genre"] == "Documentário" })
        data[.Drama] = MovieData.filter({ $0["genre"] == "Drama" })
        data[.Família] = MovieData.filter({ $0["genre"] == "Família" })
        data[.Fantasia] = MovieData.filter({ $0["genre"] == "Fantasia" })
        data[.História] = MovieData.filter({ $0["genre"] == "História" })
        data[.Terror] = MovieData.filter({ $0["genre"] == "Terror" })
        data[.Música] = MovieData.filter({ $0["genre"] == "Música" })
        data[.Mistério] = MovieData.filter({ $0["genre"] == "Mistério" })
        data[.Romance] = MovieData.filter({ $0["genre"] == "Romance" })
        data[.FicçãoCientifica] = MovieData.filter({ $0["genre"] == "Ficção Científica" })
        data[.CinemaTv] = MovieData.filter({ $0["genre"] == "Cinema Tv" })
        data[.Thiller] = MovieData.filter({ $0["genre"] == "Thiller" })
        data[.Guerra] = MovieData.filter({ $0["genre"] == "Guerra" })
        data[.Faroeste] = MovieData.filter({ $0["genre"] == "Faroeste" })
    }
    
    
    
    //MARK: - config tableview
    func configTableView(){
        //core data select
        let coredata = CoreData()
        allMovies = coredata.selectAllMovie()
        
        //add programmatically label
        labelNoFavoritedMovie.font = UIFont.boldSystemFont(ofSize: 20)
        labelNoFavoritedMovie.textAlignment = .center
        labelNoFavoritedMovie.center = self.table_view.center
        labelNoFavoritedMovie.text = "Você não possui favoritos"
        labelNoFavoritedMovie.textColor = UIColor.white
        labelNoFavoritedMovie.adjustsFontSizeToFitWidth = true
        
        
        
        self.table_view.addSubview(labelNoFavoritedMovie)
        table_view.backgroundColor = UIColor(named: "backGroundColor")
    }
    
    
    //MARK: - config statusbar
    func configStatusBar(){
        //change statusbar text color to white
        navigationController?.navigationBar.barStyle = .black
        setNeedsStatusBarAppearanceUpdate()
        var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent //Configurar para branco
        }
    }
    
    //MARK: - config navbar
    func configureNavBar(){
        
        //hide navibar when scrolldown
        navigationController?.hidesBarsOnSwipe = true
        
        //change background color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
    }
    
    
    //MARK: - delete movie by swiping side
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //delete favorite movie in local storage
        let coredata = CoreData()
        if let tableSection = TableSection(rawValue: indexPath.section), let movie = data[tableSection]?[indexPath.row] {
            
            let x = Int(movie["id"]!)
            coredata.deleteMovie(movieId: x!)
            
        }
        
        allMovies.remove(at: indexPath.row)
        MovieData.remove(at: indexPath.row)
        getAllGenre()
        data=[:]
        sortData()
        table_view.reloadData()
    }
    
    
    
    //MARK: - get all genre to build sections
    func getAllGenre(){
        MovieData=[]
        let coredata = CoreData()
        allMovies = coredata.selectAllMovie()
        for i in 0..<allMovies.count{
            MovieData.append(["title" : "\(allMovies[i].movieTitle ?? "")","genre" : "\(GenreId.configureGenre(genreId: allMovies[i].movieGenre))","id" : "\(allMovies[i].movieId ?? 0)","imagePath":"\(allMovies[i].movieImagePath ?? "")","movieYear":allMovies[i].movieYear ?? ""])
        }
    }
    
    //MARK: - build tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allMovies.count > 0{
            labelNoFavoritedMovie.isHidden = true
            
            if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection] {
                return movieData.count
            }
            return 0
        }else{
            labelNoFavoritedMovie.isHidden = false
            
            if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection] {
                return movieData.count
            }
            return 0
        }
    }
    
    //section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // If we wanted to always show a section header regardless of whether or not there were rows in it,
        // then uncomment this line below:
        //return SectionHeaderHeight
        
        // First check if there is a valid section of table.
        // Then we check that for the section there is more than 1 row.
        if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection], movieData.count > 0 {
            return SectionHeaderHeight
        }
        return 0
    }
    
    
    //section title
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        //view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        view.backgroundColor = UIColor(named: "mainColor")
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.center.x = self.view.center.x
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .Ação:
                label.text = "Ação"
            case .Aventura:
                label.text = "Aventura"
            case .Animação:
                label.text = "Animação"
            case .Comédia:
                label.text = "Comédia"
            case .Crime:
                label.text = "Crime"
            case .Documentário:
                label.text = "Documentário"
            case .Drama:
                label.text = "Drama"
            case .Família:
                label.text = "Família"
            case .Fantasia:
                label.text = "Fantasia"
            case .História:
                label.text = "História"
            case .Terror:
                label.text = "Terror"
            case .Música:
                label.text = "Música"
            case .Mistério:
                label.text = "Mistério"
            case .Romance:
                label.text = "Romance"
            case .FicçãoCientifica:
                label.text = "Ficção Cientifica"
            case .CinemaTv:
                label.text = "CinemaTv"
            case .Thiller:
                label.text = "Thiller"
            case .Guerra:
                label.text = "Guerra"
            case .Faroeste:
                label.text = "Faroeste"
            default:
                label.text = ""
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieFavoritesCell", for: indexPath) as! CustomFavoritesCell
        
        cell.contentView.backgroundColor = UIColor(named: "backGroundColor")
        
        if let tableSection = TableSection(rawValue: indexPath.section), let movie = data[tableSection]?[indexPath.row] {
            
            cell.prepareCell(movie: movie)
        }
        
        return cell
    }
    
    
    
    //MARK: - cell clicked
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        selectedMovie = allMovies[indexPath.row]
    //        performSegue(withIdentifier: "movieDetailsSegue", sender: nil)
    //    }
    //
    // MARK: - send data to movie detais view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailsSegue"{
            let destiny = segue.destination as! MovieDetails
            destiny.selectedFavoriteMovie = selectedMovie
            destiny.fromFavoritesView = true
        }
    }
}

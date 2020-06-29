//
//  CustomFavoritesCell.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 08/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit

class CustomFavoritesCell: UITableViewCell {
    
    @IBOutlet weak var ImageMovie: UIImageView!
    @IBOutlet weak var DescriptionMovie: UILabel!
    @IBOutlet weak var YearMovie: UILabel!
    
    let baseURL = "https://image.tmdb.org/t/p/original"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func prepareCell(movie: [String : String]){
        
        //change label color
        DescriptionMovie.textColor = .white
       
        DescriptionMovie.text = movie["title"]
  
        //get date
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat =  "yyyy-MM-dd"
        let date = dateFmt.date(from: movie["movieYear"]!)
        
        //convert date in brazillian pattern
        if let data = date{
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "pt_BR")
            YearMovie.text = formatter.string(from: data)
        }
        YearMovie.textColor = .white
        
        setImage(pathImage: movie["imagePath"]!)
    }
    

    
    
    
    
    
    
    //MARK: - Kingfisher
    func setImage(pathImage:String){
        if pathImage != nil{
            let completeUrl = baseURL+pathImage
            let url = URL(string: completeUrl)
            ImageMovie.kf.setImage(with: url)
            ImageMovie.kf.indicatorType = .activity
        }else{
            ImageMovie.image = nil
        }
        
        
    }
}

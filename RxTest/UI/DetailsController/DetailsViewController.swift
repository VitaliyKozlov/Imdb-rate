//
//  DetailsViewController.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 12/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class DetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var addRemoveButton: UIBarButtonItem!
   
    var remove = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let favoritesFilms = realm.objects(FilmForRealm.self)
        for item in favoritesFilms {
            if item.id == selectedFilm.id {
                addRemoveButton.title = "Remove"
                addRemoveButton.tintColor = UIColor.red
                remove = true
            }
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-mm-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        if let date = dateFormatterGet.date(from: selectedFilm.release_date) {
            let dateForPrint = dateFormatterPrint.string(from: date)
            titleLabel.text = "\(count). \(selectedFilm.title) (\(dateForPrint))"
            
        } else {
            let dateForPrint = "Error Date"
            titleLabel.text = "\(count). \(selectedFilm.title) (\(dateForPrint))"
            
        }
        
         rateLabel.text = "Rating: \(selectedFilm.vote_average)"
        
         descriptionTextView.text = selectedFilm.overview
        
        let url = URL (string:  "https://image.tmdb.org/t/p/w500/\(selectedFilm.poster_path)")
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "noImage"), options: [.processor(processor)])
        
        selectedFilm.image = imageForRealm(url: "https://image.tmdb.org/t/p/w500/\(selectedFilm.poster_path)")
        
    }
    

    @IBAction func addRemoveButton(_ sender: UIBarButtonItem) {
        if remove {
            let realm = try! Realm()
            let objectsToDelete = realm.objects(FilmForRealm.self).filter("id == %@", selectedFilm.id)
            print (objectsToDelete)
            try! realm.write {
                realm.delete(objectsToDelete)
                remove = false
                addRemoveButton.title = "Add"
                addRemoveButton.tintColor = UIColor.blue
            }
        } else {
            let realm = try! Realm()
            try! realm.write {
                realm.add(selectedFilm, update: true)
                remove = true
                addRemoveButton.title = "Remove"
                addRemoveButton.tintColor = UIColor.red
        }
            
            
        
        }
    }
    
    func imageForRealm (url: String) -> NSData? {
        guard let urlForData = URL (string:  url) else {return nil}
        return  NSData(contentsOf: urlForData)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


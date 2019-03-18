//
//  DataModel.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 11/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import Foundation
import RealmSwift

struct TopRated : Codable{
    var page = 0
    var total_results  = 0
    var total_pages  = 0
    var results = [Film]()
    
}

struct Film : Codable{
    var id  = 0
    var title = ""
    var vote_average : Double = 0
    var poster_path = ""
    var overview = ""
    var release_date = ""
    
}

class FilmForRealm : Object {
    @objc dynamic var position = 0
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var vote_average : Double = 0
    @objc dynamic var poster_path = ""
    @objc dynamic var overview = ""
    @objc dynamic var release_date = ""
    @objc dynamic var image : NSData? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

var topRated = TopRated()
var selectedFilm = FilmForRealm()

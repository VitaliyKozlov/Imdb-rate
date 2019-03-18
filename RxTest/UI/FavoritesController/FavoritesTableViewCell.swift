//
//  FavoritesTableViewCell.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 13/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure (element : FilmForRealm) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-mm-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        if let date = dateFormatterGet.date(from: element.release_date) {
            let dateForPrint = dateFormatterPrint.string(from: date)
            titleLabel.text = "\(element.position). \(element.title) (\(dateForPrint))"
            
        } else {
            let dateForPrint = "Error Date"
            titleLabel.text = "\(element.position). \(element.title) (\(dateForPrint))"
            
        }
        
        
        rateLabel.text = "Rating: \(element.vote_average)"
        
        descriptionTextView.text = element.overview
        
        posterImage.kf.indicatorType = .activity
        guard let image = UIImage(data: element.image! as Data) else {return}
        posterImage.kf.base.image = image
       
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

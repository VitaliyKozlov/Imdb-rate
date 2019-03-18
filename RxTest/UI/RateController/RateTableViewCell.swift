//
//  RateTableViewCell.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 11/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit
import Kingfisher

class RateTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
        
        detailsLabel.text = element.overview
        let url = URL (string:  "https://image.tmdb.org/t/p/w500/\(element.poster_path)")
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        posterImage.kf.indicatorType = .activity
        posterImage.kf.setImage(with: url, placeholder: UIImage(named: "noImage"), options: [.processor(processor)])
        
        
    }

}

//
//  ViewController.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 09/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

var count = 1
var position = 1
class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let provider = MoyaProvider<ServerApi>()
    var page = 1
    let dataRx = Variable<[FilmForRealm]>([])
    var films = [FilmForRealm]()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        requestMoya(page: page)
        
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else {return}
                if indexPath.row == 19 * self.page{
                    self.page = self.page + 1
                    self.requestMoya(page: self.page)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FilmForRealm.self).subscribe {
            print ("Test\($0)")
                guard let tempSelectedFilm = $0.element else {return}
                selectedFilm = tempSelectedFilm
                self.performSegue(withIdentifier: "detailsSegue", sender: nil)
            }
            .disposed(by: disposeBag)
    }
   
    func requestMoya (page: Int)  {
        provider.request(.topRated(apiKey: apiKey, page: page)) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let temp = try JSONDecoder().decode(TopRated.self, from: data)
                    let tempFilms = temp.results
                    var films = [FilmForRealm]()
                    for item in tempFilms {
                        let itemRealm = FilmForRealm()
                        itemRealm.id = item.id
                        itemRealm.overview = item.overview
                        itemRealm.position = position
                        itemRealm.poster_path = item.poster_path
                        itemRealm.release_date = item.release_date
                        itemRealm.title = item.title
                        itemRealm.vote_average = item.vote_average
                        position = position + 1
                        films.append(itemRealm)
                    }
                    
                    self.dataRx.value.append(contentsOf: films)
                } catch {
                    print (error)
                }
            case .failure:
                self.showAlertNetwork()
                
            }
    }
    }
    func bindData () {
        dataRx
            .asDriver()
            .drive (tableView.rx.items(cellIdentifier: "cell", cellType: RateTableViewCell.self)) { (row, element, cell) in
                cell.configure(element: element)
            }.disposed (by: disposeBag)
    }
}

extension ViewController {
    func showAlertNetwork () {
        let alert = UIAlertController(title: "Внимание!", message: "Проверьте соединение с Интернетом", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    

}

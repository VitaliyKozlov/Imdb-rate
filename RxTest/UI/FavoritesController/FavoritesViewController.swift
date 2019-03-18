//
//  FavoritesViewController.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 13/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import RealmSwift
import RxRealm

class FavoritesViewController: UIViewController {
    fileprivate var favoritesFilms: Results<FilmForRealm>?
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        favoritesFilms = realm.objects(FilmForRealm.self)
        let dataRx = Variable<Results<FilmForRealm>>(favoritesFilms!)
        bindData(dataRx: dataRx)
        Observable.changeset(from: favoritesFilms!)
            .subscribe(onNext: { [weak self] results, changes in
                guard let tableView = self?.tableView else { return }
                
                if let changes = changes {
                    tableView.beginUpdates()
                    tableView.insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) },
                                         with: .automatic)
                    tableView.endUpdates()
                } else {
                    tableView.reloadData()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func bindData (dataRx: Variable<Results<FilmForRealm>>) {
        dataRx
            .asDriver()
            .drive (tableView.rx.items(cellIdentifier: "cell", cellType: FavoritesTableViewCell.self)) { (row, element, cell) in
                cell.configure(element: element)
            }.disposed (by: disposeBag)
    }
    
}

//
//  SimpleListViewController.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/6/4.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.register(UINib(nibName: "DemoListCell", bundle: nil), forCellReuseIdentifier: "DemoListCell")
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "DemoListCell", cellType: DemoListCell.self)) { (row, element, cell) in
                cell.titleLabel.text = "element is \(element) in row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
                DefaultWireframe.presentAlert("Tapped `\(value)`")
            })
            .disposed(by: disposeBag)
     
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

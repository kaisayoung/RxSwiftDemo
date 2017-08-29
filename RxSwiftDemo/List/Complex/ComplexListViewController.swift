//
//  ComplexListViewController.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/8/19.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ComplexListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let dataSource = self.dataSource
        
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Second section", items: [
                1.0,
                2.0,
                3.0,
                4.0
                ]),
            SectionModel(model: "Third section", items: [
                1.0,
                2.0,
                3.0,
                4.0,
                5.0
                ]),
            SectionModel(model: "Forth section", items: [
                1.0,
                2.0,
                3.0,
                4.0,
                5.0,
                6.0
                ])
            ])
        
        tableView.register(UINib(nibName: "DemoListCell", bundle: nil), forCellReuseIdentifier: "DemoListCell")
        
        // 通过一个block去赋值
        dataSource.configureCell = { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "DemoListCell") as! DemoListCell
            cell.titleLabel.text = "element is \(element) in row \(indexPath.row)"
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
                DefaultWireframe.presentAlert("Tapped on `\(model)` in \(indexPath)")
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

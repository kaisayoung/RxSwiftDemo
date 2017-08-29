//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/9.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onObservableSignInButtonTapped(_ sender: Any) {
        
        let signInVC1 = SignInViewController1()
        
        self.navigationController?.pushViewController(signInVC1, animated: true)
    }
    
    @IBAction func onDriverSignInButtonTapped(_ sender: Any) {
        
        let signInVC2 = SignInViewController2()
        
        self.navigationController?.pushViewController(signInVC2, animated: true)
    }
 
    @IBAction func onSimpleListButtonTapped(_ sender: Any) {
        
        let simpleListVC = SimpleListViewController()
        
        self.navigationController?.pushViewController(simpleListVC, animated: true)
    }


    @IBAction func onComplexListButtonTapped(_ sender: Any) {
        
        let complexListVC = ComplexListViewController()
        
        self.navigationController?.pushViewController(complexListVC, animated: true)
        
    }
}


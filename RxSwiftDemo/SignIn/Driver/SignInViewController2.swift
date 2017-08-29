//
//  SignInViewController2.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/12.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KRProgressHUD

class SignInViewController2: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "DriverSignIn"
        
        customizeTF()
        
        let viewModel = SignInViewModel2(
            input: (
                username: usernameTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                signInTap: signInButton.rx.tap.asDriver()
            ),
            dependency: (
                validator: ValidationService.shareInstance(),
                fakeAPI: FakeAPIService.shareInstance()
            )
        )
        
        signInButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.validatedUsername
            .drive(usernameValidationLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordValidationLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.signInEnable
            .drive(onNext: { [weak self] bool in
                self?.signInButton.isEnabled = bool
                self?.signInButton.alpha = bool ? 1.0 : 0.5
            })
            .addDisposableTo(disposeBag)
        
        viewModel.signingIn
            .drive(indicatorView.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
        viewModel.signInResult
            .drive(onNext: { success in
                success ? KRProgressHUD.showSuccess() : KRProgressHUD.showError()
            })
            .addDisposableTo(disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .addDisposableTo(disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

}

extension SignInViewController2 {
    func customizeTF() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
    }
}

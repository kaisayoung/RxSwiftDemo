//
//  SignInViewController1.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/12.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KRProgressHUD

class SignInViewController1: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "ObservableSignIn"
        
        customizeTF()
        
        let viewModel = SignInViewModel1(
            input: (
                username: usernameTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable(),
                signInTap: signInButton.rx.tap.asObservable()
            ),
            dependency: (
                validator: ValidationService.shareInstance(),
                fakeAPI: FakeAPIService.shareInstance()
            )
        )
        
        signInButton.rx.tap//.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.validatedUsername
            .bind(to:usernameValidationLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validatedPassword
            .bind(to:passwordValidationLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.signInEnable
            .subscribe(onNext: { [weak self] bool in
                self?.signInButton.isEnabled = bool
                self?.signInButton.alpha = bool ? 1.0 : 0.5
            })
            .addDisposableTo(disposeBag)
        
        viewModel.signingIn
            .bind(to:indicatorView.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
        viewModel.signInResult
            .subscribe(onNext: { success in
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

extension SignInViewController1 {
    func customizeTF() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
    }
}

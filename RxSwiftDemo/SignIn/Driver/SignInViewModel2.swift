//
//  SignInViewModel2.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/12.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel2 {
    
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    
    let signInEnable: Driver<Bool>
    let signingIn: Driver<Bool>
    let signInResult: Driver<Bool>
    
    init(
        input: (
            username: Driver<String>,
            password: Driver<String>,
            signInTap: Driver<Void>
        ),
        dependency: (
            validator: ValidationProtocol,
            fakeAPI: APIProtocol
        )
    ) {
        
        let API = dependency.fakeAPI
        let validator = dependency.validator
        
        validatedUsername = input.username
            .map {
                usernameString in
                return validator.validateUsername(usernameString)
            }
        
        validatedPassword = input.password
            .map {
                passwordString in
                return validator.validatePassword(passwordString)
            }
        
        let signInIndicator = ActivityIndicator()
        self.signingIn = signInIndicator.asDriver()
        
        signInEnable = Driver
            .combineLatest(
                validatedUsername,
                validatedPassword,
                signingIn
            ) {
                username, password, signingIn in
                return username.isValid && password.isValid && !signingIn
            }
            .distinctUntilChanged()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
        
        signInResult = input.signInTap
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest({ (username, password) in
                return API.signIn(username, password: password)
                    .trackActivity(signInIndicator)
                    .asDriver(onErrorJustReturn: false)
            })
        
    }
    
}

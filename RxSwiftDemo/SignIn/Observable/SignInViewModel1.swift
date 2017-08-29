//
//  SignInViewModel1.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/12.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel1 {
    
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    
    let signInEnable: Observable<Bool>
    let signingIn: Observable<Bool>
    let signInResult: Observable<Bool>
    
    init(
        input: (
            username: Observable<String>,
            password: Observable<String>,
            signInTap: Observable<Void>
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
            .shareReplay(1)
        
        validatedPassword = input.password
            .map {
                passwordString in
                return validator.validatePassword(passwordString)
            }
            .shareReplay(1)
        
        let signInIndicator = ActivityIndicator()
        self.signingIn = signInIndicator.asObservable()
        
        signInEnable = Observable
            .combineLatest(
                validatedUsername,
                validatedPassword,
                signingIn
            ) {
                username, password, signingIn in
                return username.isValid && password.isValid && !signingIn
            }
            .distinctUntilChanged()
            .shareReplay(1)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { ($0, $1) }
        
        signInResult = input.signInTap
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest({ (username, password) in
                return API.signIn(username, password: password)
                    .trackActivity(signInIndicator)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
            })
            .shareReplay(1)
    }
    
}


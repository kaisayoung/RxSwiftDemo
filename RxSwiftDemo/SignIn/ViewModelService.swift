//
//  ViewModelService.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/12.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import Foundation
import RxSwift

class ValidationService: ValidationProtocol {
    
    static let instance = ValidationService()
    
    class func shareInstance() -> ValidationService {
        return self.instance
    }
    
    let minUsernameCount = 6
    let maxUsernameCount = 20
    
    let minPasswordCount = 6
    let maxPasswordCount = 20
    
    func validateUsername(_ username: String) -> ValidationResult {
        let numberOfCharacters = username.characters.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minUsernameCount || numberOfCharacters > maxUsernameCount {
            return .failed(message: "username must \(minUsernameCount) to \(maxUsernameCount) characters")
        }
        
        return .ok(message: "username is valid")
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount || numberOfCharacters > maxPasswordCount {
            return .failed(message: "password must \(minPasswordCount) to \(maxPasswordCount) characters")
        }
        
        return .ok(message: "password is valid")
    }
    
}

class FakeAPIService: APIProtocol {
    
    static let instance = FakeAPIService()
    
    class func shareInstance() -> FakeAPIService {
        return self.instance
    }
    
    func signIn(_ username: String, password: String) -> Observable<Bool> {
  
        let result = (username == "username" && password == "password") ? true : false
        
        return Observable.just(result)
            .delay(2.0, scheduler: MainScheduler.instance)
        
    }
    
}





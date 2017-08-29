//
//  Protocols.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/11.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case empty
    case ok(message: String)
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

protocol ValidationProtocol {
    func validateUsername(_ username: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
}

protocol APIProtocol {
    func signIn(_ username: String, password: String) -> Observable<Bool>
}


//
//  DefaultImpl.swift
//  RxSwiftDemo
//
//  Created by wangqi.kaisa on 2017/4/12.
//  Copyright © 2017年 wangqi.kaisa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension ValidationResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return ""
        case let .ok(message):
            return message
        case let .failed(message):
            return message
        }
    }
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .empty:
            return UIColor.yellow
        case .ok:
            return UIColor.green
        case .failed:
            return UIColor.red
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: UIBindingObserver<Base, ValidationResult> {
        return UIBindingObserver(UIElement: base) { label, result in
            label.text = result.description
            label.textColor = result.textColor
        }
    }
}

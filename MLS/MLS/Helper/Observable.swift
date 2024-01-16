//
//  Observable.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import Foundation

class Observable<T> {
    
    var value: T? {
        didSet {
            self.listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}

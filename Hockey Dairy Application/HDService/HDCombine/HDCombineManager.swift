//
//  HDCombineManager.swift
//  Hockey Team Journal
//
//  
//

import Combine

class HDCombineManager {
    static let shared = HDCombineManager()
    private init () {}
    var value = CurrentValueSubject<Bool, Never>(false)
}

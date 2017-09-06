//
//  Array+evc.swift
//  EVC
//
//  Created by Benjamin Garrigues on 06/09/2017.

import Foundation


extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}

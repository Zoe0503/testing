//
//  RandomGenerator.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import Foundation
import GameKit

struct RandomGenerator {
    
    ///Random numbers become generated depending on the specified range, such as  ==> [1, end]
    static func randomInt(end: Int) -> [Int] {
        var beginArr = Array(0...end-1)
        var outcomeArr = Array(repeating: 0, count: end)
        for i in 0..<beginArr.count {
            let presentCount = UInt32(beginArr.count - i)
            let index = Int(arc4random_uniform(presentCount))
           outcomeArr[i] = beginArr[index]
            beginArr[index] = beginArr[Int(presentCount) - 1]
        }
        return outcomeArr
    }
    
  
    ///Random numbers become generated from the semi-closed range, such as [start, end]
    static func randomInt(start: Int, end: Int) -> [Int] {
        let scope = end - start
        var beginArr = Array(1...scope)
        var outcomeArr = Array(repeating: 0, count: scope)
        for i in 0..<beginArr.count {
            let presentCount = UInt32(beginArr.count - i)
            let index = Int(arc4random_uniform(presentCount))
            outcomeArr[i] = beginArr[index]
            beginArr[index] = beginArr[Int(presentCount) - 1]
        }
        return outcomeArr.map { $0 + start }
    }
}








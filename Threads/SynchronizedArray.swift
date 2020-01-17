//
//  SynchronizedArray.swift
//  Threads
//
//  Created by Maryan on 17.01.2020.
//  Copyright © 2020 Maryan. All rights reserved.
//

import Foundation

class SynchronizedArray<Element> {
    private let queue = DispatchQueue(label: "synchronizedArray", attributes: .concurrent)
    
    private var array = [Element]()
    
    private var count: Int = 0
    
    init() { }
    
    convenience init(_ array: [Element]) {
        self.init()
        self.array = array
    }
}

extension SynchronizedArray {
    func append(_ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func removeLast() {
        queue.async(flags: .barrier) {
            if self.array.count > 0 {
                self.array.removeLast()
                self.count += 1
            }
        }
    }
    
    func getDeletedObjectCounter() -> Int {
        var result = 0
        queue.sync { result = self.count }
        return result
    }

    func clearDeletedObjectCounter() {
        queue.async(flags: .barrier) { self.count = 0}
    }
    
}

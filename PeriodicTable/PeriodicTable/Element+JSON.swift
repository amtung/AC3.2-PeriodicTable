//
//  Element+JSON.swift
//  PeriodicTable
//
//  Created by Annie Tung on 12/21/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

//symbol, name, number, group, and weight.

extension Element {
    func parse(dict: [String:Any]) {
        guard
            let symbol = dict["symbol"] as? String,
            let name = dict["name"] as? String,
            let number = dict["number"] as? Int,
            let group = dict["group"] as? Int,
            let weight = dict["weight"] as? Float else { return }
        
        self.symbol = symbol
        self.name = name
        self.number = Int32(number)
        self.group = Int32(group)
        self.weight = weight
    }
}

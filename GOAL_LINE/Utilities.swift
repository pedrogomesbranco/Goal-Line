//
//  Utilities.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
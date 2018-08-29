//
//  ArrayExtension.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/29/18.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

/// MARK:- Extension for Array.
extension Array where Element: Hashable {
    
    // Returns the most frequent occuring element.
    public func mostFrequent() ->Int? {
        let counts = self.reduce(into: [:]) {
            $0[$1, default: 0] += 1
        }
        guard let result = counts.max(by: { $0.1 < $1.1 }),
            let value = result.0 as? Int else {
            return nil
        }
        return value
    }
    
}

//
//  Constants.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/29/18.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

struct Constants {
    static  let kMinReadingsForAverageHR                = 50000
    static  let kMinReadingsForAverageFrequentHR        = 20000
    // Interval for Frequent readings in Secs.
    static let kFrequentHRReadingsIntervalInSecs        = 5
    static let kChunkSizeForAverageHR                   = 10000
    static let kRestingHRThreshold                      = 65
    static let kMinReadingsForAverageRHR                = 1000
}

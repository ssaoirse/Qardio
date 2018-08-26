//
//  DataProvider.swift
//  QardioTestAssignmentDataSource
//
//  Created by Dmitrii on 13/12/2017.
//  Copyright © 2017 Qardio. All rights reserved.
//

import Foundation

class DataProvider {

    private let timer: DispatchSourceTimer
    private var listeners = [DataProviderListener]()
    private let measurements: [Double] = {
        var items = [Double]()
        guard let path = Bundle.main.path(forResource: "ecgdata", ofType: "csv") else { return items }
        guard let contentStr = try? String(contentsOfFile: path) else { return items }
        let lines = contentStr.components(separatedBy: "\r")
        for line in lines {
            let valuesInLine = line.components(separatedBy: ";")
            if let val1 = Double(valuesInLine[1]),
                let val2 = Double(valuesInLine[3]) {
                items.append(val2 - val1 + 150.0)
            }
        }
        return items
    }()

    private var counter = 0
    private var prevDate = Date().timeIntervalSince1970

    init() {
        timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: .milliseconds(2))
        timer.setEventHandler(handler: {
            let i = self.counter % self.measurements.count
            let measurememnt = self.measurements[i]
            DispatchQueue.global().async {
                for listener in self.listeners {
                    listener.measurementUpdated(measurememnt)
                }
            }
            self.logTheRate()
        })
        timer.resume()
    }

    func subscribeNewListener(_ listener: DataProviderListener) {
        listeners.append(listener)
    }


    private func logTheRate() {
        counter += 1
        if self.counter % 1000 == 0 {
            let currentDate = Date().timeIntervalSince1970
            let delta = currentDate - prevDate
            prevDate = currentDate
            print("DP rate: \(delta) ms")
        }
    }
}


protocol DataProviderListener {
    func measurementUpdated(_ measurement: Double)
}

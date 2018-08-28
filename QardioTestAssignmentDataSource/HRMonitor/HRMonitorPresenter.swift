//
//  HRMonitorPresenter.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/26/18.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class HRMonitorPresenter {
    private weak var viewController: HeartRateDisplayable?
    
    init(viewController: HeartRateDisplayable?) {
        self.viewController = viewController
    }
}


// MARK:- HeartRatePresentable
extension HRMonitorPresenter: HeartRatePresentable {
    
    func presentECG(with measurements:[Double]) {
        self.viewController?.updateECG(with: measurements)
    }

    func presentHeartRate(with value: Double) {
        self.viewController?.displayHeartRate(value: String(format: "%d bpm", Int(value)))
    }
    
    func presentRestingHeartRate(with value: Double) {
        self.viewController?.displayRestingHeartRate(value: String(format: "%d bpm", Int(value)))
    }
    
    func presentFrequentHeartRate(with value: Double) {
        self.viewController?.displayFrequentHeartRate(value: String(format: "%d bpm", Int(value)))
    }
    
    func presentSessionTime(with value: Int) {
        var result = ""
        if value < 60 {
            result = String(format: "00:00:%02d",value)
        }
        else if value > 60 && value < 3600 {
            let min = value / 60
            let sec = value % 60
            result = String(format: "00:%02d:%02d", min, sec)
        }
        else {
            let hr = value / 3600
            let rem = (value % 3600)
            let min = rem / 60
            let sec = rem % 60
            result = String(format: "%02d:%02d:%02d", hr, min, sec)
        }
        self.viewController?.displaySessionTime(value: result)
    }
}

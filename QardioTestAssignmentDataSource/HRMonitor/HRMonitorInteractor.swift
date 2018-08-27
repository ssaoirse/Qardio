//
//  HRMonitorInteractor.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/26/18.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

class HRMonitorInteractor {
    private let dataProvider: DataProvider
    private let presenter: HeartRatePresentable
    
    private var measurements = [Double]()
    
    /// Initializer
    init(dataProvider: DataProvider, presenter: HeartRatePresentable) {
        self.dataProvider = dataProvider
        self.presenter = presenter
    }
}


// MARK:- HeartRateBusinessLogic
extension HRMonitorInteractor: HeartRateBusinessLogic {
    public func listenAndCompute() {
        self.dataProvider.subscribeNewListener(self)
    }
}


// MARK:- DataProviderListener
extension HRMonitorInteractor: DataProviderListener {
    func measurementUpdated(_ measurement: Double) {
        measurements.append(measurement)
        
        guard measurements.count >= 300 else { return }
        
        let result = Array(measurements.suffix(300))
        self.presenter.presentECG(with: result)
        self.presenter.presentHeartRate(with: result[299])
        self.presenter.presentRestingHeartRate(with: result[299])
        self.presenter.presentFrequentHeartRate(with: result[299])
        self.presenter.presentSessionTime(with: result[299])
    }
}

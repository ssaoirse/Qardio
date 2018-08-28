//
//  HRMonitorInteractor.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/26/18.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

/*!
 * @brief Interactor class which listens for updates from DataProvider,
 *        Performs computation of various required values and triggers view updates,
 *        logging etc.
 */
class HRMonitorInteractor {
    /// Helper for adding logs to CoreData.
    private let hrDataController: HRDataController
    /// Provides updates for received data.
    private let dataProvider: DataProvider
    /// Reference type to facilitate view updates.
    private let presenter: HeartRatePresentable
    
    private var measurements = [Double]()
    
    /// Initializer
    init(hrDataController: HRDataController,
         dataProvider: DataProvider,
         presenter: HeartRatePresentable) {
        self.hrDataController = hrDataController
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
        let ecgInput = Array(measurements.suffix(300))
        
        // Update ECG
        self.presenter.presentECG(with: ecgInput)
        
        // Compute elapsed time. (1 sec interval)
        if measurements.count % 500 == 0 {
            
            // Elapsed time in secs.
            self.presenter.presentSessionTime(with: measurements.count/500)
            
            // Most Frequent Heart Rate
            // Every 1 second 500 readings are added.
            // So when readings count % 2500 == 0 => 5 secs have elapsed.
            if measurements.count % 2500 == 0 && measurements.count >= 20000 {
                DispatchQueue.global().async {[weak self] in
                    let values = Array((self?.measurements.suffix(20000))!)
                    self?.computeMostFrequentHeartRate(values)
                }
            }
        }
        
        // TODO: Update fields.
//        DispatchQueue.main.async {[weak self] in
//            self?.logAverageHeartRate(Int((self?.measurements[(self?.measurements.count)!-1])!))
//        }
//        self.presenter.presentHeartRate(with: result[299])
//        self.presenter.presentRestingHeartRate(with: result[299])
    }
    
    fileprivate func logAverageHeartRate(_ rate: Int) {
        let _ = self.hrDataController.addLogForType(.averageHR, withRate: rate, date: Date(timeIntervalSinceNow: 0))
    }
    
    fileprivate func logAverageRestingHeartRate(_ rate: Int) {
        let _ = self.hrDataController.addLogForType(.averageRHR, withRate: rate, date: Date(timeIntervalSinceNow: 0))
    }
    
    fileprivate func computeMostFrequentHeartRate(_ readings: [Double]) {
        let counts = readings.reduce(into: [:]) {
            $0[$1, default: 0] += 1
        }
        let result = counts.max(by: { $0.1 < $1.1 })
        print("\(Date(timeIntervalSinceNow: 0))")
        self.presenter.presentFrequentHeartRate(with: (result!.0))
    }
}

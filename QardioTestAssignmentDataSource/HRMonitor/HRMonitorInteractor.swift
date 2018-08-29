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
    
    // NOTE:
    // measurements has been modified to use Int rather than Double
    // This sacrifices precision for speed assuming Int comparisons are faster than
    // Double.
    private var measurements = [Int]()
    private var secondsElapsed = 0
    
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
        measurements.append(Int(measurement))
        
        guard measurements.count >= 300 else { return }
        let ecgInput = Array(measurements.suffix(300))
        
        // Update ECG
        self.presenter.presentECG(with: ecgInput)
        
        // Compute elapsed time. (1 sec interval)
        if measurements.count % 500 == 0 {
            // Increment seconds elapsed.
            secondsElapsed += 1
            
            // Keeping most recent 50000 values to limit memory used.
            if measurements.count >= Constants.kMinReadingsForAverageHR {
                measurements.removeFirst(measurements.count - Constants.kMinReadingsForAverageHR)
            }
            
            // Elapsed time in secs.
            self.presenter.presentSessionTime(with: secondsElapsed)
            
            // Most Frequent Heart Rate
            if secondsElapsed % Constants.kFrequentHRReadingsIntervalInSecs == 0 &&
                measurements.count >= Constants.kMinReadingsForAverageFrequentHR {
                DispatchQueue.global().async {[weak self] in
                    if let slice = self?.measurements.suffix(Constants.kMinReadingsForAverageFrequentHR) {
                        let values = Array(slice)
                        if let value = values.mostFrequent() {
                            self?.presenter.presentFrequentHeartRate(with: value)
                        }
                    }
                }
            }
        }
        
        
        
        
    }
}

// MARK:- Private Methods in Extension.
extension HRMonitorInteractor {
    
    fileprivate func logAverageHeartRate(_ rate: Int) {
        let _ = self.hrDataController.addLogForType(.averageHR, withRate: rate, date: Date(timeIntervalSinceNow: 0))
    }
    
    fileprivate func logAverageRestingHeartRate(_ rate: Int) {
        let _ = self.hrDataController.addLogForType(.averageRHR, withRate: rate, date: Date(timeIntervalSinceNow: 0))
    }
}


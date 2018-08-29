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
    // This array will hold the HR values which are less than 65. As we are not holding
    // all the measurement values..
    private var restingHR = [Int]()
    
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
    public func listenAndUpdate() {
        self.dataProvider.subscribeNewListener(self)
    }
}


// MARK:- DataProviderListener
extension HRMonitorInteractor: DataProviderListener {
    func measurementUpdated(_ measurement: Double) {
        self.measurements.append(Int(measurement))
        
        guard measurements.count >= 300 else { return }
        let ecgInput = Array(measurements.suffix(300))
        
        // Update ECG
        self.presenter.presentECG(with: ecgInput)
        
        // Compute elapsed time. (1 sec interval)
        if measurements.count % 500 == 0 {
            // Increment seconds elapsed.
            secondsElapsed += 1
            
            // Append any RHR values
            restingHR.append(contentsOf: (Array(measurements).filter {$0 < Constants.kRestingHRThreshold && $0 > 0}))
            if restingHR.count > Constants.kMinReadingsForAverageRHR  {
                restingHR.removeFirst(restingHR.count - Constants.kMinReadingsForAverageRHR)
                self.computeAndUpdateAverageRHR()
            }
            
            // Keeping most recent 50000 values to limit memory used.
            // Compute Average Heart Rate.
            if measurements.count >= Constants.kMinReadingsForAverageHR {
                measurements.removeFirst(measurements.count - Constants.kMinReadingsForAverageHR)
                computeAndUpdateAverageHR()
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
    
    fileprivate func computeAndUpdateAverageRHR() {
        let values = restingHR
        DispatchQueue.global().async {[weak self] in
            let avg = (values.reduce(0, +) / values.count)
            self?.hrDataController.addLogForType(.averageRHR,
                                                 withRate: avg,
                                                 date: Date(timeIntervalSinceNow: 0))
            self?.presenter.presentRestingHeartRate(with: avg)
        }
    }
    
    fileprivate func computeAndUpdateAverageHR() {
        let values = measurements
        
        let dispatchGroup = DispatchGroup()
        let parts = values.chunked(into: Constants.kChunkSizeForAverageHR)
        var total = 0
        for i in 0..<5 {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                total += ((parts[i]).reduce(0, +))
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .global()) {[weak self] in
            let avg = total/values.count
            self?.hrDataController.addLogForType(.averageHR,
                                                 withRate: avg,
                                                 date: Date(timeIntervalSinceNow: 0))
            self?.presenter.presentHeartRate(with: avg)
        }
    }
}


//
//  HRMonitorInterfaces.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/26/18.
//  Copyright © 2018 DI. All rights reserved.
//

/// Interface for the View Controller.
protocol HeartRateDisplayable: class {
    func updateECG(with measurements:[Double])
    func displayHeartRate(value: String)
    func displayRestingHeartRate(value: String)
    func displayFrequentHeartRate(value: String)
    func displaySessionTime(value: String)
}

/// Interface for the Interactor.
protocol HeartRateBusinessLogic {
    func listenAndCompute()
}

/// Interface for the Presenter.
protocol HeartRatePresentable {
    func presentECG(with measurements:[Double])
    func presentHeartRate(with value: Double)
    func presentRestingHeartRate(with value: Double)
    func presentFrequentHeartRate(with value: Double)
    func presentSessionTime(with value: Double)
}


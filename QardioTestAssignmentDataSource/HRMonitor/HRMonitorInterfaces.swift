//
//  HRMonitorInterfaces.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/26/18.
//  Copyright © 2018 DI. All rights reserved.
//

/// Interface for the View Controller.
protocol HeartRateDisplayable: class {
    func updateECG(with measurements:[Int])
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
    func presentECG(with measurements:[Int])
    func presentHeartRate(with value: Int)
    func presentRestingHeartRate(with value: Int)
    func presentFrequentHeartRate(with value: Int)
    func presentSessionTime(with value: Int)
}


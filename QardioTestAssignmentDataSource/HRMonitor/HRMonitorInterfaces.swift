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
    func displayHeartRate(/*with viewModel: ListProductsModels.ViewModel*/)
}

/// Interface for the Interactor.
protocol HeartRateBusinessLogic {
    func listenAndCompute()
}

/// Interface for the Presenter.
protocol HeartRatePresentable {
    func presentECG(with measurements:[Double])
    func presentHeartRate(/*for response: ListProductsModels.Response*/)
}


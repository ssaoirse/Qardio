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

    func presentHeartRate() {
        
    }
}

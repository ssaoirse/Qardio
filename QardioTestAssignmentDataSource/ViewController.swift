//
//  ViewController.swift
//  QardioTestAssignmentDataSource
//
//  Created by Dmitrii on 13/12/2017.
//  Copyright © 2017 Qardio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var ecgView: ECGView!
    @IBOutlet private var heartImage: UIImageView!

    @IBOutlet weak var averageHRValueLabel: UILabel!
    @IBOutlet weak var averageRHRValueLabel: UILabel!
    @IBOutlet weak var frequentHRValueLabel: UILabel!
    @IBOutlet weak var sessionTimeValueLabel: UILabel!
    
    private var measurements = [Int]()
    
    private lazy var interactor: HeartRateBusinessLogic =
        HRMonitorInteractor(hrDataController: HRDataController(),
                            dataProvider: ((UIApplication.shared.delegate as? AppDelegate)?.dataProvider)!,
                            presenter: HRMonitorPresenter(viewController: self))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: {
                let scale = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.heartImage.transform = scale
        },
            completion: nil
        )
        /* Modified: Using Interactor to listen and compute.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.dataProvider.subscribeNewListener(self)
        */
        interactor.listenAndUpdate()
    }
}


extension ViewController: DataProviderListener {
    func measurementUpdated(_ measurement: Double) {
        measurements.append(Int(measurement))

        guard measurements.count >= 300 else { return }
        ecgView.measurements = Array(measurements.suffix(300))

        DispatchQueue.main.async {
            self.ecgView.setNeedsDisplay()
        }
    }
}


// MARK:- HeartRateDisplayable -
extension ViewController: HeartRateDisplayable {
    func updateECG(with measurements:[Int]) {
        DispatchQueue.main.async {
            self.ecgView.measurements = measurements
            self.ecgView.setNeedsDisplay()
        }
    }
    
    func displayHeartRate(value: String) {
        DispatchQueue.main.async {
            self.averageHRValueLabel.text = value
        }
    }
    
    func displayRestingHeartRate(value: String) {
        DispatchQueue.main.async {
            self.averageRHRValueLabel.text = value
        }
    }
    
    func displayFrequentHeartRate(value: String) {
        DispatchQueue.main.async {
            self.frequentHRValueLabel.text = value
        }
    }
    
    func displaySessionTime(value: String) {
        DispatchQueue.main.async {
            self.sessionTimeValueLabel.text = value
        }
    }
}

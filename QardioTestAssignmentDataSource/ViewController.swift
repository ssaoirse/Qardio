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

    private var measurements = [Double]()

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

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.dataProvider.subscribeNewListener(self)
    }
}


extension ViewController: DataProviderListener {
    func measurementUpdated(_ measurement: Double) {
        measurements.append(measurement)

        guard measurements.count >= 300 else { return }
        ecgView.measurements = Array(measurements.suffix(300))

        DispatchQueue.main.async {
            self.ecgView.setNeedsDisplay()
        }
    }
}

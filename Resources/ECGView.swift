//
//  ECGView.swift
//  QardioTestAssignmentDataSource
//
//  Created by Dmitrii on 22/02/2018.
//  Copyright © 2018 DI. All rights reserved.
//

import UIKit

class ECGView: UIView {

    // Modified:
    //var measurements = [Double]()
    var measurements = [Int]()
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIRectFill(rect)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        ECGPlotDrawer.addPlotToContext(context, withPoints: pointsToDisplay())
    }

    private func pointsToDisplay() -> [CGPoint] {
        let step = frame.width / CGFloat(measurements.count)
        var points = [CGPoint]()
        for i in 0..<measurements.count {
            let value = measurements[i]
            points.append(CGPoint(x: CGFloat(i)*step, y: CGFloat(value)))
        }
        return points
    }
}


class ECGPlotDrawer {

    static func addPlotToContext(_ context: CGContext, withPoints: [CGPoint?]?) {
        guard let points = withPoints else {return}
        context.setLineWidth(1.0)
        context.setShouldAntialias(true)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.saveGState()
        context.beginPath()
        let p = path(points)
        context.addPath(p)
        context.restoreGState()
        context.strokePath()
    }

    static func path(_ points: [CGPoint?]) -> CGPath {
        let path = CGMutablePath()
        var graphIsStarted = false
        for point in points {
            if point == nil {
                if graphIsStarted {
                    graphIsStarted = false
                }
            } else {
                if graphIsStarted {
                    path.addLine(to: CGPoint(x: point!.x, y: point!.y))
                } else {
                    path.move(to: CGPoint(x: point!.x, y: point!.y))
                    graphIsStarted = true
                }
            }
        }
        return path
    }
}

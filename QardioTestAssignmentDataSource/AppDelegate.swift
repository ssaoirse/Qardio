//
//  AppDelegate.swift
//  QardioTestAssignmentDataSource
//
//  Created by Dmitrii on 13/12/2017.
//  Copyright © 2017 Qardio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataProvider = DataProvider()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

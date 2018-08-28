//
//  CoreDataHelper.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/28/18.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

/*!
 * @brief Singleton instance which wraps the access to the CoreData stack.
 */
final class CoreDataHelper: NSObject {
    private static var sharedInstance: CoreDataHelper  =  {
        let helper = CoreDataHelper()
        return helper
    }()
    private let dataController: DataController
    
    override private init() {
        self.dataController = DataController()
        super.init()
    }
    
    // MARK:- Accessor -
    class func shared() -> CoreDataHelper {
        return sharedInstance
    }
    
    public func getContext() -> NSManagedObjectContext {
        return self.dataController.mainContext
    }
}

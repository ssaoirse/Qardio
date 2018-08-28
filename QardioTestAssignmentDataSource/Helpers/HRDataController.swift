//
//  HRDataController.swift
//  QardioTestAssignmentDataSource
//
//  Created by Saoirse on 8/28/18.
//  Copyright © 2018 DI. All rights reserved.
//

import Foundation

/*!
 * @brief Helper class to facilitate adding HR records to CoreData.
 */
class HRDataController: NSObject {
    
    // Add Log
    func addLogForType(_ type: HRType, withRate rate: Int, date: Date) -> Bool {
        let context = CoreDataHelper.shared().getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: type.rawValue, in: context) else {
            print("Unable to add entity for \(type.rawValue)")
            return false
        }
        let newObj = NSManagedObject(entity: entity, insertInto: context)
        newObj.setValue(rate, forKey: "heartrate")
        newObj.setValue(date, forKey: "timestamp")
        do {
            try context.save()
        }
        catch(let error) {
            print(error.localizedDescription)
            return false
        }
        return true
    }
}

//
//  DataController.h
//  QardioTestAssignmentDataSource
//
//  Created by Dmitrii on 13/12/2017.
//  Copyright © 2017 Qardio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataController : NSObject
@property (strong, nonatomic, readonly) NSManagedObjectContext* mainContext;
@property (strong, nonatomic, readonly) NSPersistentContainer* mainContainer;

- (void)initialise;
- (void)saveContext;
@end

//
//  DataController.m
//  QardioTestAssignmentDataSource
//
//  Created by Dmitrii on 13/12/2017.
//  Copyright © 2017 Qardio. All rights reserved.
//

#import "DataController.h"
#import "CoreData/CoreData.h"

@interface DataController ()
@property (strong, nonatomic) NSPersistentContainer*    mainContainer;
@property (strong, nonatomic) NSManagedObjectContext*   mainContext;
@end

@implementation DataController

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initialise];
    
    return self;
}

- (void)initialise
{
    @synchronized (self)
    {
        if (self.mainContainer == nil)
        {
            self.mainContainer = [[NSPersistentContainer alloc] initWithName:@"QardioTestAssignmentDataSource"];
            [self.mainContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error)
            {
                if (error != nil)
                {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
        
        self.mainContext = self.mainContainer.viewContext;
    }
}

- (void)saveContext
{
    NSManagedObjectContext *context = self.mainContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
@end

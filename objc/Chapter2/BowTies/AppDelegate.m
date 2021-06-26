//
//  AppDelegate.m
//  BowTies
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "AppDelegate.h"
#import "ColorAttributeTransformer.h"
#import "BowTie.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ColorAttributeTransformer register];
    
//    // Save test bow tie
//    BowTie *bowTie = (BowTie *)[NSEntityDescription insertNewObjectForEntityForName:@"BowTie"
//                                                   inManagedObjectContext:self.persistentContainer.viewContext];
//    
//    bowTie.name = @"My bow tie";
//    bowTie.lastWorn = [NSDate new];
//    [self saveContext];
//    
//    // Retrieve test bow tie
//    NSFetchRequest<BowTie *> *request = [BowTie _fetchRequest];
//    
//    NSArray *ties = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
//    NSString *testName = ((BowTie *)ties.firstObject).name;
//    NSDate *testLastWorn = ((BowTie *)ties.firstObject).lastWorn;
//    NSLog(@"Name: %@, Worn: %@", testName, testLastWorn);
    
    return YES;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BowTies"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

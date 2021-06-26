//
//  CoreDataStack.m
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property (readonly) NSString *modelName;
@property (nonatomic) NSPersistentContainer *storeContainer;
@end

@implementation CoreDataStack

@synthesize managedContext = _managedContext;

- (instancetype)initWithModelName:(NSString *)modelName {
    self = [self init];
    
    if (self) {
        _modelName = modelName;
    }
    
    return self;
}

- (NSPersistentContainer *)storeContainer {
    if (_storeContainer) {
        return _storeContainer;
    } else {
        NSPersistentContainer *container = [NSPersistentContainer persistentContainerWithName:self.modelName];
        
        [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Unsolved error %@, %@", error, error.userInfo);
            }
        }];
        
        _storeContainer = container;
        
        return container;
    }
}

- (NSManagedObjectContext *)managedContext {
    if (_managedContext) {
        return _managedContext;
    } else {
        NSManagedObjectContext *managedContext = self.storeContainer.viewContext;
        _managedContext = managedContext;
        return managedContext;
    }
}

- (void)saveContext {
    if (!self.managedContext.hasChanges) return;
    
    NSError * _Nullable error = nil;
    
    [self.managedContext save:&error];
    
    if (error) {
        NSLog(@"Unsolved error %@, %@", error, error.userInfo);
    }
}

@end

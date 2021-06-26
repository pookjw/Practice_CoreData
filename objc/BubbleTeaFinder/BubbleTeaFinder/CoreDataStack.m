//
//  CoreDataStack.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property (readonly) NSString *modelName;
@property (nonatomic) NSPersistentContainer *storeContainer;
@end

@implementation CoreDataStack

- (instancetype)initWithModelName:(NSString *)modelName {
    self = [self init];
    
    if (self) {
        self->_modelName = modelName;
    }
    
    return self;
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

- (NSPersistentContainer *)storeContainer {
    if (_storeContainer) {
        return _storeContainer;
    } else {
        NSPersistentContainer *container = [NSPersistentContainer persistentContainerWithName:self.modelName];
        
        [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            }
        }];
        
        _storeContainer = container;
        return container;
    }
}

- (void)saveContext {
    if (!self.managedContext.hasChanges) return;
    
    NSError * _Nullable error = nil;
    [self.managedContext save:&error];
    
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
}

@end

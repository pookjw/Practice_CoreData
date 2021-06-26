//
//  CoreDataStack.h
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStack : NSObject
- (instancetype)initWithModelName:(NSString *)modelName;
- (void)saveContext;
@property (nonatomic) NSManagedObjectContext *managedContext;
@end

NS_ASSUME_NONNULL_END

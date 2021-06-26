//
//  CoreDataStack.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStack : NSObject
@property (nonatomic) NSManagedObjectContext *managedContext;
- (instancetype)initWithModelName:(NSString *)modelName;
- (void)saveContext;
@end

NS_ASSUME_NONNULL_END

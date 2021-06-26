//
//  Dog.h
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSManagedObject
@property NSString * _Nullable name;
@property NSOrderedSet * _Nullable walks;
+ (NSFetchRequest<Dog *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

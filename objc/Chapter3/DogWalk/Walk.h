//
//  Walk.h
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import <CoreData/CoreData.h>
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Walk : NSManagedObject
@property NSDate * _Nullable date;
@property Dog * _Nullable dog;
+ (NSFetchRequest<Walk *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

//
//  Stats.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <CoreData/CoreData.h>

@class Venue;

NS_ASSUME_NONNULL_BEGIN

@interface Stats : NSManagedObject
@property int32_t checkinsCount;
@property int32_t tipCount;
@property int32_t usersCount;
@property Venue * _Nullable venue;
+ (NSFetchRequest<Stats *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

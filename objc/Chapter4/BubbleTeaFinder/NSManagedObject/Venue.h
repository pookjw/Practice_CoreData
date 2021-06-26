//
//  Venue.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <CoreData/CoreData.h>
#import "Category.h"
#import "Location.h"
#import "Stats.h"
#import "PriceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Venue : NSManagedObject
@property BOOL favorite;
@property NSString * _Nullable name;
@property NSString * _Nullable phone;
@property int32_t specialCount;
@property Category * _Nullable category;
@property Location * _Nullable location;
@property PriceInfo * _Nullable priceInfo;
@property Stats * _Nullable stats;
+ (NSFetchRequest<Venue *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

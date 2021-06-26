//
//  PriceInfo.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <CoreData/CoreData.h>

@class Venue;

NS_ASSUME_NONNULL_BEGIN

@interface PriceInfo : NSManagedObject
@property NSString * _Nullable priceCategory;
@property Venue * _Nullable venue;
+ (NSFetchRequest<PriceInfo *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

//
//  Location.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <CoreData/CoreData.h>

@class Venue;

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSManagedObject
@property NSString * _Nullable address;
@property NSString * _Nullable city;
@property NSString * _Nullable country;
@property float distance;
@property NSString * _Nullable state;
@property NSString * _Nullable zipcode;
@property Venue * _Nullable venue;
+ (NSFetchRequest<Location *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

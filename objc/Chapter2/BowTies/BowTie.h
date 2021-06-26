//
//  BowTie.h
//  BowTies
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BowTie : NSManagedObject
@property NSString *name;
@property BOOL isFavorite;
@property NSDate * _Nullable lastWorn;
@property double rating;
@property NSString * _Nullable searchKey;
@property int32_t timesWorn;
@property NSUUID * _Nullable id;
@property NSURL * _Nullable url;
@property NSData * _Nullable photoData;
@property UIColor * _Nullable tintColor;
@end

@interface BowTie (Category)
+ (NSFetchRequest<BowTie *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

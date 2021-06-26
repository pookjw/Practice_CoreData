//
//  Category.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <CoreData/CoreData.h>

@class Venue;

NS_ASSUME_NONNULL_BEGIN

@interface Category : NSManagedObject
@property NSString * _Nullable categoryID;
@property NSString * _Nullable name;
@property Venue * _Nullable venue;
+ (NSFetchRequest<Category *> *)_fetchRequest;
@end

NS_ASSUME_NONNULL_END

//
//  Category.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "Category.h"

@implementation Category

@dynamic categoryID;
@dynamic name;
@dynamic venue;

+ (NSFetchRequest<Category *> *)_fetchRequest {
    return [NSFetchRequest<Category *> fetchRequestWithEntityName:@"Category"];
}

@end

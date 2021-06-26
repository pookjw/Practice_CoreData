//
//  Location.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "Location.h"

@implementation Location

@dynamic address;
@dynamic city;
@dynamic country;
@dynamic distance;
@dynamic state;
@dynamic zipcode;
@dynamic venue;

+ (NSFetchRequest<Location *> *)_fetchRequest {
    return [NSFetchRequest<Location *> fetchRequestWithEntityName:@"Location"];
}

@end

//
//  Venue.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "Venue.h"

@implementation Venue

@dynamic favorite;
@dynamic name;
@dynamic phone;
@dynamic specialCount;
@dynamic category;
@dynamic location;
@dynamic priceInfo;
@dynamic stats;

+ (NSFetchRequest<Venue *> *)_fetchRequest {
    return [NSFetchRequest<Venue *> fetchRequestWithEntityName:@"Venue"];
}

@end

//
//  Stats.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "Stats.h"

@implementation Stats

@dynamic checkinsCount;
@dynamic tipCount;
@dynamic usersCount;
@dynamic venue;

+ (NSFetchRequest<Stats *> *)_fetchRequest {
    return [NSFetchRequest<Stats *> fetchRequestWithEntityName:@"Stats"];
}

@end

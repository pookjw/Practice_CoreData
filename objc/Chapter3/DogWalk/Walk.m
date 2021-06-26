//
//  Walk.m
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "Walk.h"

@implementation Walk

@dynamic date;
@dynamic dog;

+ (NSFetchRequest<Walk *> *)_fetchRequest {
    return [NSFetchRequest<Walk *> fetchRequestWithEntityName:@"Walk"];
}

@end

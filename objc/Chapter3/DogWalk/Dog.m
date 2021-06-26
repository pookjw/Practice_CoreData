//
//  Dog.m
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "Dog.h"

@implementation Dog

@dynamic name;
@dynamic walks;

+ (NSFetchRequest<Dog *> *)_fetchRequest {
    return [NSFetchRequest<Dog *> fetchRequestWithEntityName:@"Dog"];
}

@end

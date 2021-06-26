//
//  BowTie.m
//  BowTies
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "BowTie.h"

@implementation BowTie (Category)

+ (NSFetchRequest<BowTie *> *)_fetchRequest {
    return [[NSFetchRequest<BowTie *> alloc] initWithEntityName:@"BowTie"];
}

@end

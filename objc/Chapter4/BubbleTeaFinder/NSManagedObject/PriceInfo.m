//
//  PriceInfo.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "PriceInfo.h"

@implementation PriceInfo

@dynamic priceCategory;
@dynamic venue;

+ (NSFetchRequest<PriceInfo *> *)_fetchRequest {
    return [NSFetchRequest<PriceInfo *> fetchRequestWithEntityName:@"Stats"];
}

@end

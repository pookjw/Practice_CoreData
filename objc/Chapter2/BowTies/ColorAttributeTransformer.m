//
//  ColorAttributeTransformer.m
//  BowTies
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "ColorAttributeTransformer.h"
#import <UIKit/UIKit.h>

@implementation ColorAttributeTransformer

+ (NSArray<Class> *)allowedTopLevelClasses {
    return @[[UIColor class]];
}

+ (void)register {
    NSString *className = NSStringFromClass(self);
    NSValueTransformerName name = (NSValueTransformerName)className;
    
    ColorAttributeTransformer *transformer = [ColorAttributeTransformer new];
    [NSValueTransformer setValueTransformer:transformer forName:name];
}

@end

//
//  ColorAttributeTransformer.h
//  BowTies
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorAttributeTransformer : NSSecureUnarchiveFromDataTransformer
+ (void)register;
@end

NS_ASSUME_NONNULL_END

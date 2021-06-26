//
//  FilterViewController.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

NS_ASSUME_NONNULL_BEGIN

@class FilterViewController;
@protocol FilterViewControllerDelegate <NSObject>
- (void)filterViewController:(FilterViewController *)filter
          didSelectPredicate:(NSPredicate * _Nullable)predicate
              sortDescriptor:(NSSortDescriptor * _Nullable)sortDescriptor;
@end

@interface FilterViewController : UITableViewController
@property (weak) NSObject<FilterViewControllerDelegate> *delegate;
@property CoreDataStack *coreDataStack;
@end

NS_ASSUME_NONNULL_END

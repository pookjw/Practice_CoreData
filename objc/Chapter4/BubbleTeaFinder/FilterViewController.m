//
//  FilterViewController.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "FilterViewController.h"
#import "Venue.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstPriceCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPriceCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdPriceCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *numDealsLabel;

#pragma mark - Price section
@property (weak, nonatomic) IBOutlet UITableViewCell *cheapVenueCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *moderateVenueCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *expensiveVenueCell;

#pragma mark - Most popular section
@property (weak, nonatomic) IBOutlet UITableViewCell *offeringDealCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *walkingDistanceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *userTipsCell;

#pragma mark - Sort section
@property (weak, nonatomic) IBOutlet UITableViewCell *nameAZSortCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameZASortCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *distanceSortCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *priceSortCell;

@property NSSortDescriptor * _Nullable selectedSortDescriptor;
@property NSPredicate * _Nullable selectedPredicate;

#pragma mark - Predicates
@property NSPredicate *cheapVenuePredicate;
@property NSPredicate *moderateVenuePredicate;
@property NSPredicate *expensiveVenuePredicate;
@property NSPredicate *offeringDealPredicate;
@property NSPredicate *walkingDistancePredicate;
@property NSPredicate *hasUserTipsPredicate;

#pragma mark - SortDescriptors
@property NSSortDescriptor *nameSortDescriptor;
@property NSSortDescriptor *distanceSortDescriptor;
@property NSSortDescriptor *priceSortDescriptor;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)setAttributes {
    self.cheapVenuePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"priceInfo.priceCategory", @"$"];
    self.moderateVenuePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"priceInfo.priceCategory", @"$$"];
    self.expensiveVenuePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"priceInfo.priceCategory", @"$$$"];
    
    self.offeringDealPredicate = [NSPredicate predicateWithFormat:@"%K > 0", @"specialCount"];
    self.walkingDistancePredicate = [NSPredicate predicateWithFormat:@"%K < 500", @"location.distance"];
    self.hasUserTipsPredicate = [NSPredicate predicateWithFormat:@"%K > 0", @"stats.tipCount"];
    
    self.nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                          ascending:YES
                                                           selector:NSSelectorFromString(@"localizedStandardCompare:")];
    self.distanceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"location.distance"
                                                          ascending:YES];
    self.priceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priceInfo.priceCategory"
                                                          ascending:YES];
}

- (IBAction)searchButtonTouched:(UIBarButtonItem *)sender {
    [self.delegate filterViewController:self
                     didSelectPredicate:self.selectedPredicate
                         sortDescriptor:self.selectedSortDescriptor];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) return;
    
    if (cell == self.cheapVenueCell) self.selectedPredicate = self.cheapVenuePredicate;
    else if (cell == self.moderateVenueCell) self.selectedPredicate = self.moderateVenuePredicate;
    else if (cell == self.expensiveVenueCell) self.selectedPredicate = self.expensiveVenuePredicate;
    else if (cell == self.offeringDealCell) self.selectedPredicate = self.offeringDealPredicate;
    else if (cell == self.walkingDistanceCell) self.selectedPredicate = self.walkingDistancePredicate;
    else if (cell == self.userTipsCell) self.selectedPredicate = self.hasUserTipsPredicate;
    else if (cell == self.nameAZSortCell) self.selectedSortDescriptor = self.nameSortDescriptor;
    else if (cell == self.nameZASortCell) self.selectedSortDescriptor = [self.nameSortDescriptor reversedSortDescriptor];
    else if (cell == self.distanceSortCell) self.selectedSortDescriptor = self.distanceSortDescriptor;
    else if (cell == self.priceSortCell) self.selectedSortDescriptor = self.priceSortDescriptor;
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark - Helper Methods

- (void)populateCheapVenueCountLabel {
    NSFetchRequest<NSNumber *> *fetchRequest = [NSFetchRequest<NSNumber *> fetchRequestWithEntityName:@"Venue"];
    fetchRequest.resultType = NSCountResultType;
    fetchRequest.predicate = self.cheapVenuePredicate;
    
    NSError * _Nullable error = nil;
    
    NSArray *countResult = [self.coreDataStack.managedContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"count not fetched %@, %@", error, error.userInfo);
        return;
    }
    
    NSUInteger count = [(NSNumber *)countResult.firstObject unsignedIntValue];
    NSString *pluralized = (count == 1) ? @"place" : @"places";
    self.firstPriceCategoryLabel.text = [NSString stringWithFormat:@"%lu bubble tea %@", count, pluralized];
}

- (void)populateModerateVenueCountLabel {
    NSFetchRequest<NSNumber *> *fetchRequest = [NSFetchRequest<NSNumber *> fetchRequestWithEntityName:@"Venue"];
    fetchRequest.resultType = NSCountResultType;
    fetchRequest.predicate = self.moderateVenuePredicate;
    
    NSError * _Nullable error = nil;
    
    NSArray *countResult = [self.coreDataStack.managedContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"count not fetched %@, %@", error, error.userInfo);
        return;
    }
    
    NSUInteger count = [(NSNumber *)countResult.firstObject unsignedIntValue];
    NSString *pluralized = (count == 1) ? @"place" : @"places";
    self.secondPriceCategoryLabel.text = [NSString stringWithFormat:@"%lu bubble tea %@", count, pluralized];
}

- (void)populateExpensiveVenueCountLabel {
    NSFetchRequest<Venue *> *fetchRequest = [Venue _fetchRequest];
    fetchRequest.predicate = self.expensiveVenuePredicate;
    
    NSError * _Nullable error = nil;
    
    NSUInteger count = [self.coreDataStack.managedContext countForFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"count not fetched %@, %@", error, error.userInfo);
        return;
    }
    
    NSString *pluralized = (count == 1) ? @"place" : @"places";
    self.thirdPriceCategoryLabel.text = [NSString stringWithFormat:@"%lu bubble tea %@", count, pluralized];
}

- (void)populateDealsCountLabel {
    // 1
    NSFetchRequest<NSDictionary *> *fetchRequest = [NSFetchRequest<NSDictionary *> fetchRequestWithEntityName:@"Venue"];
    fetchRequest.resultType = NSDictionaryResultType;
    
    // 2
    NSExpressionDescription *sumExpressionDesc = [NSExpressionDescription new];
    sumExpressionDesc.name = @"sumDeals";
    
    // 3
    NSExpression *specialCountExp = [NSExpression expressionForKeyPath:@"specialCount"];
    sumExpressionDesc.expression = [NSExpression expressionForFunction:@"sum:" arguments:@[specialCountExp]];
    sumExpressionDesc.expressionResultType = NSInteger32AttributeType;
    
    // 4
    fetchRequest.propertiesToFetch = @[sumExpressionDesc];
    
    // 5
    NSError * _Nullable error = nil;
    
    NSArray *results = [self.coreDataStack.managedContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"count not fetched %@, %@", error, error.userInfo);
        return;
    }
    
    NSDictionary *resultDict = results.firstObject;
    NSInteger numDeals = [(NSNumber *)resultDict[@"sumDeals"] integerValue];
    NSString *pluralized = (numDeals == 1) ? @"deal" : @"deals";
    
    self.numDealsLabel.text = [NSString stringWithFormat:@"%lu %@", numDeals, pluralized];
}

@end

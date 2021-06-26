//
//  ViewController.m
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import "ViewController.h"
#import "FilterViewController.h"
#import "CoreDataStack.h"
#import "Venue.h"

static NSString * const filterViewControllerSegueIdentifier = @"toFilterViewController";
static NSString * const venueCellIdentifier = @"VenueCell";

@interface ViewController () <UITableViewDataSource, FilterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property CoreDataStack *coreDataStack;
@property NSFetchRequest<Venue *> * _Nullable fetchRequest;
@property NSArray *venues;
@property NSAsynchronousFetchRequest * _Nullable asyncFetchRequest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    
    [self importJSONSeedDataIfNeeded];
    
    // fetchRequest
    NSManagedObjectModel *model = self.coreDataStack.managedContext.persistentStoreCoordinator.managedObjectModel;
    NSFetchRequest<Venue *> *fetchRequest = [model fetchRequestTemplateForName:@"FetchRequest"]; // BubbleTeaFinder.xcdatamodeld 안에 있는 FetchRequest
    self.fetchRequest = fetchRequest;
//    self.fetchRequest = [Venue _fetchRequest];
    
    // 동기
    [self fetchAndReload];
    
    // 비동기
    self.asyncFetchRequest = [[NSAsynchronousFetchRequest<Venue *> alloc] initWithFetchRequest:self.fetchRequest
                                                                               completionBlock:^(NSAsynchronousFetchResult<Venue *> * _Nonnull result) {
        
        NSArray *venues = result.finalResult;
        if (venues == nil) return;
        
        self.venues = venues;
        [self.tableView reloadData];
    }];
    
    if (self.asyncFetchRequest == nil) return;
    
    NSError * _Nullable error = nil;
    [self.coreDataStack.managedContext executeRequest:self.asyncFetchRequest error:&error];
    
    if (error) {
        NSLog(@"Could not fetch, %@, %@", error, error.userInfo);
    }
    
    // Fetch에서 데이터 가져와서 modify하는 과정없이, 바로 batch로 수정해준다.
    NSBatchUpdateRequest *batchUpdate = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Venue"];
    batchUpdate.propertiesToUpdate = @{@"favorite": [NSNumber numberWithBool:YES]};
    batchUpdate.affectedStores = self.coreDataStack.managedContext.persistentStoreCoordinator.persistentStores;
    batchUpdate.resultType = NSUpdatedObjectsCountResultType;
    
    NSBatchUpdateResult *batchResult = [self.coreDataStack.managedContext executeRequest:batchUpdate error:&error];
    
    if (error) {
        NSLog(@"Could not fetch, %@, %@", error, error.userInfo);
        return;
    }
    
    NSLog(@"Records updated: %@", batchResult.result);
}

- (void)setAttributes {
    self.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"BubbleTeaFinder"];
    self.fetchRequest = nil;
    self.venues = @[];
    self.asyncFetchRequest = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:filterViewControllerSegueIdentifier]) return;
    UINavigationController *navController = segue.destinationViewController;
    FilterViewController *filterVC = (FilterViewController *)navController.topViewController;
    
    if (![filterVC isKindOfClass:[FilterViewController class]]) return;
    
    filterVC.coreDataStack = self.coreDataStack;
    filterVC.delegate = self;
}

#pragma mark Data loading

- (void)importJSONSeedDataIfNeeded {
    NSFetchRequest<Venue *> *fetchRequest = [NSFetchRequest<Venue *> fetchRequestWithEntityName:@"Venue"];
    
    NSError * _Nullable error = nil;
    
    NSUInteger venueCount = [self.coreDataStack.managedContext countForFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error fetching: %@, %@", error, error.userInfo);
        return;
    }
    
    if (venueCount != 0) return;
    
    [self importJSONSeedData:&error];
    
    if (error) {
        NSLog(@"Error fetching: %@, %@", error, error.userInfo);
        return;
    }
}

- (void)importJSONSeedData:(NSError **)error {
    NSURL *jsonURL = [NSBundle.mainBundle URLForResource:@"seed" withExtension:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:jsonURL options:0 error:error];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingFragmentsAllowed error:error];
    NSDictionary *responseDict = jsonDict[@"response"];
    NSArray *jsonArray = responseDict[@"venues"];
    
    for (NSDictionary *jsonDictionary in jsonArray) {
        NSDictionary *contactDict = jsonDictionary[@"contact"];
        NSDictionary *specialsDict = jsonDictionary[@"specials"];
        NSDictionary *locationDict = jsonDictionary[@"location"];
        NSDictionary *priceDict = jsonDictionary[@"price"];
        NSDictionary *statsDict = jsonDictionary[@"stats"];
        
        NSString *venueName = jsonDictionary[@"name"];
        NSString *venuePhone = contactDict[@"phone"];
        int32_t specialCount = [(NSNumber *)specialsDict[@"count"] intValue];
        
        Location *location = [[Location alloc] initWithContext:self.coreDataStack.managedContext];
        location.address = locationDict[@"address"];
        location.city = locationDict[@"city"];
        location.state = locationDict[@"state"];
        location.zipcode = locationDict[@"postalCode"];
        location.distance = [(NSNumber *)locationDict[@"distance"] floatValue];
        
        Category *category = [[Category alloc] initWithContext:self.coreDataStack.managedContext];
        
        PriceInfo *priceInfo = [[PriceInfo alloc] initWithContext:self.coreDataStack.managedContext];
        priceInfo.priceCategory = priceDict[@"currency"];
        
        Stats *stats = [[Stats alloc] initWithContext:self.coreDataStack.managedContext];
        stats.checkinsCount = [(NSNumber *)statsDict[@"checkinsCount"] intValue];
        stats.tipCount = [(NSNumber *)statsDict[@"tipCount"] intValue];
        
        Venue *venue = [[Venue alloc] initWithContext:self.coreDataStack.managedContext];
        venue.name = venueName;
        venue.phone = venuePhone;
        venue.specialCount = specialCount;
        venue.location = location;
        venue.category = category;
        venue.priceInfo = priceInfo;
        venue.stats = stats;
    }
    
    [self.coreDataStack saveContext];
}

#pragma mark - Helper methods

- (void)fetchAndReload {
    if (self.fetchRequest == nil) return;
    
    NSError * _Nullable error = nil;
    
    self.venues = [self.coreDataStack.managedContext executeFetchRequest:self.fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Could not fetch %@, %@", error, error.userInfo);
        return;
    }
    
    [self.tableView reloadData];
}

#pragma mark - FilterViewControllerDelegate

- (void)filterViewController:(FilterViewController *)filter didSelectPredicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    
    if (self.fetchRequest == nil) return;
    
    self.fetchRequest.predicate = nil;
    self.fetchRequest.sortDescriptors = nil;
    
    self.fetchRequest.predicate = predicate;
    
    if (sortDescriptor) {
        self.fetchRequest.sortDescriptors = @[sortDescriptor];
    }
    
    [self fetchAndReload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:venueCellIdentifier forIndexPath:indexPath];
    
    Venue *venue = self.venues[indexPath.row];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = venue.priceInfo.priceCategory;
    return cell;
}

@end

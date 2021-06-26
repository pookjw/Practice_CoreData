//
//  ViewController.m
//  DogWalk
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "ViewController.h"
#import "CoreDataStack.h"
#import "Dog.h"
#import "Walk.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSDateFormatter *dateFormatter;
@property CoreDataStack *coreDataStack;
@property Dog * _Nullable currentDog;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    self.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"DogWalk"];
    self.currentDog = nil;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    NSString *dogName = @"Fido";
    NSFetchRequest<Dog *> *dogFetch = [Dog _fetchRequest];
    dogFetch.predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", dogName];
    
    NSError * _Nullable error = nil;
    NSArray *results = [self.coreDataStack.managedContext executeFetchRequest:dogFetch error:&error];
    
    if (error) {
        NSLog(@"Fetch error: %@ description: %@", error, error.userInfo);
        return;
    }
    
    if (results.count == 0) {
        // Fido not found, create Fido
        self.currentDog = [[Dog alloc] initWithContext:self.coreDataStack.managedContext];
        self.currentDog.name = dogName;
        [self.coreDataStack saveContext];
    } else {
        // Fido found, use Fido
        self.currentDog = results.firstObject;
    }
}

- (IBAction)addButtonTouched:(UIBarButtonItem *)sender {
    // Insert a new Walk entity into Core Data
    Walk *walk = [[Walk alloc] initWithContext:self.coreDataStack.managedContext];
    walk.date = [NSDate new];
    
    // Insert the new Walk into the Dog's walks set
    Dog *dog = self.currentDog;
    NSMutableOrderedSet *walks = [dog.walks mutableCopy];
    
    if (walks) {
        [walks addObject:walk];
        dog.walks = [walks copy];
    }
    
    // Save the managed object context
    [self.coreDataStack saveContext];
    
    // Reload table view
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentDog.walks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Walk *walk = self.currentDog.walks[indexPath.row];
    NSDate *walkDate = walk.date;
    
    cell.textLabel.text = [self.dateFormatter stringFromDate:walkDate];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"List of Walks";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1
    Walk *walkToRemove = self.currentDog.walks[indexPath.row];
    
    if ((walkToRemove == nil) || (editingStyle != UITableViewCellEditingStyleDelete)) {
        return;
    }
    
    // 2
    [self.coreDataStack.managedContext deleteObject:walkToRemove];
    
    // 3
    [self.coreDataStack saveContext];
    
    // 4
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

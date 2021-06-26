//
//  ViewController.m
//  HitList
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *people;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.people = [@[] mutableCopy];
    
    self.title = @"The List";
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    
    if (![appDelegate isKindOfClass:[AppDelegate class]]) {
        return;
    }
    
    NSManagedObjectContext *managedContext = appDelegate.persistentContainer.viewContext;
    
    // 2
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    
    // 3
    NSError * _Nullable error = nil;
    
    self.people = [[managedContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Could npt fetch, %@, %@", error, error.userInfo);
    }
}

- (IBAction)addName:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Name"
                                                                   message:@"Add a new name"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField * _Nullable textField = alert.textFields.firstObject;
        NSString * _Nullable nameToSave = textField.text;
        
        if (nameToSave == nil) return;
        
        [self saveName:nameToSave];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {}];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)saveName:(NSString *)name {
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    
    if (![appDelegate isKindOfClass:[AppDelegate class]]) {
        return;
    }
    
    // 1
    NSManagedObjectContext *managedContext = appDelegate.persistentContainer.viewContext;
    
    // 2
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person"
                                              inManagedObjectContext:managedContext];
    
    NSManagedObject *person = [[NSManagedObject alloc] initWithEntity:entity
                                       insertIntoManagedObjectContext:managedContext];
    
    // 3
    [person setValue:name forKey:@"name"];
    
    // 4
    NSError * _Nullable error = nil;
    [managedContext save:&error];
    
    if (error) {
        NSLog(@"Could npt fetch, %@, %@", error, error.userInfo);
    } else {
        [self.people addObject:person];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *person = self.people[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = (NSString *)[person valueForKeyPath:@"name"];
    return cell;
}

@end

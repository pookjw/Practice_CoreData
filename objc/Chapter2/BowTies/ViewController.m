//
//  ViewController.m
//  BowTies
//
//  Created by Jinwoo Kim on 6/26/21.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "BowTie.h"

@interface UIColor (Category)
+ (UIColor * _Nullable)colorFromDict:(NSDictionary<NSString *, id> *)dict;
@end

@implementation UIColor (Category)
+ (UIColor * _Nullable)colorFromDict:(NSDictionary<NSString *, id> *)dict {
    NSNumber *red = dict[@"red"];
    NSNumber *green = dict[@"green"];
    NSNumber *blue = dict[@"blue"];
    
    return [[UIColor alloc] initWithRed:[red floatValue]/255
                                  green:[green floatValue]/255
                                   blue:[blue floatValue]/255
                                  alpha:1];
}
@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesWornLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastWornLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *wearButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property NSManagedObjectContext *managedContext;
@property BowTie *currentBowTie;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    self.managedContext = appDelegate.persistentContainer.viewContext;
    
    // 1
    [self insertSampleData];
    
    // 2
    NSFetchRequest<BowTie *> *request = [BowTie _fetchRequest];
    NSString *firstTitle = [self.segmentedControl titleForSegmentAtIndex:0];
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"searchKey", firstTitle];
    
    NSError * _Nullable error = nil;
    
    // 3
    NSArray *results = [self.managedContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Could not save %@, %@", error, error.userInfo);
        return;
    }
    
    // 4
    BowTie *tie = results.firstObject;
    if (tie) {
        [self populate:tie];
        self.currentBowTie = tie;
    }
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSString *selectedValue = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    if (selectedValue == nil) return;
    
    NSFetchRequest<BowTie *> *request = [BowTie _fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"searchKey", selectedValue];
    
    NSError * _Nullable error = nil;
    
    NSArray *results = [self.managedContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Could not save %@, %@", error, error.userInfo);
        return;
    }
    
    self.currentBowTie = results.firstObject;
    [self populate:self.currentBowTie];
}

- (IBAction)wearButtonTouched:(UIButton *)sender {
    self.currentBowTie.timesWorn += 1;
    self.currentBowTie.lastWorn = [NSDate new];
    
    NSError * _Nullable error = nil;
    [self.managedContext save:&error];
    
    if (error) {
        NSLog(@"Could not save %@, %@", error, error.userInfo);
        return;
    }
    [self populate:self.currentBowTie];
}

- (IBAction)rateButtonTouched:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Rating"
                                                                   message:@"Rate this bow tie"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        [self update:textField.text];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:saveAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)insertSampleData {
    NSFetchRequest<BowTie *> *fetch = [BowTie _fetchRequest];
    fetch.predicate = [NSPredicate predicateWithFormat:@"searchKey != nil"];
    
    NSUInteger tieCount = [self.managedContext countForFetchRequest:fetch error:nil];
    
    // SampleData.plist data already in Core Data
    if (tieCount > 0) return;
    
    NSString *path = [NSBundle.mainBundle pathForResource:@"SampleData" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *dic in dataArray){
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BowTie" inManagedObjectContext:self.managedContext];
        BowTie *bowTie = [[BowTie alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedContext];
        NSDictionary<NSString *, id> *btDict = dic;
        
        bowTie.id = [[NSUUID alloc] initWithUUIDString:btDict[@"id"]];
        bowTie.name = btDict[@"name"];
        bowTie.searchKey = btDict[@"searchKey"];
        bowTie.rating = [(NSNumber *)btDict[@"rating"] doubleValue];
        
        NSDictionary<NSString *, id> *colorDict = btDict[@"tintColor"];
        bowTie.tintColor = [UIColor colorFromDict:colorDict];
        
        NSString *imageName = btDict[@"imageName"];
        UIImage *image= [UIImage imageNamed:imageName];
        bowTie.photoData = UIImagePNGRepresentation(image);
        bowTie.lastWorn = btDict[@"lastWorn"];
        
        bowTie.timesWorn = [(NSNumber *)btDict[@"timesWorn"] intValue];
        bowTie.isFavorite = [(NSNumber *)btDict[@"isFavorite"] boolValue];
        bowTie.url = [NSURL URLWithString:btDict[@"url"]];
    }
}

- (void)populate:(BowTie *)bowtie {
    NSData *imageData = bowtie.photoData;
    NSDate *lastWorn = bowtie.lastWorn;
    UIColor *tintColor = bowtie.tintColor;
    
    self.imageView.image = [UIImage imageWithData:imageData];
    self.nameLabel.text = bowtie.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %f/5", bowtie.rating];
    
    self.timesWornLabel.text = [NSString stringWithFormat:@"# times worn: %u", bowtie.timesWorn];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    self.lastWornLabel.text = [NSString stringWithFormat:@"Last worn: %@", [dateFormatter stringFromDate:lastWorn]];
    
    self.favoriteLabel.hidden = !bowtie.isFavorite;
    self.view.tintColor = tintColor;
}

- (void)update:(NSString * _Nullable)rating {
    NSString * ratingString = rating;
    double ratingDouble = [ratingString doubleValue];
    
    NSError * _Nullable error = nil;
    
    self.currentBowTie.rating = ratingDouble;
    [self.managedContext save:&error];
    
    if (error) {
        if (([error.domain isEqualToString:NSCocoaErrorDomain]) && ((error.code == NSValidationNumberTooLargeError) || (error.code == NSValidationNumberTooSmallError))) {
            [self rateButtonTouched:self.rateButton];
        } else {
            NSLog(@"Could not save %@, %@", error, error.userInfo);
        }
    }
    [self populate:self.currentBowTie];
}

@end

//
//  AppDelegate.h
//  BubbleTeaFinder
//
//  Created by Jinwoo Kim on 6/27/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


//
//  AppDelegate.m
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize backgroundTask;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"7DTQOAGWaktNFcPvqCrfOm1SldQUhp8nsgc2M7Kr"
                  clientKey:@"X0oESrvjrwnRyMI3RQndQjxEFkQlaRkGkt1dsFLz"];
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification) {
        [application cancelAllLocalNotifications];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)gettingData{
    PFQuery *objects = [PFQuery queryWithClassName:@"Results"];
    [objects orderByDescending:@"Points"];
    
    [objects findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSInteger currentMaxPoints = [objects[0][@"Points"] integerValue];
        
        if (currentMaxPoints > self.lastMaxPoints) {
            if (self.calledForFirstTime == NO) {
                // Notification
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                
                localNotification.fireDate = [NSDate date];
                
                localNotification.alertBody = @"The Max score was BEATEN !!!";
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                
                [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
            }
        }
        
        self.lastMaxPoints = currentMaxPoints;
        
        if (self.calledForFirstTime == YES) {
            self.calledForFirstTime = NO;
        }
        
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.calledForFirstTime = YES;
    
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    gettingDataTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(gettingData) userInfo:nil repeats:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [gettingDataTimer invalidate];
    
    [application endBackgroundTask:backgroundTask];
    backgroundTask = UIBackgroundTaskInvalid;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FlappyNinja" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FlappyNinja.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end

//
//  AppDelegate.h
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    UIBackgroundTaskIdentifier backgroundTask;
    NSTimer *gettingDataTimer;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic) NSInteger lastMaxPoints;
@property (nonatomic) BOOL calledForFirstTime;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

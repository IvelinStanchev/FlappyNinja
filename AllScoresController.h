//
//  AllScoresController.h
//  FlappyNinja
//
//  Created by Test Test on 11/2/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AllScoresController : UITableViewController<ABPeoplePickerNavigationControllerDelegate, UIAccelerometerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong) NSMutableArray *dataArray;
@property (strong) UIAlertView *gettingDataAlert;
@property (strong, nonatomic) IBOutlet UILabel *position;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *points;

@property (strong, nonatomic) IBOutlet UITableView *allScoresView;

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration;

@end

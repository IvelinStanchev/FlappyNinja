//
//  MyScoresController.h
//  FlappyNinja
//
//  Created by Test Test on 11/2/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyScoresController : UITableViewController<UIAlertViewDelegate>

@property (strong) NSMutableArray *scoresArray;
@property (strong) UIAlertView *gettingDataAlert;

-(void)publishCurrentRow: (int) rowIndex;

@end

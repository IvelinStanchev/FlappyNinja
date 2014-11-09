//
//  TableViewController.h
//  FlappyNinja
//
//  Created by admin on 11/8/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewCustom;

@end

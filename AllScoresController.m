//
//  AllScoresController.m
//  FlappyNinja
//
//  Created by Test Test on 11/2/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "AllScoresController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AllScoresCell.h"
#import "GameController.h"

@interface AllScoresController ()

@property (nonatomic, strong) NSString *dataFilePath;
@property AllScoresCell *allScoresCell;
@property int lastTappedIndex;

@end

@implementation AllScoresController

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return  context;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {
        // custom initialization
    }
    
    return  self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
    double const kThreshold = 2.0;
    if (   fabsf(acceleration.x) > kThreshold
        || fabsf(acceleration.y) > kThreshold
        || fabsf(acceleration.z) > kThreshold) {
        [self downloadData];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.allScoresView];
    
    NSIndexPath *indexPath = [self.allScoresView indexPathForRowAtPoint: point];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (![self.dataArray[indexPath.row][@"PhoneNumber"] isKindOfClass:[NSNull class]]) {
            
            _lastTappedIndex = indexPath.row;

            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Add %@ to your contacts?", self.dataArray[indexPath.row][@"Username"]]
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"Add", nil] show];
            
        }
        else{
           [[[UIAlertView alloc] initWithTitle:@"The user doesn't have phone number!"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Close"
                                                     otherButtonTitles:nil] show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        //Add to contacts logic
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
        ABRecordRef newPerson = ABPersonCreate();
        
        NSString *firstName = self.dataArray[_lastTappedIndex][@"Username"];
        
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, CFBridgingRetain(firstName), nil);
        
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(self.dataArray[_lastTappedIndex][@"PhoneNumber"]), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
        CFRelease(multiPhone);
        
        ABAddressBookAddRecord(iPhoneAddressBook, newPerson, nil);
        ABAddressBookSave(iPhoneAddressBook, nil);
        
        CFRelease(newPerson);
        CFRelease(iPhoneAddressBook);
        
        [[[UIAlertView alloc] initWithTitle:@"Contact added successfully!"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

- (void)viewDidLoad {
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.5; //seconds
    longPressRecognizer.delegate = self;
    [self.allScoresView addGestureRecognizer: longPressRecognizer];
    
    [self downloadData];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-view-background.png"]];
    
    [super viewDidLoad];
}

- (void) downloadData{
    self.gettingDataAlert = [[UIAlertView alloc] initWithTitle:@"Getting information!"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    
    [self.gettingDataAlert show];
    
    PFQuery *objects = [PFQuery queryWithClassName:@"Results"];
    [objects orderByDescending:@"Points"];
    
    [objects findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.dataArray = [[NSMutableArray alloc] init];
        
        [self.gettingDataAlert dismissWithClickedButtonIndex:-1 animated:YES];
        
        for (int i = 0; i < [objects count]; i++) {
            [self.dataArray addObject: objects[i]];
        }
        
        [self.tableView reloadData];
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 0.25;
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AllScoresCell";
    
    AllScoresCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = (AllScoresCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"table-view-background-dark-cell.png"]];
    }
    
    cell.position.textColor = [UIColor yellowColor];
    cell.position.font = [UIFont fontWithName: @"Papyrus" size: 20.0];
    
    cell.username.textColor = [UIColor whiteColor];
    cell.username.font = [UIFont fontWithName: @"Papyrus" size: 26.0];
    
    cell.points.textColor = [UIColor yellowColor];
    cell.points.font = [UIFont fontWithName: @"Papyrus" size: 21.0];
    
    cell.position.text = [NSString stringWithFormat:@"%i#", indexPath.row + 1];
    cell.username.text = [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:indexPath.row][@"Username"]];
    cell.points.text = [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:indexPath.row][@"Points"]];
    
    return cell;
}

@end

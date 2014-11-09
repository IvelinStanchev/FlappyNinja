//
//  MyScoresController.m
//  FlappyNinja
//
//  Created by Test Test on 11/2/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "MyScoresController.h"
#import "GameController.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "MyScoresCell.h"

@interface MyScoresController ()<CLLocationManagerDelegate>

@property int lastTapIndex;

@end

@implementation MyScoresController{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

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

- (void)viewDidLoad {
    _lastTapIndex = -1;
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    self.gettingDataAlert = [[UIAlertView alloc] initWithTitle:@"Getting information!"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    
    [self.gettingDataAlert show];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scores-background.png"]];
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scores"];
    
    self.scoresArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.gettingDataAlert dismissWithClickedButtonIndex:-1 animated:YES];
    
    [self.tableView reloadData];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _lastTapIndex) {
        [self publishCurrentRow: indexPath.row];
    }
    
    _lastTapIndex = indexPath.row;
}

-(void)publishCurrentRow: (int) row{
    
    [[[UIAlertView alloc] initWithTitle:@"Want to publish this score?"
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Ok", nil] show];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Failed to get location!"
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)locationManager:(CLLocationManager *)receivedManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
            NSString *currentCountry = placemark.country;
            
            NSManagedObject *device = [self.scoresArray objectAtIndex: _lastTapIndex];
            
            PFObject *userData = [PFObject objectWithClassName:@"Results"];
            userData[@"Username"] = [device valueForKey:@"username"];
            userData[@"PhoneNumber"] = [NSNull null];
            userData[@"Points"] = [device valueForKey:@"userscore"];
            userData[@"Country"] = currentCountry;
            
            UIAlertView *waitingAlert = [[UIAlertView alloc] initWithTitle:@"Uploading data!"
                                                                   message:nil                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            
            [waitingAlert show];
            
            [userData saveInBackground];
            
            [receivedManager stopUpdatingLocation];
            
            [waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            
            [[[UIAlertView alloc] initWithTitle:@"Successfully sent result!"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            [self.view endEditing:YES];
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error occurred!"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
        
    } ];
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        //Publish logic
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else {
            manager.delegate = self;
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            [manager startUpdatingLocation];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scoresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyScoresCell";
    
    MyScoresCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = (MyScoresCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"scores-background-dark-cell.png"]];
    }
    
    NSManagedObject *device = [self.scoresArray objectAtIndex:indexPath.row];
    
    cell.username.textColor = [UIColor whiteColor];
    cell.username.font = [UIFont fontWithName: @"Papyrus" size: 24.0];

    cell.points.textColor = [UIColor yellowColor];
    cell.points.font = [UIFont fontWithName: @"Papyrus" size: 18.0];
    
    cell.date.textColor = [UIColor whiteColor];
    cell.date.font = [UIFont fontWithName: @"Papyrus" size: 17.0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate: [device valueForKey:@"scoredate"]];
    
    cell.username.text = [NSString stringWithFormat:@"%@", [device valueForKey:@"username"]];
    cell.points.text = [NSString stringWithFormat:@"%@", [device valueForKey:@"userscore"]];
    cell.date.text = formattedDateString;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete from db
        [context deleteObject:[self.scoresArray objectAtIndex:indexPath.row]];
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Cant delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // remove devise from the table
        [self.scoresArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"UpdateScores"]) {
        
        NSManagedObject *selectedDevice = [self.scoresArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        GameController *destViewController = segue.destinationViewController;
        destViewController.scoresdb = selectedDevice;
    }
}

@end

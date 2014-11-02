//
//  GameController.m
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "GameController.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>

@interface GameController ()<CLLocationManagerDelegate>

@end

@implementation GameController{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@synthesize audioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
//    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
//    doubleTapGesture.numberOfTapsRequired = 2;
//    [self.view addGestureRecognizer:doubleTapGesture];
//    
//    singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//    singleTapGesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:singleTapGesture];
//    
//    [self performSelector: @selector(GetObjects)];
    
//    self.longPresses = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
//    self.longPresses.minimumPressDuration = 1.0f;
//    self.longPresses.allowableMovement = 100.0f;
//    
//    [self.view addGestureRecognizer: self.longPresses];
    
    //For Location
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    pathToGetPointSound = [[NSBundle mainBundle] pathForResource:@"get-point-effect" ofType:@"mp3"];
    audioPlayerGetPointSound = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathToGetPointSound] error:NULL];
    [audioPlayerGetPointSound prepareToPlay];
    
    pathToNinjaCrashSound = [[NSBundle mainBundle] pathForResource:@"ninja-down-effect" ofType:@"mp3"];
    audioPlayerNinjaCrash = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathToNinjaCrashSound] error:NULL];
    [audioPlayerNinjaCrash prepareToPlay];
    
    Username.hidden = YES;
    TryAgain.hidden = YES;
    SaveToMyScores.hidden = YES;
    PublishScoresButton.hidden = YES;
    PhoneNumber.hidden = YES;
    ErrorMessageLabel.hidden = YES;
    
    ninjaDown = YES;
    
    ColumnTop.hidden = YES;
    ColumnBottom.hidden = YES;
    
    gameHasBegun = NO;
    
    isCalled = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GameOver{
    
    [audioPlayerNinjaCrash play];
    
    [NinjaMovement invalidate];
    [TunnelMovement invalidate];
    
    
    
    NinjaMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(NinjaMovingWhenGameOver) userInfo:nil repeats:YES];
    
    ninjaDownCount = 0;
    
    ninjaDown = NO;
    
    
}

-(void)TunnelMoving{
    
    ColumnTop.center = CGPointMake(ColumnTop.center.x - 1.2, ColumnTop.center.y);
    ColumnBottom.center = CGPointMake(ColumnBottom.center.x - 1.2, ColumnBottom.center.y);
    
    if (ColumnTop.center.x < -28) {
        isCalled = NO;
        [self PlaceTunnels];
    }
    
    if (ColumnTop.center.x < 0 && isCalled == NO) {
        isCalled = YES;
        [self Score];
    }
    
    if (CGRectIntersectsRect(Ninja.frame, ColumnTop.frame)) {
        [self GameOver];
    }
    
    if (CGRectIntersectsRect(Ninja.frame, ColumnBottom.frame)) {
        [self GameOver];
    }
    
    if (CGRectIntersectsRect(Ninja.frame, Bottom.frame)) {
        [self GameOver];
    }
    
    if (CGRectIntersectsRect(Ninja.frame, Top.frame)) {
        [self GameOver];
    }
}


-(void)PlaceTunnels{
    
    RandomTopTunnelPosition = arc4random() %350;
    RandomTopTunnelPosition = RandomTopTunnelPosition - 200;
    RandomBottomTunnelPosition = RandomTopTunnelPosition + 660;
    
    ColumnTop.center = CGPointMake(340, RandomTopTunnelPosition);
    ColumnBottom.center = CGPointMake(340, RandomBottomTunnelPosition);
    
    
}

-(void)NinjaMovingWhenGameOver{
    ninjaDownCount++;
    
    Ninja.center = CGPointMake(Ninja.center.x, Ninja.center.y - NinjaFlight);
    
    if (ninjaDownCount % 5 == 0) {
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-down.png"];
    }
    else{
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-flipped.png"];
    }
    
    NinjaFlight = NinjaFlight - 5;
    
    if (NinjaFlight < -20) {
        NinjaFlight = -20;
    }
    
    if (Ninja.center.y >= [[UIScreen mainScreen] bounds].size.height - 50) {
        ninjaDown = YES;
        ColumnTop.hidden = YES;
        ColumnBottom.hidden = YES;
        Ninja.hidden = YES;
        
        Username.hidden = NO;
        TryAgain.hidden = NO;
        SaveToMyScores.hidden = NO;
        PhoneNumber.hidden = NO;
        PublishScoresButton.hidden = NO;
    }
}

- (IBAction)PublishScore:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                    message:@"No connection available!"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        if ([Username.text isEqualToString: @""]) {
            ErrorMessageLabel.hidden = NO;
            ErrorMessageLabel.text = @"Invalid username!";
        }
        else if ([PhoneNumber.text isEqualToString: @""]) {
            ErrorMessageLabel.hidden = NO;
            ErrorMessageLabel.text = @"Invalid phone number!";
        }
        else{
            ErrorMessageLabel.hidden = YES;
            
            manager.delegate = self;
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            [manager startUpdatingLocation];
            
            
            
            
            
        }
    }
}

- (IBAction)SaveToMyScores:(id)sender {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [[[UIAlertView alloc] initWithTitle:@"Failed to get location!"
                                message:@"Failed to get location!"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
//            self.address.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
//                                 placemark.subThoroughfare, placemark.thoroughfare,
//                                 placemark.postalCode, placemark.locality,
//                                 placemark.administrativeArea,
//                                 placemark.country];
            
            NSString *currentCountry = placemark.country;
            
            PFObject *userData = [PFObject objectWithClassName:@"Results"];
            userData[@"Username"] = Username.text;
            userData[@"PhoneNumber"] = PhoneNumber.text;
            userData[@"Points"] = [NSNumber numberWithInt: Scores];
            userData[@"Country"] = currentCountry;
            [userData saveInBackground];
            
            [manager stopUpdatingLocation];
            
            [[[UIAlertView alloc] initWithTitle:@"Successfully sent result!"
                                        message:@"Successfully sent result!"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            [self.view endEditing:YES];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error occurred!"
                                        message:@"Error occurred!"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
        
    } ];
    
}

-(void) GetObjects{
//    PFQuery *objects = [PFQuery queryWithClassName:@"Results"];
//    [objects findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSLog(@"%@", objects[0][@"Points"]);
//    }];
}

- (IBAction)TryAgain:(id)sender {
    [NinjaMovement invalidate];
    
    ErrorMessageLabel.hidden = YES;
    Ninja.hidden = NO;
    Ninja.center = CGPointMake(Ninja.center.x, [[UIScreen mainScreen] bounds].size.height / 2);
    
    ninjaDown = YES;
    
    Ninja.image = [UIImage imageNamed:@"flappy-ninja-up.png"];
    
    TouchToBeginLabel.hidden = NO;
    Scores = 0;
    
    ScoreLabel.text = [NSString stringWithFormat:@"%i", Scores];
    
    Username.hidden = YES;
    TryAgain.hidden = YES;
    SaveToMyScores.hidden = YES;
    PhoneNumber.hidden = YES;
    PublishScoresButton.hidden = YES;
    
    ColumnTop.hidden = YES;
    ColumnBottom.hidden = YES;
    
    gameHasBegun = NO;
    
    isCalled = NO;
}

-(void)NinjaMoving{
    
    Ninja.center = CGPointMake(Ninja.center.x, Ninja.center.y - NinjaFlight);
    
    NinjaFlight = NinjaFlight - 5;
    
    if (NinjaFlight < -15) {
        NinjaFlight = -15;
    }
    
    if (NinjaFlight > 0) {
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-up.png"];
    }
    
    if (NinjaFlight < 0) {
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-down.png"];
    }
    
    
    
}

-(void)Score{
    
    Scores++;
    [self GetPointSound];
    
    ScoreLabel.text = [NSString stringWithFormat:@"%i", Scores];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (gameHasBegun == NO) {
        gameHasBegun = YES;
        
        ColumnTop.hidden = NO;
        ColumnBottom.hidden = NO;
        
        TouchToBeginLabel.hidden = YES;
        
        Scores = 0;
        
        NinjaMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(NinjaMoving) userInfo:nil repeats:YES];
        
        [self PlaceTunnels];
        
        TunnelMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(TunnelMoving) userInfo:nil repeats:YES];
    }
    
    if (ninjaDown == YES) {
        NinjaFlight = 20;
    }
}

-(void)GetPointSound{
    [audioPlayerGetPointSound play];
}

//- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
//{
//    if ([sender isEqual: self.longPresses]) {
//        if (sender.state == UIGestureRecognizerStateBegan)
//        {
//            
//
//        }
//    }
//}
//
//- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateRecognized) {
//        NSLog(@"Double Tap");
//        
//        if (gameHasBegun == NO) {
//            gameHasBegun = YES;
//            
//            ColumnTop.hidden = NO;
//            ColumnBottom.hidden = NO;
//            
//            TouchToBeginLabel.hidden = YES;
//            
//            Scores = 0;
//            
//            NinjaMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(NinjaMoving) userInfo:nil repeats:YES];
//            
//            [self PlaceTunnels];
//            
//            TunnelMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(TunnelMoving) userInfo:nil repeats:YES];
//        }
//        else{
//            NinjaFlight = 20;
//
//        }
//    }
//}
//
//- (void)handleSingleTapGesture:(UITapGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateRecognized) {
//        NSLog(@"Tap");
//        
//        if (ninjaDown == YES) {
//            NinjaFlight = 20;
//        }
//    }
//}


@end

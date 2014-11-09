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

@property (nonatomic,strong) UILongPressGestureRecognizer *longPresses;
@property (nonatomic) int scores;
@property (nonatomic) int NinjaFlight;
@property (nonatomic) int RandomTopTunnelPosition;
@property (nonatomic) int RandomBottomTunnelPosition;
@property (nonatomic) int RandomStarPosition;
@property (nonatomic) int RandomTopColumnHeight;
@property (nonatomic) BOOL isCalled;
@property (nonatomic) BOOL gameHasBegun;
@property (nonatomic) BOOL ninjaDown;
@property (nonatomic) BOOL isCalledFromStar;
@property (nonatomic) UIImageView *starAnimationSubView;
@property (nonatomic) int ninjaDownCount;
@property (nonatomic) NSString *pathToGetPointSound;
@property (nonatomic) NSString *pathToNinjaCrashSound;

@end

@implementation GameController{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    double tunnelsMovingSpeed;
    int refreshingTunnelsMinimumWidth;
    double starMovingSpeed;
    int maximumTopTunnelHeightPositionForRandom;
    int minimumTopTunnelHeightPosition;
    int differenceBetweenTopAndBottom;
    int differenceBetweenEachPairOfTunnels;
    int refreshingStarMinimumWidth;
    int maximumStarHeightPositionForRandom;
    int minimumStarHeightPosition;
    int minimumStarWidthPosition;
    int maximumWidthForAddingToStarWidth;
    
    int starBeginingX;
    int starBeginingY;
    
    int minimumNinjaFlight;
    int minimumNinjaFlightWhenGameOver;
    int maximumNinjaFlight;
    
    
    int updatingNinjaFlight;
    
    int maximumViewBoundHeightForCollision;
    
    NSArray *frames;
}

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

    
    tunnelsMovingSpeed = 1.2;
    refreshingTunnelsMinimumWidth = -28;
    starMovingSpeed = 1.2;
    
    maximumTopTunnelHeightPositionForRandom = 350;
    minimumTopTunnelHeightPosition = 200;
    differenceBetweenTopAndBottom = 660;
    differenceBetweenEachPairOfTunnels = 340;
    
    refreshingStarMinimumWidth = -5;
    maximumStarHeightPositionForRandom = 450;
    minimumStarHeightPosition = 50;
    minimumStarWidthPosition = 120;
    maximumWidthForAddingToStarWidth = 100;
    starBeginingX = -100;
    starBeginingY = 100;
    
    
    minimumNinjaFlightWhenGameOver = -20;
    minimumNinjaFlight = -15;
    maximumNinjaFlight = 20;
    updatingNinjaFlight = -5;
    maximumViewBoundHeightForCollision = [[UIScreen mainScreen] bounds].size.height - 50;
    
    //For Location
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    //
    
    self.pathToGetPointSound = [[NSBundle mainBundle] pathForResource:@"get-point-effect" ofType:@"mp3"];
    audioPlayerGetPointSound = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.pathToGetPointSound] error:NULL];
    [audioPlayerGetPointSound prepareToPlay];
    
    self.pathToNinjaCrashSound = [[NSBundle mainBundle] pathForResource:@"ninja-down-effect" ofType:@"mp3"];
    audioPlayerNinjaCrash = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.pathToNinjaCrashSound] error:NULL];
    [audioPlayerNinjaCrash prepareToPlay];
    
    Username.hidden = YES;
    TryAgain.hidden = YES;
    SaveToMyScores.hidden = YES;
    PublishScoresButton.hidden = YES;
    PhoneNumber.hidden = YES;
    ErrorMessageLabel.hidden = YES;
    ExitButton.hidden = YES;
    
    self.ninjaDown = YES;
    
    ColumnTop.hidden = YES;
    ColumnBottom.hidden = YES;
    Star.hidden = YES;
    
    self.gameHasBegun = NO;
    
    self.isCalled = NO;
    self.isCalledFromStar = NO;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GameOver{
    [self.starAnimationSubView stopAnimating];
    
    Explosion.center = CGPointMake(Ninja.center.x, Ninja.center.y);
    
    [self explosionAnimation];
        
    [audioPlayerNinjaCrash play];
    
    [NinjaMovement invalidate];
    [TunnelMovement invalidate];
    [StarMovement invalidate];
    
    NinjaMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(NinjaMovingWhenGameOver) userInfo:nil repeats:YES];
    
    self.ninjaDownCount = 0;
    
    self.ninjaDown = NO;
    
}

-(void)TunnelMoving{
    
//    tunnelsMovingSpeed += 0.00001;
//    starMovingSpeed += 0.00001;
    
    ColumnTop.center = CGPointMake(ColumnTop.center.x - tunnelsMovingSpeed, ColumnTop.center.y);
    ColumnBottom.center = CGPointMake(ColumnBottom.center.x - tunnelsMovingSpeed, ColumnBottom.center.y);
    
    if (ColumnTop.center.x < refreshingTunnelsMinimumWidth) {
        self.isCalled = NO;
        [self PlaceTunnels];
    }
    
    if (ColumnTop.center.x < 0 && self.isCalled == NO) {
        self.isCalled = YES;
        [self Score];
    }
    
    frames = [[NSArray alloc] initWithObjects:
              [NSValue valueWithCGRect: ColumnTop.frame],
              [NSValue valueWithCGRect: ColumnBottom.frame],
              [NSValue valueWithCGRect: Bottom.frame],
              [NSValue valueWithCGRect: Top.frame], nil];
    
    if ([self ninjaCollidedWithObject: frames : nil] == YES) {
        [self GameOver];
    }
    
}

- (BOOL) ninjaCollidedWithObject: (NSArray*) framesObjects : (GameController *) controller{
    if (controller) {
        for (int i = 0; i < [framesObjects count]; i++) {
            if (CGRectIntersectsRect(controller.NinjaForTesting.frame, [[framesObjects objectAtIndex: i] CGRectValue])) {
                return YES;
            }
        }
    }
    else{
        for (int i = 0; i < [framesObjects count]; i++) {
            if (CGRectIntersectsRect(Ninja.frame, [[framesObjects objectAtIndex: i] CGRectValue])) {
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)StarMoving{
    
    Star.center = CGPointMake(Star.center.x - starMovingSpeed, Star.center.y);
    
    if (CGRectIntersectsRect(Ninja.frame, Star.frame)) {
        Star.hidden = YES;
    }
    
    if (self.isCalledFromStar == NO && Star.hidden == YES) {
        self.isCalledFromStar = YES;
        [self Score];
    }
}

-(void)PlaceTunnels{
    
    self.RandomTopTunnelPosition = arc4random() %maximumTopTunnelHeightPositionForRandom;
    self.RandomTopTunnelPosition -= minimumTopTunnelHeightPosition;
    self.RandomBottomTunnelPosition = self.RandomTopTunnelPosition + differenceBetweenTopAndBottom;
    
    ColumnTop.center = CGPointMake(differenceBetweenEachPairOfTunnels, self.RandomTopTunnelPosition);
    ColumnBottom.center = CGPointMake(differenceBetweenEachPairOfTunnels, self.RandomBottomTunnelPosition);
    
    if (Star.hidden == YES) {
        Star.hidden = NO;
    }
    
    if (Star.center.x < refreshingStarMinimumWidth) {
        [self PlaceStar];
        self.isCalledFromStar = NO;
    }
    
}

-(void)PlaceStar{
    self.RandomStarPosition = arc4random() %maximumStarHeightPositionForRandom;
    self.RandomStarPosition += minimumStarHeightPosition;
    
    NSInteger randomStartX = arc4random() %maximumWidthForAddingToStarWidth;
    randomStartX += minimumStarWidthPosition;
    
    Star.center = CGPointMake(ColumnTop.center.x + randomStartX, self.RandomStarPosition);
    
    [self.starAnimationSubView removeFromSuperview];
    
    [self starAnimation];
}

-(void)NinjaMovingWhenGameOver{
    self.ninjaDownCount++;
    
    Ninja.center = CGPointMake(Ninja.center.x, Ninja.center.y - self.NinjaFlight);
    
    if (self.ninjaDownCount % 5 == 0) {
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-down.png"];
    }
    else{
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-flipped.png"];
    }
    
    self.NinjaFlight = self.NinjaFlight + updatingNinjaFlight;
    
    if (self.NinjaFlight < minimumNinjaFlightWhenGameOver) {
        self.NinjaFlight = minimumNinjaFlightWhenGameOver;
    }
    
    if (Ninja.center.y >= maximumViewBoundHeightForCollision) {
        self.ninjaDown = YES;
        ColumnTop.hidden = YES;
        ColumnBottom.hidden = YES;
        Ninja.hidden = YES;
        Star.hidden = YES;
        
        Username.hidden = NO;
        TryAgain.hidden = NO;
        SaveToMyScores.hidden = NO;
        PhoneNumber.hidden = NO;
        PublishScoresButton.hidden = NO;
        ExitButton.hidden = NO;
    }
}

- (IBAction)PublishScore:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                    message:nil
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
    
    if ([Username.text isEqualToString: @""]) {
        ErrorMessageLabel.hidden = NO;
        ErrorMessageLabel.text = @"Invalid username!";
    }
    else{
        NSManagedObjectContext *context = [self managedObjectContext];
    
        if (self.scoresdb) {
            [self.scoresdb setValue:Username.text forKey:@"username"];
            [self.scoresdb setValue:[NSNumber numberWithInteger: self.scores] forKey:@"userscore"];
            [self.scoresdb setValue:[NSDate date] forKey:@"scoredate"];
        }
        else {
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Scores" inManagedObjectContext:context];
        
            [newDevice setValue:Username.text forKey:@"username"];
            [newDevice setValue:[NSNumber numberWithInteger: self.scores] forKey:@"userscore"];
            [newDevice setValue:[NSDate date] forKey:@"scoredate"];
        }
    
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
        }
    
        self.NinjaFlight = maximumNinjaFlight;
        
        [NinjaMovement invalidate];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
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
            
            PFObject *userData = [PFObject objectWithClassName:@"Results"];
            userData[@"Username"] = Username.text;
            userData[@"PhoneNumber"] = PhoneNumber.text;
            userData[@"Points"] = [NSNumber numberWithInt: self.scores];
            userData[@"Country"] = currentCountry;
            [userData saveInBackground];
            
            [receivedManager stopUpdatingLocation];
            
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

- (IBAction)TryAgain:(id)sender {
    [self.view endEditing:YES];
    
    [NinjaMovement invalidate];
    
    tunnelsMovingSpeed = 1.2;
    starMovingSpeed = 1.2;
    
    ErrorMessageLabel.hidden = YES;
    Ninja.hidden = NO;
    Ninja.center = CGPointMake(Ninja.center.x, [[UIScreen mainScreen] bounds].size.height / 2);
    
    self.ninjaDown = YES;
    
    Ninja.image = [UIImage imageNamed:@"flappy-ninja-up.png"];
    
    TouchToBeginLabel.hidden = NO;
    self.scores = 0;
    
    ScoreLabel.text = [NSString stringWithFormat:@"%i", self.scores];
    
    Username.hidden = YES;
    TryAgain.hidden = YES;
    SaveToMyScores.hidden = YES;
    PhoneNumber.hidden = YES;
    PublishScoresButton.hidden = YES;
    
    ExitButton.hidden = YES;
    
    ColumnTop.hidden = YES;
    ColumnBottom.hidden = YES;
    Star.hidden = YES;
    
    self.gameHasBegun = NO;
    
    self.isCalled = NO;
    self.isCalledFromStar = NO;
}

- (IBAction)Exit:(id)sender {
    [NinjaMovement invalidate];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)NinjaMoving{
    
    Ninja.center = CGPointMake(Ninja.center.x, Ninja.center.y - self.NinjaFlight);
    
    self.NinjaFlight = self.NinjaFlight + updatingNinjaFlight;
    
    if (self.NinjaFlight < minimumNinjaFlight) {
        self.NinjaFlight = minimumNinjaFlight;
    }
    
    if (self.NinjaFlight > 0) {
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-up.png"];
    }
    
    if (self.NinjaFlight < 0) {
        Ninja.image = [UIImage imageNamed:@"flappy-ninja-down.png"];
    }
}

-(void)Score{
    self.scores++;
    [self GetPointSound];
    
    ScoreLabel.text = [NSString stringWithFormat:@"%i", self.scores];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.gameHasBegun == NO) {
        self.gameHasBegun = YES;
        
        ColumnTop.hidden = NO;
        ColumnBottom.hidden = NO;
        Star.center = CGPointMake(starBeginingX, starBeginingY);
        
        TouchToBeginLabel.hidden = YES;
        
        self.scores = 0;
        
        NinjaMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(NinjaMoving) userInfo:nil repeats:YES];
        
        [self PlaceTunnels];
        
        TunnelMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(TunnelMoving) userInfo:nil repeats:YES];
        
        StarMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(StarMoving) userInfo:nil repeats:YES];
    }
    
    if (self.ninjaDown == YES) {
        self.NinjaFlight = 20;
    }
}

- (void) explosionAnimation{
    NSArray *textPictures = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"explosion-7.png"],
                             [UIImage imageNamed:@"explosion-1.png"],
                             [UIImage imageNamed:@"explosion-2.png"],
                             [UIImage imageNamed:@"explosion-3.png"],
                             [UIImage imageNamed:@"explosion-4.png"],
                             [UIImage imageNamed:@"explosion-5.png"],
                             [UIImage imageNamed:@"explosion-6.png"],
                             [UIImage imageNamed:@"explosion-7.png"], nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:textPictures[0]];
    imageView.animationImages = textPictures;
    imageView.animationDuration = 0.7;
    imageView.animationRepeatCount = 1;
    [imageView startAnimating];
    
    [Explosion addSubview: imageView];
}

- (void) starAnimation{
    NSArray *starPictures = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"rotating-star-1.png"],
                             [UIImage imageNamed:@"rotating-star-2.png"],
                             [UIImage imageNamed:@"rotating-star-3.png"],
                             [UIImage imageNamed:@"rotating-star-4.png"],
                             [UIImage imageNamed:@"rotating-star-5.png"],
                             [UIImage imageNamed:@"rotating-star-6.png"], nil];
    
    self.starAnimationSubView = [[UIImageView alloc] initWithImage:starPictures[0]];
    self.starAnimationSubView.animationImages = starPictures;
    self.starAnimationSubView.animationDuration = 0.5;
    self.starAnimationSubView.animationRepeatCount = -1;
    [self.starAnimationSubView startAnimating];
    
    [Star addSubview: self.starAnimationSubView];
}

-(void)GetPointSound{
    [audioPlayerGetPointSound play];
}

@end

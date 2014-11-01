//
//  GameController.m
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "GameController.h"

@interface GameController ()

@end

@implementation GameController

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
    
    Username.hidden = YES;
    TryAgain.hidden = YES;
    SaveScore.hidden = YES;
    
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
        SaveScore.hidden = NO;
    }
}

- (IBAction)SaveScore:(id)sender {
    
    int tt = Scores;
    NSString *tyt = Username.text;
    int r = 5;
}

- (IBAction)TryAgain:(id)sender {
    [NinjaMovement invalidate];
    
    Ninja.hidden = NO;
    Ninja.center = CGPointMake(Ninja.center.x, [[UIScreen mainScreen] bounds].size.height / 2);
    
    ninjaDown = YES;
    
    Ninja.image = [UIImage imageNamed:@"flappy-ninja-up.png"];
    
    TouchToBeginLabel.hidden = NO;
    Scores = 0;
    
    ScoreLabel.text = [NSString stringWithFormat:@"%i", Scores];
    
    Username.hidden = YES;
    TryAgain.hidden = YES;
    SaveScore.hidden = YES;
    
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

@end

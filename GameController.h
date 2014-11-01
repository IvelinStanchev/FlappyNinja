//
//  GameController.h
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>

int NinjaFlight;
int RandomTopTunnelPosition;
int RandomBottomTunnelPosition;
int RandomTopColumnHeight;
int Scores;
BOOL isCalled;
BOOL gameHasBegun;
BOOL ninjaDown;
int ninjaDownCount;

@interface GameController : UIViewController{
    
    IBOutlet UIImageView *Ninja;
    IBOutlet UIImageView *Background;
    IBOutlet UIImageView *ColumnBottom;
    IBOutlet UIImageView *ColumnTop;
    IBOutlet UIImageView *BackgroundRight;
    IBOutlet UIImageView *Bottom;
    IBOutlet UIImageView *Top;
    IBOutlet UIButton *SaveScore;
    IBOutlet UIButton *TryAgain;
    IBOutlet UILabel *ScoreLabel;
    IBOutlet UILabel *TouchToBeginLabel;
    IBOutlet UITextField *Username;
    
    NSTimer *NinjaMovement;
    NSTimer *TunnelMovement;
}

- (IBAction)SaveScore:(id)sender;
- (IBAction)TryAgain:(id)sender;
-(void)NinjaMoving;
-(void)TunnelMoving;
-(void)PlaceTunnels;
-(void)Score;
-(void)GameOver;

@end

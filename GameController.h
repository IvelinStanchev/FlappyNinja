//
//  GameController.h
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

int NinjaFlight;
int RandomTopTunnelPosition;
int RandomBottomTunnelPosition;
int RandomTopColumnHeight;
int Scores;
BOOL isCalled;
BOOL gameHasBegun;
BOOL ninjaDown;
int ninjaDownCount;
NSString *pathToGetPointSound;
NSString *pathToNinjaCrashSound;
//UITapGestureRecognizer *doubleTapGesture;
//UITapGestureRecognizer *singleTapGesture;

@interface GameController : UIViewController{
    
    IBOutlet UIImageView *Ninja;
    IBOutlet UIImageView *Background;
    IBOutlet UIImageView *ColumnBottom;
    IBOutlet UIImageView *ColumnTop;
    IBOutlet UIImageView *BackgroundRight;
    IBOutlet UIImageView *Bottom;
    IBOutlet UIImageView *Top;
    IBOutlet UIButton *TryAgain;
    IBOutlet UIButton *SaveToMyScores;
    IBOutlet UILabel *ScoreLabel;
    IBOutlet UIButton *PublishScoresButton;
    IBOutlet UILabel *TouchToBeginLabel;
    IBOutlet UITextField *Username;
    IBOutlet UILabel *ErrorMessageLabel;
    IBOutlet UITextField *PhoneNumber;
    
    NSTimer *NinjaMovement;
    NSTimer *TunnelMovement;
    
    AVAudioPlayer *audioPlayerGetPointSound;
    AVAudioPlayer *audioPlayerNinjaCrash;
    AVAudioSession *audiosession;
    
}

@property (nonatomic,strong) UILongPressGestureRecognizer *longPresses;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (IBAction)PublishScore:(id)sender;
- (IBAction)SaveToMyScores:(id)sender;
- (IBAction)TryAgain:(id)sender;
-(void)NinjaMoving;
-(void)TunnelMoving;
-(void)PlaceTunnels;
-(void)Score;
-(void)GameOver;
-(void)GetPointSound;
-(void)ninjaCrashSound;
-(void)GetObjects;

@end

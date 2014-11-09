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

@interface GameController : UIViewController{
    
    IBOutlet UIImageView *Ninja;
    IBOutlet UIImageView *Background;
    IBOutlet UIImageView *ColumnBottom;
    IBOutlet UIImageView *ColumnTop;
    IBOutlet UIImageView *BackgroundRight;
    IBOutlet UIImageView *Bottom;
    IBOutlet UIImageView *Top;
    IBOutlet UIImageView *Explosion;
    IBOutlet UIImageView *Star;
    IBOutlet UIButton *TryAgain;
    IBOutlet UIButton *SaveToMyScores;
    IBOutlet UILabel *ScoreLabel;
    IBOutlet UIButton *PublishScoresButton;
    IBOutlet UILabel *TouchToBeginLabel;
    IBOutlet UITextField *Username;
    IBOutlet UILabel *ErrorMessageLabel;
    IBOutlet UITextField *PhoneNumber;
    IBOutlet UIButton *ExitButton;
    
    NSTimer *NinjaMovement;
    NSTimer *TunnelMovement;
    NSTimer *StarMovement;
    
    AVAudioPlayer *audioPlayerGetPointSound;
    AVAudioPlayer *audioPlayerNinjaCrash;
    AVAudioSession *audiosession;
}

@property (nonatomic, strong) NSManagedObject *scoresdb;
@property (nonatomic, strong) UIImageView *NinjaForTesting;
@property (nonatomic, strong) UIImageView *ColumnTopForTesting;
@property (nonatomic, strong) UIImageView *ColumnBottomForTesting;
@property (nonatomic, strong) UIImageView *TopForTesting;
@property (nonatomic, strong) UIImageView *BottomForTesting;

- (IBAction)PublishScore:(id)sender;
- (IBAction)SaveToMyScores:(id)sender;
- (IBAction)TryAgain:(id)sender;
- (IBAction)Exit:(id)sender;
- (void)NinjaMoving;
- (void)TunnelMoving;
- (void)StarMoving;
- (void)PlaceTunnels;
- (void)PlaceStar;
- (void)Score;
- (void)GameOver;
- (void)GetPointSound;
- (BOOL) ninjaCollidedWithObject: (NSArray*) framesObjects : (GameController *) controller;

@end

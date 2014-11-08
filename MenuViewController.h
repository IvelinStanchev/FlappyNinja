//
//  MenuViewController.h
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

NSString *pathToBackgroundSound;

@interface MenuViewController : UIViewController<UIViewControllerTransitioningDelegate>{
    AVAudioPlayer *audioPlayerBackgroundSound;
    IBOutlet UIButton *NinjaText;
}

- (IBAction)PlayGame:(id)sender;
- (IBAction)Exit:(id)sender;

@end

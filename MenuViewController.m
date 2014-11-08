//
//  MenuViewController.m
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "MenuViewController.h"
#import "MyScoresController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    NSArray *textPictures = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"game-logo-1.png"],
                             [UIImage imageNamed:@"game-logo-2.png"],
                             [UIImage imageNamed:@"game-logo-3.png"],
                             [UIImage imageNamed:@"game-logo-4.png"],
                             [UIImage imageNamed:@"game-logo-5.png"],
                             [UIImage imageNamed:@"game-logo-6.png"],
                             [UIImage imageNamed:@"game-logo-7.png"], nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:textPictures[0]];
    
    imageView.animationImages = textPictures;
    
    imageView.animationDuration = 0.7;
    
    imageView.animationRepeatCount = -1;
    
    [imageView startAnimating];
    
    [NinjaText addSubview: imageView];
    
    //[NinjaText setBackgroundImage: textPictures[0] forState:UIControlStateHighlighted];
    
    //pathToBackgroundSound = [[NSBundle mainBundle] pathForResource:@"background-music" ofType:@"mp3"];
    //audioPlayerBackgroundSound = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathToBackgroundSound] error:NULL];
    //[audioPlayerBackgroundSound prepareToPlay];
    //[audioPlayerBackgroundSound play];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlayGame:(id)sender {
    [audioPlayerBackgroundSound stop];
}

- (IBAction)Exit:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle: @"Exit the game?" delegate:self cancelButtonTitle:@"No way" destructiveButtonTitle:nil otherButtonTitles:@"Yes please", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        exit(0);
    }
}

@end

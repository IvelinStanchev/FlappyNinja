//
//  MenuViewController.m
//  FlappyNinja
//
//  Created by Test Test on 10/31/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "MenuViewController.h"

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
    pathToBackgroundSound = [[NSBundle mainBundle] pathForResource:@"background-music" ofType:@"mp3"];
    audioPlayerBackgroundSound = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:pathToBackgroundSound] error:NULL];
    [audioPlayerBackgroundSound prepareToPlay];
    [audioPlayerBackgroundSound play];
    
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

@end

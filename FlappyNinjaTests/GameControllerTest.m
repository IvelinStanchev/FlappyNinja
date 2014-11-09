//
//  GameControllerTest.m
//  FlappyNinja
//
//  Created by Test Test on 11/8/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameController.h"
#import <Parse/Parse.h>

@interface GameControllerTest : XCTestCase

@end

@implementation GameControllerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testNinjaShouldCollideWithTopColumn {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    gameController.ColumnTopForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 75, 500)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.ColumnTopForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames :gameController];

    XCTAssertTrue(hasCollision, @"Collision must be detected!");
}

- (void) testNinjaShouldNotCollideWithTopColumn {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    gameController.ColumnTopForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(350, 100, 75, 500)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.ColumnTopForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames : gameController];
    
    XCTAssertFalse(hasCollision, @"Collision must not be detected!");
}

- (void) testNinjaShouldCollideWithBottomColumn {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    gameController.ColumnBottomForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 75, 500)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.ColumnBottomForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames :gameController];
    
    XCTAssertTrue(hasCollision, @"Collision must be detected!");
}

- (void) testNinjaShouldNotCollideWithBottomColumn {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    gameController.ColumnBottomForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(120, 600, 75, 500)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.ColumnBottomForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames : gameController];
    
    XCTAssertFalse(hasCollision, @"Collision must not be detected!");
}

- (void) testNinjaShouldCollideWithTopOfTheField {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    
    gameController.TopForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 60)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.TopForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames :gameController];
    
    XCTAssertTrue(hasCollision, @"Collision must be detected!");
}

- (void) testNinjaShouldNotCollideWithTopOfTheField {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 50, 50)];
    
    gameController.TopForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 60)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.TopForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames : gameController];
    
    XCTAssertFalse(hasCollision, @"Collision must not be detected!");
}

- (void) testNinjaShouldCollideWithBottomOfTheField {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(20, 460, 50, 50)];
    
    gameController.BottomForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 500, 60)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.BottomForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames :gameController];
    
    XCTAssertTrue(hasCollision, @"Collision must be detected!");
}

- (void) testNinjaShouldNotCollideWithBottomOfTheField {
    GameController *gameController = [[GameController alloc] init];
    
    gameController.NinjaForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 50, 50)];
    
    gameController.BottomForTesting = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 500, 60)];
    
    NSArray *frames = [[NSArray alloc] initWithObjects: [NSValue valueWithCGRect: gameController.BottomForTesting.frame], nil];
    
    BOOL hasCollision = [gameController ninjaCollidedWithObject:frames : gameController];
    
    XCTAssertFalse(hasCollision, @"Collision must not be detected!");
}

@end

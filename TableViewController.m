//
//  TableViewController.m
//  FlappyNinja
//
//  Created by admin on 11/8/14.
//  Copyright (c) 2014 Test Test. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"

@interface TableViewController ()
{
    NSArray *titleArray;
    NSArray *logoFileArray;
}
@end

@implementation TableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    titleArray = [[NSArray alloc]initWithObjects:
<<<<<<< HEAD
                  @"1. Start the game. Tap the screen to start. Tap the screen again to allow your bird to fly.",
                  @"2. Stay in the middle of screen until the first set of pipes appears. Measure your tap heights to go between the two pipes. The faster you tap, the higher you go. Each tap represents a wing flap and higher flight. Once you stop, you drop towards the ground.",
                  @"3. Stay in the middle of the pipes. This is the main objective of the game. If you hit a pipe or the ground, the game ends.",
                  @"4. Find your rhythm for higher and lower pipes. This is important when you need to go higher or drop, or else you will hit a pipe.",
                  @"5. Try not to go high. You can still bump into a pipe.",
                  @"6. Collect the stars to gain more scores.", nil];
    
    logoFileArray = [[NSArray alloc]initWithObjects:
                     @"instructions-1.png",
                     @"instructions-2.png",
                     @"instructions-3.png",
                     @"instructions-4.png",
                     @"instructions-5.png",
                     @"instructions-6.png", nil];
    
    self.tableViewCustom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-view-background.png"]];
=======
                  @"1. Start the game. Tap the arrow to start. Tap the screen again to allow your bird to fly and to start the game",
                  @"2. Stay in the middle of screen until the first set of pipes appears. Measure your tap heights to go between the two pipes. The faster you tap, the higher you go. Each tap represents a wing flap and higher flight. Once you stop, you drop towards the ground.",
                  @"3. Stay in the middle of the pipes. This is the main objective of the game. If you hit a pipe or the ground, the game ends.",
                  @"4. Find your rhythm for higher and lower pipes. This is important when you need to go higher or drop, or else you will hit a pipe.",
                  @"5. Try not to go high. You can still bump into a pipe. ",  nil];
    logoFileArray = [[NSArray alloc]initWithObjects:
                     @"ins01.png",
                     @"ins02.png",
                     @"ins03.png",
                     @"ins04.png",
                     @"ins05.jpg", nil];
>>>>>>> origin/master
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
<<<<<<< HEAD
    if (indexPath.row % 2 == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"table-view-background-dark-cell.png"]];
        
        cell.textInCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"table-view-background.png"]];
    }
    else{
        cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"table-view-background.png"]];
        
        cell.textInCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"table-view-background-dark-cell.png"]];
    }
    
    cell.textInCell.textColor = [UIColor yellowColor];
    cell.textInCell.font = [UIFont fontWithName: @"Papyrus" size: 17.0];
    
=======
>>>>>>> origin/master
    cell.textInCell.text = [titleArray objectAtIndex:indexPath.row];
    cell.imageInCell.image = [UIImage imageNamed:[logoFileArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

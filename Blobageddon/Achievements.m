//
//  Achievements.m
//  Blobageddon
//
//  Created by David Magee on 2/25/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import "Achievements.h"
#import "SaveLeaderboardScores.h"


@implementation Achievements

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Achievements *layer = [Achievements node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//Creates a tableview and data to populate it with
-(id)init
{
    if( (self=[super init])) {
    
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundimage = [CCSprite spriteWithFile:@"towers.png"];
        backgroundimage.position = ccp(size.width/2, size.height/2);
        [self addChild:backgroundimage z:-10];
        
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(size.width/4, size.height/4, size.width/2, size.height/2 * 1.5) style:UITableViewStylePlain];
        [[[CCDirector sharedDirector] view] addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        
        arrayOfAchievements = [[NSMutableArray alloc] init];
        
        NSDictionary *returnedValues = [[NSUserDefaults standardUserDefaults] objectForKey:@"achievements2"];
        
        [arrayOfAchievements addObject:[returnedValues objectForKey:@"won_one_unlocked"]];
        [arrayOfAchievements addObject:[returnedValues objectForKey:@"lost_one_unlocked"]];
        [arrayOfAchievements addObject:[returnedValues objectForKey:@"won_three_in_row_unlocked"]];
        [arrayOfAchievements addObject:[returnedValues objectForKey:@"all_unlocked"]];
        
        [tableView reloadData];
        
    }
    
    return self;

}

//Returns amount of achievements
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrayOfAchievements > 0 && arrayOfAchievements != NULL)
    {
        return arrayOfAchievements.count;
    }
    else
    {
        return 0;
    }
}


//Returns cell text
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell != nil)
    {
        if (indexPath.row == 0)
        {
            if ([[ arrayOfAchievements objectAtIndex:indexPath.row] intValue] == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Won A Game:    Unlocked"];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Won A Game:    Locked"];
            }
        }
        else if (indexPath.row == 1)
        {
            if ([[ arrayOfAchievements objectAtIndex:indexPath.row] intValue] == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Lost A Game:    Unlocked"];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Lost A Game:    Locked"];
            }
        }
        else if (indexPath.row == 2)
        {
            if ([[ arrayOfAchievements objectAtIndex:indexPath.row] intValue] == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Won 3 In A Row:    Unlocked"];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Won 3 In A Row:    Locked"];
            }
        }
        else if (indexPath.row == 3)
        {
            if ([[ arrayOfAchievements objectAtIndex:indexPath.row] intValue] == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"All Achievements:    Unlocked"];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"All Achievements:    Locked"];
            }
        }
        
    
    }
    
    return cell;
}

@end

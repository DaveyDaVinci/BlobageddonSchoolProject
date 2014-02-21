//
//  CreditsLayer.m
//  Blobageddon
//
//  Created by David Magee on 1/29/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import "CreditsLayer.h"
#import "SaveLeaderboardScores.h"
#import <Parse/Parse.h>


@implementation CreditsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsLayer *layer = [CreditsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id)init
{
    if( (self=[super init])) {
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundimage = [CCSprite spriteWithFile:@"towers.png"];
        backgroundimage.position = ccp(size.width/2, size.height/2);
        [self addChild:backgroundimage z:-10];
        
        [self setTouchEnabled:TRUE];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"allsprites.plist"];
        // CCSpriteBatchNode *largeBlueBlobSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteanimated.png"];
        
        smallSpriteNode = [CCSpriteBatchNode batchNodeWithFile:@"allsprites.png"];
        [self addChild:smallSpriteNode];
        
        
        
        
        CCSprite *wizardSprite = [CCSprite spriteWithSpriteFrameName:@"wizard.png"];
        int randomWidth = arc4random() % abs(size.width);
        int randomHeight = arc4random() % abs(size.height);
        wizardSprite.position = ccp(randomWidth, randomHeight);
        
        CCSprite *queenSprite = [CCSprite spriteWithSpriteFrameName:@"Queen.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        queenSprite.position = ccp(randomWidth, randomHeight);
        queenSprite.scaleX *= -1;
        
        CCSprite *firemanSprite = [CCSprite spriteWithSpriteFrameName:@"Fireman.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        firemanSprite.position = ccp(randomWidth, randomHeight);
        
        CCSprite *ghostSprite = [CCSprite spriteWithSpriteFrameName:@"ghosttransparent.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        ghostSprite.position = ccp(randomWidth, randomHeight);
        
        CCSprite *zombieSprite = [CCSprite spriteWithSpriteFrameName:@"zombie.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        zombieSprite.position = ccp(randomWidth, randomHeight);
        
        [smallSpriteNode addChild:queenSprite];
        [smallSpriteNode addChild:wizardSprite];
        [smallSpriteNode addChild:firemanSprite];
        [smallSpriteNode addChild:ghostSprite];
        [smallSpriteNode addChild:zombieSprite];
        
       
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(size.width/4, size.height/4, size.width/2, size.height/2 * 1.5) style:UITableViewStylePlain];
        [[[CCDirector sharedDirector] view] addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        backButton = [CCSprite spriteWithFile:@"backbutton.png"];
        backButton.scale = .5;
        backButton.position = ccp((tableView.frame.origin.x - backButton.boundingBox.size.width) + 20, size.height / 5);
        [self addChild:backButton];
        
        onlineButton = [CCSprite spriteWithFile:@"leaderbutton.png"];
        onlineButton.position = ccp(tableView.frame.origin.x + 40, (tableView.frame.origin.y + tableView.frame.size.height) - 40);
        onlineButton.scale = .5;
        [self addChild:onlineButton];
        
        
        localButton = [CCSprite spriteWithFile:@"localbutton.png"];
        localButton.position = ccp((onlineButton.position.x + onlineButton.boundingBox.size.width) + 100, onlineButton.position.y);
        localButton.scale = .5;
        [self addChild:localButton];
        
        /*
        usernamesSortButton;
         */
        highScoreSortButton = [CCSprite spriteWithFile:@"byhighscore.png"];
        highScoreSortButton.scale = .5;
        highScoreSortButton.position = ccp((tableView.frame.origin.x - highScoreSortButton.boundingBox.size.width) + 20, size.height / 2);
        [self addChild:highScoreSortButton];
        
        saveObject = [[SaveLeaderboardScores alloc] init];
        
        localScores = [saveObject loadAllLeaderboardData];
        
        onlineScores = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"LeaderboardScores"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            
            if (!error)
            {
                for (PFObject *object in objects)
                {
                    NSLog(@"Hit");
                    
                    NSMutableDictionary *currentObject = [[NSMutableDictionary alloc] init];
                    [currentObject setObject:[object objectForKey:@"username"] forKey:@"username"];
                    [currentObject setObject:[object objectForKey:@"score"] forKey:@"score"];
                    
                    
                    
                    //NSLog(@"%@", [currentObject objectForKey:@"username"]);
                    
                    [onlineScores addObject:currentObject];
                    //NSLog(@"%d", returnedArray.count);
                    
                }
            }
            
            
            
        }];
        
          
        
    }
    
    
    
   // NSLog(@"%@, %d", [[sortedArray objectAtIndex:0] objectForKey:@"username"], [[[sortedArray objectAtIndex:0] objectForKey:@"score"] intValue]);
    
    
    
    return self;
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(backButton.boundingBox, location))
    {
        buttonPressed = TRUE;
    }
    if (CGRectContainsPoint(localButton.boundingBox, location))
    {
        localButtonPressed = TRUE;
    }
    if (CGRectContainsPoint(onlineButton.boundingBox, location))
    {
        onlineButtonPressed = TRUE;
    }
    if (CGRectContainsPoint(highScoreSortButton.boundingBox, location))
    {
        highScoreSortButtonPressed = TRUE;
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(backButton.boundingBox, location) && buttonPressed == TRUE)
    {
        buttonPressed = FALSE;
        [tableView removeFromSuperview];
        [[CCDirector sharedDirector] popScene];
        
    }
    else
    {
        buttonPressed = FALSE;
    }
    
    if (CGRectContainsPoint(localButton.boundingBox, location))
    {
        if (localButtonPressed == TRUE)
        {
            [tableView reloadData];
            onlineButtonPressed = FALSE;
        }
        
       
    }
    
    else
    {
        localButtonPressed = FALSE;
    }
     
    
    if (CGRectContainsPoint(onlineButton.boundingBox, location))
    {
        if (onlineButtonPressed == TRUE)
        {
            [tableView reloadData];
            localButtonPressed = FALSE;
            
            
            
            
        }
        
        
    }
    
    else
    {
        onlineButtonPressed = FALSE;
    }
    
    if (CGRectContainsPoint(highScoreSortButton.boundingBox, location))
    {
        if (highScoreSortButtonPressed == TRUE)
        {
            if (localShowing == TRUE)
            {
                localButtonPressed = TRUE;
                onlineButtonPressed = FALSE;
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:TRUE];
                
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                
                NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[localScores sortedArrayUsingDescriptors:sortDescriptors]];
                
                localScores = sortedArray;
                
                [tableView reloadData];
                
                
            }
            else
            {
                localButtonPressed = FALSE;
                onlineButtonPressed = TRUE;
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:TRUE];
                
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                
                NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[onlineScores sortedArrayUsingDescriptors:sortDescriptors]];
                
             //   onlineScores = sortedArray;
                
                [onlineScores removeAllObjects];
                
                onlineScores = sortedArray;
                
                [tableView reloadData];
            }
        }
        
    }
    else
    {
        highScoreSortButtonPressed = FALSE;
    }
     
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (localButtonPressed == TRUE)
    {
        if (localScores != nil && localScores.count > 0)
        {
            localShowing = TRUE;
            return localScores.count;
            
        }
        else
        {
            return 0;
        }
    }
    else if (onlineButtonPressed == TRUE)
    {
        if (onlineScores != nil && onlineScores.count > 0)
        {
            localShowing = FALSE;
            return onlineScores.count;
            
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (localScores != nil && localScores.count > 0)
        {
            localShowing = TRUE;
            return localScores.count;
            
        }
        else
        {
            return 0;
        }
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell != nil)
    {
        if (localButtonPressed == TRUE)
        {
            if (localScores != nil && localScores.count > 0)
            {
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@:       %d", [[localScores objectAtIndex:indexPath.row] objectForKey:@"username"], [[[localScores objectAtIndex:indexPath.row] objectForKey:@"score"] intValue]];
            }
        }
        else if (onlineButtonPressed == TRUE)
        {
            if (onlineScores != nil && onlineScores.count > 0)
            {
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@:       %d", [[onlineScores objectAtIndex:indexPath.row] objectForKey:@"username"], [[[onlineScores objectAtIndex:indexPath.row] objectForKey:@"score"] intValue]];
            }
        }
        else
        {
            if (localScores != nil && localScores.count > 0)
            {
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@:       %d", [[localScores objectAtIndex:indexPath.row] objectForKey:@"username"], [[[localScores objectAtIndex:indexPath.row] objectForKey:@"score"] intValue]];
            }
        }
        
        //Text is equal to group names
        //cell.textLabel.text = [singleton.arrayOfGroupNames objectAtIndex:indexPath.row];
    }
    return cell;
}

@end

//
//  SaveLeaderboardScores.m
//  Blobageddon
//
//  Created by David Magee on 2/19/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import "SaveLeaderboardScores.h"
#import <Parse/Parse.h>

@implementation SaveLeaderboardScores

-(id)init{
    self = [super init];
    
    if (self)
    {
        
        dataBaseName = @"leaderboards";
    }
    
    return self;
}

-(void)createOrLoadLeaderboard:(NSString *)userName score:(int)highScore
{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    if (directoryPaths != nil)
    {
        NSString *documentsDirectory = [directoryPaths objectAtIndex:0];
        dataBaseName = [documentsDirectory stringByAppendingPathComponent:@"leaderboards"];
        
                
        const char *databasePath = [dataBaseName UTF8String];
        sqlite3 *leaderboardsDB;
        if (sqlite3_open(databasePath, &leaderboardsDB) == SQLITE_OK)
        {
            // NSString *createTable =  @"CREATE TABLE IF NOT EXISTS 'laureates_table' ('id', INTEGER PRIMARY KEY, 'prize' TEXT, 'first_name' TEXT, 'surname' TEXT, 'year' INTEGER);";
            
            NSString *createTable =  @"CREATE TABLE IF NOT EXISTS 'leaderboard_table' ('id' INTEGER PRIMARY KEY, 'username' TEXT, 'score' INTEGER);";
            
            const char *errMEssage = sqlite3_errmsg(leaderboardsDB);
            
            NSLog(@"%s", errMEssage);
            char *err;
            
           
            
            
            //Opens or creats table
            if (sqlite3_exec(leaderboardsDB, [createTable UTF8String], NULL, NULL, &err) == SQLITE_OK)
            {
                
                
                NSString *finalString1 = [NSString stringWithFormat:@"INSERT INTO 'leaderboard_table' (id, username, score) VALUES (NULL, '%@','%d')", userName, highScore];
                
                const char *finalChar = [finalString1 UTF8String];
                // const char *finalChar2 = [finalString2 UTF8String];
                
                sqlite3_stmt *insertStatement;
                sqlite3_prepare_v2(leaderboardsDB, finalChar, -1, &insertStatement, NULL);
                // sqlite3_prepare_v2(prizeDB, finalChar2, -1, &insertStatement, NULL);
                
                
                int blergh = sqlite3_errcode(leaderboardsDB);
                
                const char *errMEssage = sqlite3_errmsg(leaderboardsDB);
                
                NSLog(@"%s", errMEssage);
                
                NSLog(@"%d", blergh);
                if (sqlite3_step(insertStatement) == SQLITE_DONE)
                {
                    sqlite3_finalize(insertStatement);
                }
                
                
            }
        }
    }
}



-(NSMutableArray *)loadAllLeaderboardData
{
    NSMutableArray *returnedArray = [[NSMutableArray alloc] init];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
    if (directoryPaths != nil)
    {
        NSString *documentsDirectory = [directoryPaths objectAtIndex:0];
        dataBaseName = [documentsDirectory stringByAppendingPathComponent:@"leaderboards" ];
        
        //arrayOfLaureates = [[NSMutableArray alloc] init];
        
        
        const char *databasePath = [dataBaseName UTF8String];
        sqlite3 *leaderboardDB;
        if (sqlite3_open(databasePath, &leaderboardDB) == SQLITE_OK)
        {
            
            
            NSString *createTable = @"CREATE TABLE IF NOT EXISTS 'leaderboard_table' ('id' INTEGER PRIMARY KEY, 'username' TEXT, 'score' INTEGER);";
            
            const char *errMEssage = sqlite3_errmsg(leaderboardDB);
            
            NSLog(@"%s", errMEssage);
            char *err;
            
            
            //Opens or creats table
            if (sqlite3_exec(leaderboardDB, [createTable UTF8String], NULL, NULL, &err) == SQLITE_OK)
            {
                
                NSString *searchString = [NSString stringWithFormat:@"SELECT username, score FROM leaderboard_table"];
                const char *sqlQuery = [searchString UTF8String];
                sqlite3_stmt *sqlStatement;
                
                if (sqlite3_prepare_v2(leaderboardDB, sqlQuery, -1, &sqlStatement, NULL) == SQLITE_OK)
                {
                    NSLog(@"Okay!");
                    
                    sqlite3_prepare_v2(leaderboardDB, sqlQuery, -1, &sqlStatement, NULL);
                    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                        
                        NSMutableDictionary *returnedDict = [[NSMutableDictionary alloc] init];
                        
                        [returnedDict setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(sqlStatement, 0)] forKey:@"username"];
                        [returnedDict setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(sqlStatement, 1)] forKey:@"score"];
                        
                        
                        
                        [returnedArray addObject:returnedDict];
                        
                        
                    }
                    
                }
            }
        }
    }
    
    return returnedArray;
}

-(void)saveToParse: (NSString *)username score:(int)finalScore
{
    PFObject *saveObject = [PFObject objectWithClassName:@"LeaderboardScores"];
    saveObject[@"username"] = username;
    saveObject[@"score"] = @(finalScore);
    [saveObject saveEventually];
}

-(NSMutableArray *)loadParseLeaderboardData
{
    NSMutableArray *returnedArray = [[NSMutableArray alloc] init];
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
                
                [returnedArray addObject:currentObject];
                //NSLog(@"%d", returnedArray.count);
                
            }
        }
        
        
        
    }];
    
    NSLog(@"%d", returnedArray.count);
    return returnedArray;
    
}
@end

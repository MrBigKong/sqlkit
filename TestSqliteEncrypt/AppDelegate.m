//
//  AppDelegate.m
//  TestSqliteEncrypt
//
//  Created by yanluojun on 15/12/22.
//  Copyright © 2015年 yanluojun. All rights reserved.
//

#import "AppDelegate.h"
#import <sqlite3.h>

@interface AppDelegate ()
@property (readonly) NSURL *databaseURL;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self openDB];
    
    return YES;
}

- (void)openDB {
    // Set up a SQLCipher database connection:
    sqlite3 *db;
    if (sqlite3_open([[self.databaseURL path] UTF8String], &db) == SQLITE_OK) {
        const char* key = [@"StrongPassword" UTF8String];
        sqlite3_key(db, key, (int)strlen(key));
        if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"Password is correct, or a new database has been initialized");
        } else {
            NSLog(@"Incorrect password!");
        }
        NSString *sql = @"CREATE TABLE IF NOT EXISTS testTable (id integer primary key AutoIncrement,col1 varchar(20),col2 varchar(20))";
        if (sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"create table success");
        } else {
            NSLog(@"create table failure");
        }

        sqlite3_close(db);
    }
}

- (NSURL *)databaseURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/test.db"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //    [fm removeItemAtPath: path error: nil];
    
    if (![fm fileExistsAtPath:path isDirectory:NULL]) {
        [fm copyItemAtPath:[[NSBundle mainBundle ] pathForResource:@"test.db" ofType:@""] toPath:path error:nil];
    }
    
//    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *directoryURL = [URLs firstObject];
    NSURL *databaseURL = [NSURL fileURLWithPath:path];
    return  databaseURL;
}

- (BOOL)databaseExists {
    BOOL exists = NO;
    NSError *error = nil;
    exists = [[self databaseURL] checkResourceIsReachableAndReturnError:&error];
    if (exists == NO && error != nil) {
        NSLog(@"Error checking availability of database file: %@", error);
    }
    return exists;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

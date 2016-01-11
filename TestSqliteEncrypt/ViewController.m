//
//  ViewController.m
//  TestSqliteEncrypt
//
//  Created by yanluojun on 15/12/22.
//  Copyright © 2015年 yanluojun. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define kTableTest @"TableTest"

@interface ViewController () {
    IBOutlet UITextField *_field;
    IBOutlet UILabel *_logLabel;
    sqlite3 *_db;
}
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (readonly) NSURL *databaseURL;

@end

@implementation ViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self openDB];
    
    
}

- (void)openDB {
    // Set up a SQLCipher database connection:
    if (sqlite3_open([[self.databaseURL path] UTF8String], &_db) == SQLITE_OK) {
        const char* key = [@"123456" UTF8String];
        sqlite3_key(_db, key, (int)strlen(key));
        if (sqlite3_exec(_db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            _logLabel.text = @"密码正确，可以开始操作数据库";
        } else {
            _logLabel.text = @"密码错误,打开数据库失败";
        }
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key AutoIncrement,col1 varchar(20),col2 varchar(20))",kTableTest];
        if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL) == SQLITE_OK) {
//            NSLog(@"create table success");
        } else {
//            NSLog(@"create table failure");
        }
    }
}

- (void)initFMDB {
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self.databaseURL absoluteString]];

}

-(IBAction)querySQLAction:(id)sender {
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM TABLE %@",kTableTest];
//    
//    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:1];
//    
//    [self.databaseQueue inDatabase:^(FMDatabase *database){
//        FMResultSet *rs = [database executeQuery:sql];
//        while ([rs next]) {
//            [ar addObject:[rs resultDictionary]];
//        };
//        [rs close];
//    }];
//    
//    return result;
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

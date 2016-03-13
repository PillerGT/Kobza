//
//  ViewController.m
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "UAAuthor.h"


static NSString* dbName = @"UACitation";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSString* pathDB = [self pathToDB];
    FMDatabase* db = [FMDatabase databaseWithPath:pathDB];
    
    if (![db open]) {
        NSLog(@"No OPEN SQLITE");
    }
    NSString* numberStr = @"7";
    NSString* queryDB = [NSString stringWithFormat:@"SELECT * FROM AUTHOR WHERE AUTHOR_ID = %@", numberStr];
    
    FMResultSet *set  = [db executeQuery:queryDB];

    NSMutableArray* tmpArray = [NSMutableArray array];
    while ([set next]) {
        
        UAAuthor* author = [[UAAuthor alloc] initWithBaseResponse:set];
        [tmpArray addObject:author];

    }
    NSLog(@"%@", tmpArray);
}

-(NSString *)pathToDB {
    NSString *originalDBPath = [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"];
    NSString *path = nil;
    NSString *DOCUMENTS = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbNameDir = [NSString stringWithFormat:@"%@/Recipes", DOCUMENTS];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL dirExists = [fileManager fileExistsAtPath:dbNameDir isDirectory:&isDir];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@.db", dbNameDir, dbName];
    if(dirExists && isDir) {
        BOOL dbExists = [fileManager fileExistsAtPath:dbPath];
        if(!dbExists) {
            NSError *error = nil;
            BOOL success = [fileManager copyItemAtPath:originalDBPath toPath:dbPath error:&error];
            if(!success) {
                NSLog(@"error = %@", error);
            } else {
                path = dbPath;
            }
        } else {
            path = dbPath;
        }
    } else if(!dirExists) {
        NSError *error = nil;
        BOOL success = [fileManager createDirectoryAtPath:dbNameDir withIntermediateDirectories:YES attributes:nil error:&error];
        if(!success) {
            NSLog(@"failed to create dir");
        }
        success = [fileManager copyItemAtPath:originalDBPath toPath:dbPath error:&error];
        if(!success) {
            NSLog(@"error = %@", error);
        } else {
            path = dbPath;
        }
    }
    return path;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

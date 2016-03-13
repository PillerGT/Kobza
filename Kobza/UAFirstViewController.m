//
//  UAFirstViewController.m
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import "UAFirstViewController.h"
#import "FMDB.h"
#import "UAAuthor.h"
#import "UACitation.h"
#import "UABaseVersion.h"

static NSString* dbName = @"UACitation";

@interface UAFirstViewController()

@property (strong, nonatomic) FMDatabase* db;

@end

@implementation UAFirstViewController

- (void)viewDidLoad {
    [self.citationTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* pathDB = [self pathToDB];
    self.db = [FMDatabase databaseWithPath:pathDB];
    
    [self generateNumberCitation];
}
/*
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
}
*/
- (void)viewWillDisappear:(BOOL)animated {
    [self.citationTextView removeObserver:self forKeyPath:@"contentSize"];
}

- (NSInteger) countCitation {
    
    if (![self.db open]) {
        NSLog(@"No OPEN SQLITE BASE");
    }
    
    NSString* queryDB = [NSString stringWithFormat:@"SELECT * FROM BASE_INFO"];
    
    FMResultSet *set  = [self.db executeQuery:queryDB];
    
    UABaseVersion* baseVersion;
    while ([set next]) {
        
        baseVersion = [[UABaseVersion alloc] initWithBaseResponse:set];
    }
    [self.db close];
    
    return [baseVersion.countCitat intValue];
}

- (UAAuthor*) searchAuthor:(NSString*) authorID {
    
    //authorID = @"7";
    NSString* numberStr = authorID;
    
    //numberStr = @"25";
    
    if (![self.db open]) {
        NSLog(@"No OPEN SQLITE BASE");
    }
    
    NSString* queryDB = [NSString stringWithFormat:@"SELECT * FROM AUTHOR WHERE AUTHOR_ID = %@", numberStr];
    
    FMResultSet *set  = [self.db executeQuery:queryDB];
    
    //NSMutableArray* tmpArray = [NSMutableArray array];
    UAAuthor* author;
    while ([set next]) {
        
        author = [[UAAuthor alloc] initWithBaseResponse:set];
        //[tmpArray addObject:author];
        
    }
    [self.db close];
    
    return author;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //tv.contentInset = (CGPoint){.x = 0, .y = -topCorrect};
    [tv setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
}

- (void) generateNumberCitation {
    
    NSInteger countCitat = [self countCitation];
    
    int numberInt = arc4random_uniform(countCitat) + 1;
    
    NSString* numberStr = [NSString stringWithFormat:@"%d", numberInt];//@"87";
    
    if (![self.db open]) {
        NSLog(@"No OPEN SQLITE BASE");
    }
    
    NSString* queryDB = [NSString stringWithFormat:@"SELECT * FROM CITATION WHERE CITATION_ID = %@", numberStr];
    
    FMResultSet *set  = [self.db executeQuery:queryDB];
    
    //NSMutableArray* tmpArray = [NSMutableArray array];
    UACitation* citation;
    while ([set next]) {
        
        citation = [[UACitation alloc] initWithBaseResponse:set];
        //[tmpArray addObject:author];
        
    }
    [self.db close];
    
    UAAuthor* author = [self searchAuthor:citation.authCitID];
    
    [self setCitation:citation author:author];
}



- (void) setCitation:(UACitation*)citation author:(UAAuthor*)author {
    
    self.citationTextView.text = citation.citation;
    self.authorTextLabel.text = author.name;
    self.authorInfoTextLabel.text = author.info;
    self.authorPhotoImageView.image = [UIImage imageNamed:author.photo];
    
    //[self printText:citation.citation delay:0.01];
  
}

- (void) printText:(NSString*)text delay:(float)delay {
    
    __block NSString* add = @"";
    
    for (int i = 1; i <= [text length]; i++) {
        
            dispatch_sync(dispatch_get_main_queue(), ^{
                add = [text substringToIndex:i];
            });
        
        [NSThread sleepForTimeInterval:delay];
        
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"%@", add);
        
    });
    
}

#pragma mark - ActionButton
- (IBAction)actionNextCitation:(id)sender {
    
    [self generateNumberCitation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - CopyDB
- (NSString *)pathToDB {
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

@end

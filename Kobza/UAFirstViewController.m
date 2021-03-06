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

#define DELAY_CITAT 0.3f

static NSString* dbName = @"UACitation";

@interface UAFirstViewController()

@property (strong, nonatomic) FMDatabase* db;
@property (strong, nonatomic) NSString* countCitat;

@end

@implementation UAFirstViewController

- (void)viewDidLoad {
    [self.citationTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* pathDB = [self pathToDB];
    self.db = [FMDatabase databaseWithPath:pathDB];
    
    [self countCitation];
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

- (void) countCitation {
    
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
    self.countCitat = baseVersion.countCitat;

    //return [baseVersion.countCitat intValue];
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
    
    int countCitat = [self.countCitat intValue];//[self countCitation];
    int numberInt = arc4random_uniform(countCitat) + 1;
    UACitation* citation = [[UACitation alloc] init];
    
    citation = [self newCitat:numberInt];
    
    if (citation) {
        
        UAAuthor* author = [self searchAuthor:citation.authCitID];
        [self hideAndShow:nil delay:DELAY_CITAT citation:citation author:author];
        [self lastCitat];
        
    }else {
        [self generateNumberCitation];
    }
}

- (UACitation*) newCitat:(NSInteger) numberCitat {
    
    NSString* numberStr = [NSString stringWithFormat:@"%ld", (long)numberCitat];
    
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
    
    if ([citation.showCitat intValue] == 0/* isEqualToString:nil]*/) {
        
        if (![self.db open]) {
            NSLog(@"No OPEN SQLITE BASE");
        }
        NSString* queryUpdateDB = [NSString stringWithFormat:@"UPDATE CITATION SET SHOW_CITAT = %@ WHERE CITATION_ID = %@", citation.citationID, citation.citationID];
        
        if ([self.db executeUpdate:queryUpdateDB]) {
            NSLog(@"Update Citat = %@", citation.citationID);
        }else
            NSLog(@"Fail update citat = %@", citation.citationID);
        [self.db close];
        
        return citation;
    }else
        return nil;
}

- (void) lastCitat {
    
    if (![self.db open]) {
        NSLog(@"No OPEN SQLITE BASE");
    }
    
    NSString* queryDB = [NSString stringWithFormat:@"SELECT COUNT(SHOW_CITAT) FROM CITATION"];
    FMResultSet *set  = [self.db executeQuery:queryDB];
    NSString* showCitat;

    while ([set next]) {
        
        showCitat = [set stringForColumn:@"COUNT(SHOW_CITAT)"];
    }
    [self.db close];
    
    if ([self.countCitat isEqualToString:showCitat]) {
        
        if (![self.db open]) {
            NSLog(@"No OPEN SQLITE BASE");
        }
        NSString* queryUpdateDB = [NSString stringWithFormat:@"UPDATE CITATION SET SHOW_CITAT = NULL"];
        
        if ([self.db executeUpdate:queryUpdateDB]) {
            NSLog(@"Update ALL Citat = NULL");
        }else
            NSLog(@"Fail update ALL citat");
        [self.db close];
    }
}

- (void) setCitation:(UACitation*)citation author:(UAAuthor*)author {
    
    self.citationTextView.text = citation.citation;
    self.authorTextLabel.text = author.name;
    self.authorInfoTextLabel.text = author.info;
    self.authorPhotoImageView.image = [UIImage imageNamed:author.photo];
    
    //[self printText:citation.citation delay:0.01];
  
}

- (void) hideAndShow:(UILabel*)element delay:(double)delay citation:(UACitation*)citation author:(UAAuthor*)author{
    
    delay = delay/2;
    double delay2 = delay/100;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
         [self.refreshButton setUserInteractionEnabled:NO];
        for (NSInteger i = 100; i >= 0; i--) {
            float alp = (float)i/100;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:delay2];
                //element.alpha = alp;
                self.citationTextView.alpha = alp;
                self.authorTextLabel.alpha = alp;
                self.authorInfoTextLabel.alpha = alp;
                self.authorPhotoImageView.alpha = alp;
            });
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //element.text = @"Ой, я про другую анимацию подумал :-) Тогда все проще. Смотрите, сейчас для анимации вы задаете ее продолжительность (animImage.animationDuration = 1.0f;). А в шпаргалке есть такая заметка:";
            self.citationTextView.text = citation.citation;
            self.authorTextLabel.text = author.name;
            self.authorInfoTextLabel.text = author.info;
            self.authorPhotoImageView.image = [UIImage imageNamed:author.photo];
        });
        
        for (NSInteger i = 0; i <= 100; i++) {
            float alp = (float)i/100;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:delay2];
                //element.alpha = alp;
                self.citationTextView.alpha = alp;
                self.authorTextLabel.alpha = alp;
                self.authorInfoTextLabel.alpha = alp;
                self.authorPhotoImageView.alpha = alp;
            });
        }
         [self.refreshButton setUserInteractionEnabled:YES];
    });
    
}

- (void) type:(NSString*)str withDelay:(double)delay{
    
    __block NSString* text = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (NSUInteger index = 0; index < str.length; index ++) {
            NSString * characterString = [str substringWithRange:NSMakeRange(index, 1)];
            dispatch_sync(dispatch_get_main_queue(), ^{
                text = [text stringByAppendingString:characterString];
                [NSThread sleepForTimeInterval:delay];
                self.citationTextView.text = text;
            });
        }
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
    //NSString *dbPath = [NSString stringWithFormat:@"%@/%@.db", dbNameDir, dbName];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@.sqlite", dbNameDir, dbName];
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
    NSLog(@"%@", dbPath);
    return path;
}

@end

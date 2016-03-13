//
//  UAAuthor.m
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import "UAAuthor.h"
#import "FMDB.h"

@implementation UAAuthor

- (id)initWithBaseResponse:(FMResultSet *) responseSet
{
    self = [super init];
    if (self) {

        self.authorID   = [responseSet stringForColumn:@"AUTHOR_ID"];
        self.name       = [responseSet stringForColumn:@"NAME"];
        self.info       = [responseSet stringForColumn:@"INFO"];
        self.photo      = [responseSet stringForColumn:@"PHOTO"];
    }
    return self;
}

@end

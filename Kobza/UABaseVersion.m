//
//  UABaseVersion.m
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import "UABaseVersion.h"
#import "FMDB.h"

@implementation UABaseVersion

- (id)initWithBaseResponse:(FMResultSet *) responseSet
{
    self = [super init];
    if (self) {
        
        self.version        = [responseSet stringForColumn:@"VERSION"];
        self.countAuth      = [responseSet stringForColumn:@"COUNT_AUTH"];
        self.countCitat     = [responseSet stringForColumn:@"COUNT_CITAT"];
        self.dateCreate     = [responseSet stringForColumn:@"DATE"];
        
    }
    return self;
}

@end

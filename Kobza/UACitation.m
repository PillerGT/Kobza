//
//  UACitation.m
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import "UACitation.h"
#import "FMDB.h"

@implementation UACitation

- (id)initWithBaseResponse:(FMResultSet *) responseSet
{
    self = [super init];
    if (self) {
        
        self.citationID     = [responseSet stringForColumn:@"CITATION_ID"];
        self.authCitID      = [responseSet stringForColumn:@"AUTH_CIT_ID"];
        self.citation       = [responseSet stringForColumn:@"CITATION"];
        self.showCitat      = [responseSet stringForColumn:@"SHOW_CITAT"];

    }
    return self;
}

@end

//
//  UACitation.h
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface UACitation : NSObject

@property (strong, nonatomic) NSString* citationID;
@property (strong, nonatomic) NSString* authCitID;
@property (strong, nonatomic) NSString* citation;

- (id)initWithBaseResponse:(FMResultSet *) responseSet;

@end

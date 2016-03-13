//
//  UAAuthor.h
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface UAAuthor : NSObject

@property (strong, nonatomic) NSString* authorID;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* info;
@property (strong, nonatomic) NSString* photo;

- (id)initWithBaseResponse:(FMResultSet *) responseSet;

@end

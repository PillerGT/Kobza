//
//  UABaseVersion.h
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface UABaseVersion : NSObject

@property (strong, nonatomic) NSString* version;
@property (strong, nonatomic) NSString* countAuth;
@property (strong, nonatomic) NSString* countCitat;
@property (strong, nonatomic) NSString* dateCreate;

- (id)initWithBaseResponse:(FMResultSet *) responseSet;

@end

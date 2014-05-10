//
//  LSSayingsReader.h
//  Lao Shi
//
//  Created by Raymond Louie on 5/10/14.
//  Copyright (c) 2014 Caffeine and Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSSaying;

#define SAYINGS_FILE @"Sayings"
#define SAYINGS_FILE_EXT @"txt"
#define SAYINGS_FILE_DELIM @" - "

@interface LSSayings : NSObject

+(LSSayings *)sharedSayings; // singleton

-(NSArray *)allSayings; // of LSSaying
-(LSSaying *)randomSaying;

@end

//
//  LSSayingsReader.m
//  Lao Shi
//
//  Created by Raymond Louie on 5/10/14.
//  Copyright (c) 2014 Caffeine and Code. All rights reserved.
//

#import "LSSayings.h"
#import "LSSaying.h"

@interface LSSayings ()

@property (strong, nonatomic) NSMutableArray *sayings; // of Saying

@end

@implementation LSSayings

-(NSMutableArray *)sayings
{
    if (!_sayings) _sayings = [[NSMutableArray alloc] init];
    return _sayings;
}

+(LSSaying *)sharedSayings
{
    static LSSaying *sharedSayings = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSayings = [[self alloc] initPrivate];
    });
    return sharedSayings;
}

-(instancetype)init
{
    [NSException exceptionWithName:@"Illegal method call" reason:@"Use +sharedSayings instead." userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // Load sayings file
        NSString *sayingsFilePath = [[NSBundle mainBundle] pathForResource:SAYINGS_FILE ofType:SAYINGS_FILE_EXT];
        NSError *error = nil;
        NSString *sayingsFile = [NSString stringWithContentsOfFile:sayingsFilePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@ %@", error, error.userInfo);
            return self;
        }
        
        // Load sayings file into sayings
        if (sayingsFile) {
            NSArray *sayingsList = [sayingsFile componentsSeparatedByString:@"\n"];
            for (NSString *sayingsLine in sayingsList) {
                NSArray *sayingsTrio = [sayingsLine componentsSeparatedByString:SAYINGS_FILE_DELIM];
                if ([sayingsTrio count] != 3) {
                    NSLog(@"Incorrect number of elements in array: %@", sayingsTrio);
                    continue;
                } else {
                    LSSaying *saying = [[LSSaying alloc] init];
                    saying.foreign = sayingsTrio[0];
                    saying.pronounciation = sayingsTrio[1];
                    saying.home = sayingsTrio[2];
                    NSLog(@"Loading saying into sayings: %@", saying);
                    [self.sayings addObject:saying];
                }
            }
        }
    }
    return self;
}

-(NSArray *)allSayings
{
    return [self.sayings copy];
}

-(LSSaying *)randomSaying
{
    return self.sayings[arc4random() % [self.sayings count]];
}

@end

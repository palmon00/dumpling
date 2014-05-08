//
//  EBRMySceneDelegate.h
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 5/8/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EBRMySceneDelegate <NSObject>

-(void)playNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andPlayer:(AudioUnit)player;

@end
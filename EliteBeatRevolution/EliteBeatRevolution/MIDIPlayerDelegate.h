//
//  MIDIPlayerDelegate.h
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 5/8/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIDIPlayerDelegate <NSObject>

-(void) showNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:(BOOL)visibility andPlayer:(AudioUnit)player;

@end
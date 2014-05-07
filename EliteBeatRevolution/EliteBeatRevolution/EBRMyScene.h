//
//  EBRMyScene.h
//  EliteBeatRevolution
//

//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define ERROR_MARGIN 20
#define NOTE_SPEED 3
#define NOTE_RARITY 50

@protocol EBRMySceneDelegate <NSObject>

-(void)playNote:(int)note AtOctave:(int)octave;

@end

@interface EBRMyScene : SKScene

@end

//
//  EBRMyScene.h
//  EliteBeatRevolution
//

//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "EBRMySceneDelegate.h"
#import "MIDIPlayer.h"

#define ERROR_MARGIN 20
#define NOTE_SPEED 3
#define NOTE_RARITY 50

@protocol EBRMySceneDelegate;

@interface EBRMyScene : SKScene <MIDIPlayerDelegate>

@property (weak, nonatomic) id <EBRMySceneDelegate> delegate;

@end

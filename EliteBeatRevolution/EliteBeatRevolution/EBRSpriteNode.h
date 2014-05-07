//
//  EBRSpriteNode.h
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 5/7/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface EBRSpriteNode : SKSpriteNode

@property (nonatomic) char note;
@property (nonatomic) char midiStatus;
@property (nonatomic) char velocity;
@property (nonatomic) AudioUnit player;
@property (nonatomic) BOOL visibility;

@end

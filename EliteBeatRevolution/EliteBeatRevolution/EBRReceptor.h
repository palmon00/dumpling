//
//  EBRReceptor.h
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 4/29/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class EBRReceptor;

@protocol EBRReceptorDelegate <NSObject>

-(void)wasPressed:(EBRReceptor *)receptor;

@end

@interface EBRReceptor : SKSpriteNode

@property (weak, nonatomic) id delegate;

@end

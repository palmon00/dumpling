//
//  EBRSpriteNode.m
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 5/7/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import "EBRSpriteNode.h"

@implementation EBRSpriteNode

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate wasPressed:self];
}

@end

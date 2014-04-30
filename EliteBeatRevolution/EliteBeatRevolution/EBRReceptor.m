//
//  EBRReceptor.m
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 4/29/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import "EBRReceptor.h"

@implementation EBRReceptor

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate wasPressed:self];
}

@end

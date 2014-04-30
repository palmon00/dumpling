//
//  EBRMyScene.m
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 4/29/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import "EBRMyScene.h"
#import "EBRReceptor.h"

@interface EBRMyScene () <EBRReceptorDelegate>

@end

@implementation EBRMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        EBRReceptor *downReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Down Receptor.png"];
        EBRReceptor *leftReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Left Receptor.png"];
        EBRReceptor *rightReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Right Receptor.png"];
        EBRReceptor *upReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Up Receptor.png"];
        
        leftReceptor.position = CGPointMake(CGRectGetWidth(self.frame)/5, 9*CGRectGetHeight(self.frame)/10);
        downReceptor.position = CGPointMake(2*CGRectGetWidth(self.frame)/5, 9*CGRectGetHeight(self.frame)/10);
        upReceptor.position = CGPointMake(3*CGRectGetWidth(self.frame)/5, 9*CGRectGetHeight(self.frame)/10);
        rightReceptor.position = CGPointMake(4*CGRectGetWidth(self.frame)/5, 9*CGRectGetHeight(self.frame)/10);
        
        [self addChild:leftReceptor];
        [self addChild:downReceptor];
        [self addChild:upReceptor];
        [self addChild:rightReceptor];
        
        // Respond to receptor touches
        leftReceptor.delegate = self;
        downReceptor.delegate = self;
        upReceptor.delegate = self;
        rightReceptor.delegate = self;
        
        // Enable touch events
        leftReceptor.userInteractionEnabled = YES;
        downReceptor.userInteractionEnabled = YES;
        upReceptor.userInteractionEnabled = YES;
        rightReceptor.userInteractionEnabled = YES;
        
        // Ensure receptors are above notes
        leftReceptor.zPosition = 100;
        downReceptor.zPosition = 100;
        upReceptor.zPosition = 100;
        rightReceptor.zPosition = 100;
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    [self enumerateChildNodesWithName:@"note" usingBlock:^(SKNode *node, BOOL *stop) {
        // Remove notes above top of screen
        if (node.position.y > CGRectGetHeight(self.frame) + node.frame.size.height) [node removeFromParent];
        else {
            // Move note up screen
            CGPoint newPosition = CGPointMake(node.position.x, node.position.y + 1);
            node.position = newPosition;
        }
    }];
    
    // Add a random note once in a while
    if (!(arc4random() % 100)) [self addChild:[self randomNote]];
}

-(SKSpriteNode *)randomNote
{
    // Add a random note in a random position
    SKSpriteNode *randomNote = nil;
    
    int randomNoteType = arc4random() % 4;
    switch (randomNoteType) {
        case 0:
            randomNote = [SKSpriteNode spriteNodeWithImageNamed:@"Left.gif"];
            randomNote.position = CGPointMake(CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
            break;
        case 1:
            randomNote = [SKSpriteNode spriteNodeWithImageNamed:@"Down.gif"];
            randomNote.position = CGPointMake(2*CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
            break;
        case 2:
            randomNote = [SKSpriteNode spriteNodeWithImageNamed:@"Up.gif"];
            randomNote.position = CGPointMake(3*CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
            break;
        case 3:
            randomNote = [SKSpriteNode spriteNodeWithImageNamed:@"Right.gif"];
            randomNote.position = CGPointMake(4*CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
            break;
        default:
            break;
    }
    randomNote.name = @"note";
    return randomNote;
}

-(void)wasPressed:(EBRReceptor *)receptor
{
    __block BOOL destroyedNote = NO;
    
    // Destroy any notes under receptor
    [self enumerateChildNodesWithName:@"note" usingBlock:^(SKNode *node, BOOL *stop) {
//        NSLog(@"NodeX %f ReceptorX %f", node.position.x, receptor.position.x);
        if (node.position.x == receptor.position.x)
            if ((node.position.y > receptor.position.y - ERROR_MARGIN) &&
                (node.position.y < receptor.position.y + ERROR_MARGIN))
            {
                NSLog(@"NodeXY %f %f ReceptorXY %f %f", node.position.x, node.position.y, receptor.position.x, receptor.position.y);
                [node removeFromParent];
                destroyedNote = YES;
            }
    }];
    
    SKLabelNode *feedback = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    if (destroyedNote) feedback.text = @"Wonderful!";
    else feedback.text = @"Miss!";
    feedback.fontSize = 42;
    feedback.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *fadeSequence = [SKAction sequence:@[fadeAway, remove]];
    [self addChild:feedback];
    [feedback runAction:fadeSequence];
}

@end

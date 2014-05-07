//
//  EBRMyScene.m
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 4/29/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import "EBRMyScene.h"
#import "EBRReceptor.h"
#import "EBRSpriteNode.h"

@interface EBRMyScene () <EBRReceptorDelegate>

@property (nonatomic) BOOL shouldAddNote;
@property (strong, nonatomic) NSMutableArray *notesToAdd; // of EBRSpriteNode

@end

@implementation EBRMyScene

-(NSMutableArray *)notesToAdd
{
    if (!_notesToAdd) _notesToAdd = [[NSMutableArray alloc] init];
    return _notesToAdd;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        EBRReceptor *downReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Down Receptor.png"];
        EBRReceptor *leftReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Left Receptor.png"];
        EBRReceptor *rightReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Right Receptor.png"];
        EBRReceptor *upReceptor = [EBRReceptor spriteNodeWithImageNamed:@"Up Receptor.png"];
        
        leftReceptor.position = CGPointMake(CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
        downReceptor.position = CGPointMake(2*CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
        upReceptor.position = CGPointMake(3*CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
        rightReceptor.position = CGPointMake(4*CGRectGetWidth(self.frame)/5, 1*CGRectGetHeight(self.frame)/10);
        
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
        
        // Set no note initially
        self.shouldAddNote = NO;
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    [self enumerateChildNodesWithName:@"note" usingBlock:^(SKNode *node, BOOL *stop) {
        
        // Remove notes under buttons
        if (node.position.y <= 1*CGRectGetHeight(self.frame)/10) {
            EBRSpriteNode *ebrSpriteNode = (EBRSpriteNode *)node;
            
            // Play the note if it is note visible
            if (!ebrSpriteNode.visibility) {
                // Let's play the music asynchronously
//                dispatch_queue_t playQueue = dispatch_queue_create("playQueue", NULL);
//                dispatch_async(playQueue, ^{
                    [self.delegate playNote:ebrSpriteNode.note withStatus:ebrSpriteNode.midiStatus andVelocity:ebrSpriteNode.velocity andPlayer:ebrSpriteNode.player];
//                });
            }
            
            // Remove the note
            [node removeFromParent];
        }
        else {
            // Move note down screen
            CGPoint newPosition = CGPointMake(node.position.x, node.position.y - NOTE_SPEED);
            node.position = newPosition;
        }
    }];
    
    // Only add a notes at end of update cycle
    NSArray *currentNotesToAdd = [self.notesToAdd copy];
    for (EBRSpriteNode *spriteNode in currentNotesToAdd) {
        [self addChild:spriteNode];
        [self.notesToAdd removeObject:spriteNode];
    }
}


-(void) showNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:(BOOL)visibility andPlayer:(AudioUnit)player
{
//    NSLog(@"Adding note!");
    [self.notesToAdd addObject:[self randomNote:note withStatus:midiStatus andVelocity:velocity andVisibility:visibility andPlayer:(AudioUnit)player]];
}

-(EBRSpriteNode *)randomNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:(BOOL)visibility andPlayer:(AudioUnit)player
{
    // Add a random note in a random position
    EBRSpriteNode *randomNote = nil;
    
    int randomNoteType = arc4random() % 4;
    switch (randomNoteType) {
        case 0:
            if (visibility) randomNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Left.gif"];
            else randomNote = [[EBRSpriteNode alloc] init];
            randomNote.position = CGPointMake(CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)*.5);
            break;
        case 1:
            if (visibility) randomNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Down.gif"];
            else randomNote = [[EBRSpriteNode alloc] init];
            randomNote.position = CGPointMake(2*CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)*.5);
            break;
        case 2:
            if (visibility) randomNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Up.gif"];
            else randomNote = [[EBRSpriteNode alloc] init];
            randomNote.position = CGPointMake(3*CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)*.5);
            break;
        case 3:
            if (visibility) randomNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Left.gif"];
            else randomNote = [[EBRSpriteNode alloc] init];
            randomNote.position = CGPointMake(4*CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame)*.5);
            break;
        default:
            break;
    }
    
    if (visibility) {
        randomNote.name = @"note";
        randomNote.note = note;
        randomNote.midiStatus = midiStatus;
        randomNote.velocity = velocity;
        randomNote.player = player;
        randomNote.visibility = YES;
    }
    else {
        randomNote.name = @"note";
        randomNote.note = note;
        randomNote.midiStatus = midiStatus;
        randomNote.velocity = velocity;
        randomNote.player = player;
        randomNote.visibility = NO;
    }
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
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.5];
    SKAction *moveUp = [SKAction moveByX:0 y:100 duration:0.5];
    SKAction *fadeMove = [SKAction group:@[fadeAway, moveUp]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *fadeSequence = [SKAction sequence:@[fadeMove, remove]];
    [self addChild:feedback];
    [feedback runAction:fadeSequence];
}

@end

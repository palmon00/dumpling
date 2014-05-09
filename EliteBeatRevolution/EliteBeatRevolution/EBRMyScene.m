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

@interface EBRMyScene () <EBRSpriteNodeDelegate>

@property (strong, atomic) NSMutableArray *notesToAdd; // of EBRSpriteNode
@property (atomic) int lastNote;

@property (strong, nonatomic) SKTexture *up1;
@property (strong, nonatomic) SKTexture *up2;
@property (strong, nonatomic) SKTexture *up3;
@property (strong, nonatomic) SKTexture *up4;
@property (strong, nonatomic) SKTexture *up5;
@property (strong, nonatomic) SKTexture *up6;
@property (strong, nonatomic) SKTexture *up7;
@property (strong, nonatomic) SKTexture *up8;
@property (strong, nonatomic) SKTexture *up9;

@property (strong, nonatomic) SKTexture *down1;
@property (strong, nonatomic) SKTexture *down2;
@property (strong, nonatomic) SKTexture *down3;
@property (strong, nonatomic) SKTexture *down4;
@property (strong, nonatomic) SKTexture *down5;
@property (strong, nonatomic) SKTexture *down6;
@property (strong, nonatomic) SKTexture *down7;
@property (strong, nonatomic) SKTexture *down8;
@property (strong, nonatomic) SKTexture *down9;

@property (strong, nonatomic) SKTexture *left1;
@property (strong, nonatomic) SKTexture *left2;
@property (strong, nonatomic) SKTexture *left3;
@property (strong, nonatomic) SKTexture *left4;
@property (strong, nonatomic) SKTexture *left5;
@property (strong, nonatomic) SKTexture *left6;
@property (strong, nonatomic) SKTexture *left7;
@property (strong, nonatomic) SKTexture *left8;
@property (strong, nonatomic) SKTexture *left9;

@property (strong, nonatomic) SKTexture *right1;
@property (strong, nonatomic) SKTexture *right2;
@property (strong, nonatomic) SKTexture *right3;
@property (strong, nonatomic) SKTexture *right4;
@property (strong, nonatomic) SKTexture *right5;
@property (strong, nonatomic) SKTexture *right6;
@property (strong, nonatomic) SKTexture *right7;
@property (strong, nonatomic) SKTexture *right8;
@property (strong, nonatomic) SKTexture *right9;


@end

@implementation EBRMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // Initialize notesToAdd
        self.notesToAdd = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKSpriteNode *leftPlacer = [SKSpriteNode spriteNodeWithImageNamed:@"Right Receptor.png"];
        SKSpriteNode *rightPlacer = [SKSpriteNode spriteNodeWithImageNamed:@"Left Receptor.png"];
        
        leftPlacer.position = CGPointMake(CGRectGetWidth(self.frame)/129, 1*CGRectGetHeight(self.frame)/10);
        rightPlacer.position = CGPointMake(128*CGRectGetWidth(self.frame)/129, 1*CGRectGetHeight(self.frame)/10);
        
        [self addChild:leftPlacer];
        [self addChild:rightPlacer];
        
        // Ensure placers are below notes
        leftPlacer.zPosition = -100;
        rightPlacer.zPosition = -100;
        
        // Initialize lastNote
        self.lastNote = 0;
        
        // Add dancing note
        SKSpriteNode *dancer = [SKSpriteNode spriteNodeWithImageNamed:@"walk_down_1"];
        dancer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*2/3);
        dancer.name = @"dancer";
        [self addChild:dancer];
        
        self.up1 = [SKTexture textureWithImageNamed:@"walk_up_1"];
        self.up2 = [SKTexture textureWithImageNamed:@"walk_up_2"];
        self.up3 = [SKTexture textureWithImageNamed:@"walk_up_3"];
        self.up4 = [SKTexture textureWithImageNamed:@"walk_up_4"];
        self.up5 = [SKTexture textureWithImageNamed:@"walk_up_5"];
        self.up6 = [SKTexture textureWithImageNamed:@"walk_up_6"];
        self.up7 = [SKTexture textureWithImageNamed:@"walk_up_7"];
        self.up8 = [SKTexture textureWithImageNamed:@"walk_up_8"];
        self.up9 = [SKTexture textureWithImageNamed:@"walk_up_9"];
        
        self.down1 = [SKTexture textureWithImageNamed:@"walk_down_1"];
        self.down2 = [SKTexture textureWithImageNamed:@"walk_down_2"];
        self.down3 = [SKTexture textureWithImageNamed:@"walk_down_3"];
        self.down4 = [SKTexture textureWithImageNamed:@"walk_down_4"];
        self.down5 = [SKTexture textureWithImageNamed:@"walk_down_5"];
        self.down6 = [SKTexture textureWithImageNamed:@"walk_down_6"];
        self.down7 = [SKTexture textureWithImageNamed:@"walk_down_7"];
        self.down8 = [SKTexture textureWithImageNamed:@"walk_down_8"];
        self.down9 = [SKTexture textureWithImageNamed:@"walk_down_9"];
        
        self.left1 = [SKTexture textureWithImageNamed:@"walk_left_1"];
        self.left2 = [SKTexture textureWithImageNamed:@"walk_left_2"];
        self.left3 = [SKTexture textureWithImageNamed:@"walk_left_3"];
        self.left4 = [SKTexture textureWithImageNamed:@"walk_left_4"];
        self.left5 = [SKTexture textureWithImageNamed:@"walk_left_5"];
        self.left6 = [SKTexture textureWithImageNamed:@"walk_left_6"];
        self.left7 = [SKTexture textureWithImageNamed:@"walk_left_7"];
        self.left8 = [SKTexture textureWithImageNamed:@"walk_left_8"];
        self.left9 = [SKTexture textureWithImageNamed:@"walk_left_9"];
        
        self.right1 = [SKTexture textureWithImageNamed:@"walk_right_1"];
        self.right2 = [SKTexture textureWithImageNamed:@"walk_right_2"];
        self.right3 = [SKTexture textureWithImageNamed:@"walk_right_3"];
        self.right4 = [SKTexture textureWithImageNamed:@"walk_right_4"];
        self.right5 = [SKTexture textureWithImageNamed:@"walk_right_5"];
        self.right6 = [SKTexture textureWithImageNamed:@"walk_right_6"];
        self.right7 = [SKTexture textureWithImageNamed:@"walk_right_7"];
        self.right8 = [SKTexture textureWithImageNamed:@"walk_right_8"];
        self.right9 = [SKTexture textureWithImageNamed:@"walk_right_9"];
        
        [self dancerNeutral];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    [self enumerateChildNodesWithName:@"note" usingBlock:^(SKNode *node, BOOL *stop) {
        
        EBRSpriteNode *ebrSpriteNode = (EBRSpriteNode *)node;
        
        // Remove visible notes when they reach bottom of screen
        if (ebrSpriteNode.visibility) {
            if (ebrSpriteNode.position.y <= 0) {
                [node removeFromParent];
                [self dancerFail];
            }
        } else {
            
            // Play and remove invisible notes under buttons
            if (node.position.y <= 1*CGRectGetHeight(self.frame)/10) {
                
                // Play note
                [self.delegate playNote:ebrSpriteNode.note withStatus:ebrSpriteNode.midiStatus andVelocity:ebrSpriteNode.velocity andPlayer:ebrSpriteNode.player];
                
                // Remove the note
                [node removeFromParent];
            }
        }
        
        // Move note down screen
        CGPoint newPosition = CGPointMake(node.position.x, node.position.y - NOTE_SPEED);
        node.position = newPosition;
    }];
    
    // Only add a notes at end of update cycle
    if ([self.notesToAdd count]) {
        NSArray *currentNotesToAdd = [self.notesToAdd copy];
        for (EBRSpriteNode *spriteNode in currentNotesToAdd) {
            [self addChild:spriteNode];
            [self.notesToAdd removeObject:spriteNode];
        }
    }
}


-(void)showNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:(BOOL)visibility andPlayer:(AudioUnit)player
{
    // Add invisble notes in middle
    if (!visibility) {
        EBRSpriteNode *newNote = [[EBRSpriteNode alloc] init];
        newNote.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        newNote.name = @"note";
        newNote.note = note;
        newNote.midiStatus = midiStatus;
        newNote.velocity = velocity;
        newNote.player = player;
        newNote.visibility = NO;
        newNote.userInteractionEnabled = NO;
        [self.notesToAdd addObject:newNote];
        return;
    }
    
    // Add visible notes in position based on note change range
    EBRSpriteNode *newNote = nil;
    
    int noteChange = (int)note - self.lastNote;
    
    if (noteChange > 0) {
        newNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Right.gif"];
    } else if (noteChange == 0) {
        newNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Up.gif"];
    } else if (noteChange < 0) {
        newNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Left.gif"];
    } else {
        newNote = [EBRSpriteNode spriteNodeWithImageNamed:@"Down.gif"];
    }
    
    //    int noteNumber = ((int) note) % 12;
    newNote.position = CGPointMake(((int)note)*CGRectGetWidth(self.frame)/129, CGRectGetHeight(self.frame)/2);
    
    newNote.name = @"note";
    newNote.note = note;
    newNote.midiStatus = midiStatus;
    newNote.velocity = velocity;
    newNote.player = player;
    newNote.visibility = YES;
    newNote.delegate = self;
    newNote.userInteractionEnabled = YES;
    
    [self.notesToAdd addObject:newNote];
    
    self.lastNote = (int)note;
}

-(void)wasPressed:(EBRSpriteNode *)node;
{
    // Play note
    [self.delegate playNote:node.note withStatus:node.midiStatus andVelocity:node.velocity andPlayer:node.player];
    
    // Destroy node
    [node removeFromParent];
    
    // Animate dancer
    [self dancerSuccess];
}

//-(void)wasPressed:(EBRReceptor *)receptor
//{
//    __block BOOL destroyedNote = NO;
//
//    // Destroy any visible notes under receptor
//    [self enumerateChildNodesWithName:@"note" usingBlock:^(SKNode *node, BOOL *stop) {
//        //        NSLog(@"NodeX %f ReceptorX %f", node.position.x, receptor.position.x);
//        EBRSpriteNode *ebrSpriteNode = (EBRSpriteNode *)node;
//        if (ebrSpriteNode.visibility == YES) {
//            if (ebrSpriteNode.position.x == receptor.position.x)
//                if ((node.position.y > receptor.position.y - ERROR_MARGIN) &&
//                    (node.position.y < receptor.position.y + ERROR_MARGIN))
//                {
//                    NSLog(@"NodeXY %f %f ReceptorXY %f %f", node.position.x, node.position.y, receptor.position.x, receptor.position.y);
//                    [node removeFromParent];
//                    destroyedNote = YES;
//                }
//        }
//    }];
//
//    SKLabelNode *feedback = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    if (destroyedNote) feedback.text = @"Wonderful!";
//    else feedback.text = @"Miss!";
//    feedback.fontSize = 42;
//    feedback.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.5];
//    SKAction *moveUp = [SKAction moveByX:0 y:100 duration:0.5];
//    SKAction *fadeMove = [SKAction group:@[fadeAway, moveUp]];
//    SKAction *remove = [SKAction removeFromParent];
//    SKAction *fadeSequence = [SKAction sequence:@[fadeMove, remove]];
//    [self addChild:feedback];
//    [feedback runAction:fadeSequence];
//}

-(void)dancerFail
{
    // Animate dancer
    NSMutableArray *dance = [[NSMutableArray alloc] init];
    [dance addObject:self.up1];
    [dance addObject:self.up2];
    [dance addObject:self.up3];
    [dance addObject:self.up4];
    [dance addObject:self.up5];
    [dance addObject:self.up6];
    [dance addObject:self.up7];
    [dance addObject:self.up8];
    [dance addObject:self.up9];
    SKAction *action = [SKAction animateWithTextures:dance timePerFrame:0.1 resize:YES restore:NO];
    [[self childNodeWithName:@"dancer"] runAction:action];
}

-(void)dancerSuccess
{
    // Animate dancer
    NSMutableArray *dance = [[NSMutableArray alloc] init];
    [dance addObject:self.right8];
    [dance addObject:self.right9];
    [dance addObject:self.right8];
    [dance addObject:self.right9];
    SKAction *swingRight = [SKAction animateWithTextures:dance timePerFrame:0.2];
    SKAction *moveRight = [SKAction moveByX:10 y:0 duration:0.8];
    SKAction *shuffleRight = [SKAction group:@[swingRight, moveRight]];
    [dance removeAllObjects];
    
    [dance addObject:self.left1];
    [dance addObject:self.left2];
    [dance addObject:self.left1];
    [dance addObject:self.left2];
    [dance addObject:self.left1];
    [dance addObject:self.left2];
    [dance addObject:self.left1];
    [dance addObject:self.left2];
    SKAction *swingLeft = [SKAction animateWithTextures:dance timePerFrame:0.2];
    SKAction *moveLeft = [SKAction moveByX:-20 y:0 duration:1.6];
    SKAction *shuffleLeft = [SKAction group:@[swingLeft, moveLeft]];
    
    SKAction *shuffle = [SKAction sequence:@[shuffleRight, shuffleLeft, shuffleRight]];
    [[self childNodeWithName:@"dancer"] runAction:shuffle];
}

-(void)dancerNeutral
{
    // Animate dancer
    NSMutableArray *dance = [[NSMutableArray alloc] init];
    [dance addObject:self.down1];
    [dance addObject:self.down2];
    [dance addObject:self.down3];
    [dance addObject:self.down4];
    [dance addObject:self.down5];
    [dance addObject:self.down6];
    [dance addObject:self.down7];
    [dance addObject:self.down8];
    [dance addObject:self.down9];
    SKAction *action = [SKAction animateWithTextures:dance timePerFrame:0.1 resize:YES restore:NO];
    SKAction *repeat = [SKAction repeatActionForever:action];
    [[self childNodeWithName:@"dancer"] runAction:repeat];
}

@end

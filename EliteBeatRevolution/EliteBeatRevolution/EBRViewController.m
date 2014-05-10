//
//  EBRViewController.m
//  EliteBeatRevolution
//
//  Created by Raymond Louie on 4/29/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "EBRViewController.h"
#import "EBRMyScene.h"
#import "MIDIPlayer.h"

@interface EBRViewController () <AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) EBRMyScene *myScene;
@property (strong, nonatomic) MIDIPlayer *notePlayer;
@property (strong, nonatomic) MIDIPlayer *soundPlayer;

@property (strong, nonatomic) AVSpeechSynthesizer *talker;

@end

@implementation EBRViewController



-(MIDIPlayer *)notePlayer
{
    if (!_notePlayer) _notePlayer = [[MIDIPlayer alloc] init];
    return _notePlayer;
}

-(MIDIPlayer *)soundPlayer
{
    if (!_soundPlayer) _soundPlayer = [[MIDIPlayer alloc] init];
    return _soundPlayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure myScene.
    self.myScene = [EBRMyScene sceneWithSize:skView.bounds.size];
    self.myScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.myScene];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.notePlayer.delegate = self.myScene;
    self.myScene.delegate = self.notePlayer;
    
    dispatch_queue_t noteQueue = dispatch_queue_create("noteQueue", NULL);
    dispatch_async(noteQueue, ^{
        [self.notePlayer midiPlay];
    });
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

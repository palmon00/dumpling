//
//  MIDIPlayer.h
//  MIDI Player
//
//  Created by Raymond Louie on 5/7/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreMIDI/CoreMIDI.h>
#import <AudioToolbox/AudioToolbox.h>
#import "EBRMySceneDelegate.h"
#import "MIDIPlayerDelegate.h"

#define MIDI_WRITE
#define PLAY_ALL

//#define INPUT_SONG @"Bob Marley - no woman no cry"
#define INPUT_SONG @"woman"
#define INPUT_SONG_EXTENSION @"mid"
#define MUTE_CHANNEL 9

#define USE_SOUND_FONT YES
#define SOUND_FONT @"FF7"
#define SOUND_FONT_EXTENSION @"sf2"
#define SOUND_FONT_PATCH (int)0

#define MIDI_CHANNEL 2

@interface MIDIPlayer : NSObject <EBRMySceneDelegate>

@property (weak, nonatomic) id <MIDIPlayerDelegate> delegate;

// Play midi without logging output
-(void)midiTest;

// Play midi and log output
-(void)midiPlay;

@end

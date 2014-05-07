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

#define INPUT_SONG @"ALWAYS_BE_MY_BABY"
#define INPUT_SONG_EXTENSION @"mid"

#define USE_SOUND_FONT YES
#define SOUND_FONT @"FF7"
#define SOUND_FONT_EXTENSION @"sf2"
#define SOUND_FONT_PATCH (int)3

#define MIDI_CHANNEL 3

@protocol MIDIPlayerDelegate <NSObject>

-(void) showNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:(BOOL)visibility andPlayer:(AudioUnit)player;

@end

@interface MIDIPlayer : NSObject

@property (weak, nonatomic) id <MIDIPlayerDelegate> delegate;

// Play midi without logging output
-(void)midiTest;

// Play midi and log output
-(void)midiPlay;

@end

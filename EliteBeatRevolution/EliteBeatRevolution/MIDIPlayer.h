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

#define MIDI_WRITE

//#define INPUT_SONG @"Bob Marley - no woman no cry"
#define INPUT_SONG @"rainbow"
#define INPUT_SONG_EXTENSION @"mid"
#define MUTE_CHANNEL 9

#define USE_SOUND_FONT NO
#define SOUND_FONT @"FF7"
#define SOUND_FONT_EXTENSION @"sf2"
#define SOUND_FONT_PATCH (int)3

#define MIDI_CHANNEL 2

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

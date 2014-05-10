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
//#define PLAY_ALL

//#define INPUT_SONG @"baby"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"rainbow"
//#define MIDI_CHANNEL 1
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"woman"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"madworld"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"thegoodb"
//#define MIDI_CHANNEL 5
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"elton_john-candle_in_the_wind"
//#define MIDI_CHANNEL 2
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Elton John - Rocket Man 1"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"elton_john-dont_let_the_sun"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"david_bowie-space_oddity"
//#define MIDI_CHANNEL 13
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Billy_Joel_-_Uptown_Girl"
//#define MIDI_CHANNEL 0
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Billy_Joel_-_The_Longest_Time"
//#define MIDI_CHANNEL 5
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Billy_Joel_-_Tell_Her_About_It"
//#define MIDI_CHANNEL 7
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Billy_Joel_-_She's_Got_a_Way"
//#define MIDI_CHANNEL 7
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Billy_Joel_-_River_of_Dreams"
//#define MIDI_CHANNEL 7
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Billy_Joel_-_Piano_Man"
//#define MIDI_CHANNEL 2
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"landdown"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"ordinary"
//#define MIDI_CHANNEL 10
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"Elton John - Tiny Dancer"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"herecoms"
//#define MIDI_CHANNEL 5
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"ticket"
//#define MIDI_CHANNEL 0
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"yesterday"
//#define MIDI_CHANNEL 1
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"norwood"
//#define MIDI_CHANNEL 1
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"inmylife"
//#define MIDI_CHANNEL 0
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"eleanorr"
//#define MIDI_CHANNEL 0
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"whenim64"
//#define MIDI_CHANNEL 0
//#define MUTE_CHANNEL 9
//
//#define INPUT_SONG @"pennylane"
//#define MIDI_CHANNEL 3
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"alluneed"
//#define MIDI_CHANNEL 1
//#define MUTE_CHANNEL 9
//
//#define INPUT_SONG @"strawbf"
//#define MIDI_CHANNEL 2
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"hellogby"
//#define MIDI_CHANNEL 2
//#define MUTE_CHANNEL 9

//#define INPUT_SONG @"obladi"
//#define MIDI_CHANNEL 0
//#define MUTE_CHANNEL 9
//
//#define INPUT_SONG @"whilegtr"
//#define MIDI_CHANNEL 5
//#define MUTE_CHANNEL 9
//
//#define INPUT_SONG @"blckbird"
//#define MIDI_CHANNEL 1
//#define MUTE_CHANNEL 9
//
//#define INPUT_SONG @"somethng"
//#define MIDI_CHANNEL 5
//#define MUTE_CHANNEL 9
//
//#define INPUT_SONG @"acrssunv"
//#define MIDI_CHANNEL 5
//#define MUTE_CHANNEL 9

#define INPUT_SONG @"letitdb"
#define MIDI_CHANNEL 6
#define MUTE_CHANNEL 9

//#define INPUT_SONG @"lawroad"
//#define MIDI_CHANNEL 1
//#define MUTE_CHANNEL 9

#define INPUT_SONG_EXTENSION @"mid"

#define USE_SOUND_FONT YES
#define SOUND_FONT @"FF7"
#define SOUND_FONT_EXTENSION @"sf2"
#define SOUND_FONT_PATCH (int)3

@interface MIDIPlayer : NSObject <EBRMySceneDelegate>

@property (weak, nonatomic) id <MIDIPlayerDelegate> delegate;

// Play midi without logging output
-(void)midiTest;

// Play midi and log output
-(void)midiPlay;

@end

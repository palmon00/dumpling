//
//  MIDIPlayer.m
//  MIDI Player
//
//  Created by Raymond Louie on 5/7/14.
//  Copyright (c) 2014 Raymond Louie. All rights reserved.
//

#import "MIDIPlayer.h"

@interface MIDIPlayer ()

@property (readwrite) AUGraph   processingGraph;
@property (readwrite) AudioUnit samplerUnit;
@property (readwrite) AudioUnit ioUnit;

@end

@implementation MIDIPlayer

- (BOOL) createAUGraph {
    
    // Each core audio call returns an OSStatus. This means that we
    // Can see if there have been any errors in the setup
	OSStatus result = noErr;
    
    // Create 2 audio units one sampler and one IO
	AUNode samplerNode, ioNode;
    
    // Specify the common portion of an audio unit's identify, used for both audio units
    // in the graph.
    // Setup the manufacturer - in this case Apple
	AudioComponentDescription cd = {};
	cd.componentManufacturer     = kAudioUnitManufacturer_Apple;
    
    // Instantiate an audio processing graph
	result = NewAUGraph (&_processingGraph);
    NSCAssert (result == noErr, @"Unable to create an AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	//Specify the Sampler unit, to be used as the first node of the graph
	cd.componentType = kAudioUnitType_MusicDevice; // type - music device
	cd.componentSubType = kAudioUnitSubType_Sampler; // sub type - sampler to convert our MIDI
	
    // Add the Sampler unit node to the graph
	result = AUGraphAddNode (self.processingGraph, &cd, &samplerNode);
    NSCAssert (result == noErr, @"Unable to add the Sampler unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	// Specify the Output unit, to be used as the second and final node of the graph
	cd.componentType = kAudioUnitType_Output;  // Output
	cd.componentSubType = kAudioUnitSubType_RemoteIO;  // Output to speakers
    
    // Add the Output unit node to the graph
	result = AUGraphAddNode (self.processingGraph, &cd, &ioNode);
    NSCAssert (result == noErr, @"Unable to add the Output unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Open the graph
	result = AUGraphOpen (self.processingGraph);
    NSCAssert (result == noErr, @"Unable to open the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Connect the Sampler unit to the output unit
	result = AUGraphConnectNodeInput (self.processingGraph, samplerNode, 0, ioNode, 0);
    NSCAssert (result == noErr, @"Unable to interconnect the nodes in the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	// Obtain a reference to the Sampler unit from its node
	result = AUGraphNodeInfo (self.processingGraph, samplerNode, 0, &_samplerUnit);
    NSCAssert (result == noErr, @"Unable to obtain a reference to the Sampler unit. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	// Obtain a reference to the I/O unit from its node
	result = AUGraphNodeInfo (self.processingGraph, ioNode, 0, &_ioUnit);
    NSCAssert (result == noErr, @"Unable to obtain a reference to the I/O unit. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    return YES;
}

// Starting with instantiated audio processing graph, configure its
// audio units, initialize it, and start it.
- (void) configureAndStartAudioProcessingGraph: (AUGraph) graph {
    
    OSStatus result = noErr;
    if (graph) {
        
        // Initialize the audio processing graph.
        result = AUGraphInitialize (graph);
        NSAssert (result == noErr, @"Unable to initialze AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
        
        // Start the graph
        result = AUGraphStart (graph);
        NSAssert (result == noErr, @"Unable to start audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
        
        // Print out the graph to the console
        CAShow (graph);
    }
}

static void MyMIDINotifyProc (const MIDINotification  *message, void *refCon) {
    printf("MIDI Notify, messageId=%d,", (int)message->messageID);
}

static void MyMIDIReadProc(const MIDIPacketList *pktlist,
                           void *refCon,
                           void *connRefCon) {
    
    // Track whether we've created a visible note for this packet
    BOOL madeVisibleNote = NO;
    
    MIDIPlayer *midiPlayer = (__bridge MIDIPlayer *)(refCon);
    
    AudioUnit player = (AudioUnit) midiPlayer.samplerUnit;
    
    MIDIPacket *packet = (MIDIPacket *)pktlist->packet;
    for (int i=0; i < pktlist->numPackets; i++) {
        
        Byte midiStatus = packet->data[0];
        Byte midiCommand = midiStatus >> 4;
        
        // Find a note on event
        if (midiCommand == 0x09) {
            Byte controller = midiStatus & 0x0F;
            Byte note = packet->data[1] & 0x7F;
            Byte velocity = packet->data[2] & 0x7F;
            
//            int noteNumber = ((int) note) % 12;
//            NSString *noteType;
//            switch (noteNumber) {
//                case 0:
//                    noteType = @"C";
//                    break;
//                case 1:
//                    noteType = @"C#";
//                    break;
//                case 2:
//                    noteType = @"D";
//                    break;
//                case 3:
//                    noteType = @"D#";
//                    break;
//                case 4:
//                    noteType = @"E";
//                    break;
//                case 5:
//                    noteType = @"F";
//                    break;
//                case 6:
//                    noteType = @"F#";
//                    break;
//                case 7:
//                    noteType = @"G";
//                    break;
//                case 8:
//                    noteType = @"G#";
//                    break;
//                case 9:
//                    noteType = @"A";
//                    break;
//                case 10:
//                    noteType = @"Bb";
//                    break;
//                case 11:
//                    noteType = @"B";
//                    break;
//                default:
//                    break;
//            }
            
            // The first MIDI_CHANNEL note with non-zero velocity should be shown
#ifndef PLAY_ALL
            if ((int)controller == MIDI_CHANNEL && !madeVisibleNote && (int)velocity != 0) {
                [midiPlayer.delegate showNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:YES andPlayer:player];
                madeVisibleNote = YES;
            } else {
#endif
                if ((int)controller <= MUTE_CHANNEL && (int)controller != MIDI_CHANNEL)
                [midiPlayer.delegate showNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andVisibility:NO andPlayer:player];
#ifndef PLAY_ALL
            }
#endif
            
#ifdef MIDI_WRITE
            NSString *packetData = @"";
            for (int i = 0; i < packet->length; i++) {
                packetData = [packetData stringByAppendingFormat:@"%02X ", packet->data[i]];
            }
            NSLog(@"PacketData: '%@'", packetData);
#endif
        }
        // Get next packet
        packet = MIDIPacketNext(packet);
    }
}

-(void)playNote:(char)note withStatus:(char)midiStatus andVelocity:(char)velocity andPlayer:(AudioUnit)player
{
    // Play all notes
    OSStatus result = noErr;
    result = MusicDeviceMIDIEvent (player, midiStatus, note, velocity, 0);
}

// this method assumes the class has a member called samplerUnit
// which is an instance of an AUSampler
-(OSStatus) loadFromDLSOrSoundFont: (NSURL *)bankURL withPatch: (int)presetNumber {
    
    OSStatus result = noErr;
    
    // fill out a bank preset data structure
    AUSamplerBankPresetData bpdata;
    bpdata.bankURL  = (__bridge CFURLRef) bankURL;
    bpdata.bankMSB  = kAUSampler_DefaultMelodicBankMSB;
    bpdata.bankLSB  = kAUSampler_DefaultBankLSB;
    bpdata.presetID = (UInt8) presetNumber;
    
    // set the kAUSamplerProperty_LoadPresetFromBank property
    result = AudioUnitSetProperty(self.samplerUnit,
                                  kAUSamplerProperty_LoadPresetFromBank,
                                  kAudioUnitScope_Global,
                                  0,
                                  &bpdata,
                                  sizeof(bpdata));
    
    // check for errors
    NSCAssert (result == noErr,
               @"Unable to set the preset property on the Sampler. Error code:%d '%.4s'",
               (int) result,
               (const char *)&result);
    
    return result;
}

-(void) midiTest {
    // Create a new music sequence
    MusicSequence s;
    // Initialize the music sequence
    NewMusicSequence(&s);
    
    // Get a string to the path of the MIDI file
    NSString *midiFilePath = [[NSBundle mainBundle]
                              pathForResource:INPUT_SONG
                              ofType:INPUT_SONG_EXTENSION];
    
    // Create a new URL which points to the MIDI file
    NSURL * midiFileURL = [NSURL fileURLWithPath:midiFilePath];
    
    MusicSequenceFileLoad(s, (__bridge CFURLRef)(midiFileURL), 0, 0);
    
    // Create a new music player
    MusicPlayer p;
    // Initialize the music player
    NewMusicPlayer(&p);
    
    // Load the sequence into the music player
    MusicPlayerSetSequence(p, s);
    // Called to do some MusicPlayer setup. This just
    // reduces latency when MusicPlayerStart is called
    MusicPlayerPreroll(p);
    
    // Starts the music playing
    MusicPlayerStart(p);
    
    // Get length of track so that we know how long to kill time for
    MusicTrack t;
    MusicTimeStamp len;
    UInt32 sz = sizeof(MusicTimeStamp);
    MusicSequenceGetIndTrack(s, 1, &t);
    MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &len, &sz);
    
    while (1) { // kill time until the music is over
        usleep (3 * 1000 * 1000);
        MusicTimeStamp now = 0;
        MusicPlayerGetTime (p, &now);
        if (now >= len)
            break;
    }
    
    // Stop the player and dispose of the objects
    MusicPlayerStop(p);
    DisposeMusicSequence(s);
    DisposeMusicPlayer(p);
}

//-(void) midiPlay {
//	
//    OSStatus result = noErr;
//    
//    
//    [self createAUGraph];
//    [self configureAndStartAudioProcessingGraph: self.processingGraph];
//    
//    // Create a client
//    MIDIClientRef virtualMidi;
//    result = MIDIClientCreate(CFSTR("Virtual Client"),
//                              MyMIDINotifyProc,
//                              NULL,
//                              &virtualMidi);
//    
//    NSAssert( result == noErr, @"MIDIClientCreate failed. Error code: %d '%.4s'", (int) result, (const char *)&result);
//    
//    // Create an endpoint
//    MIDIEndpointRef virtualEndpoint;
//    result = MIDIDestinationCreate(virtualMidi, CFSTR("Virtual Destination"), MyMIDIReadProc, self.samplerUnit, &virtualEndpoint);
//    
//    NSAssert( result == noErr, @"MIDIDestinationCreate failed. Error code: %d '%.4s'", (int) result, (const char *)&result);
//    
//    
//    
//    // Create a new music sequence
//    MusicSequence s;
//    // Initialise the music sequence
//    NewMusicSequence(&s);
//    
//    // Get a string to the path of the MIDI file which
//    // should be located in the Resources folder
//    //    NSString *midiFilePath = [[NSBundle mainBundle]
//    //                              pathForResource:@"simpletest"
//    //                              ofType:@"mid"];s
//    NSString *midiFilePath = [[NSBundle mainBundle]
//                              pathForResource:INPUT_SONG
//                              ofType:INPUT_SONG_EXTENSION];
//    
//    // Create a new URL which points to the MIDI file
//    NSURL * midiFileURL = [NSURL fileURLWithPath:midiFilePath];
//    
//    
//    MusicSequenceFileLoad(s, (__bridge CFURLRef) midiFileURL, 0, 0);
//    
//    // Create a new music player
//    MusicPlayer  p;
//    // Initialise the music player
//    NewMusicPlayer(&p);
//    
//    // ************* Set the endpoint of the sequence to be our virtual endpoint
//    MusicSequenceSetMIDIEndpoint(s, virtualEndpoint);
//    
//    if (USE_SOUND_FONT) {
//        // Load the sound font from file
//        NSURL *presetURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_FONT ofType:SOUND_FONT_EXTENSION]];
//        
//        // Initialise the sound font
//        [self loadFromDLSOrSoundFont: (NSURL *)presetURL withPatch: SOUND_FONT_PATCH];
//    }
//    
//    // Load the sequence into the music player
//    MusicPlayerSetSequence(p, s);
//    // Called to do some MusicPlayer setup. This just
//    // reduces latency when MusicPlayerStart is called
//    MusicPlayerPreroll(p);
//    // Starts the music playing
//    MusicPlayerStart(p);
//    
//    // Get length of track so that we know how long to kill time for
//    MusicTrack t;
//    MusicTimeStamp len;
//    UInt32 sz = sizeof(MusicTimeStamp);
//    MusicSequenceGetIndTrack(s, 1, &t);
//    MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &len, &sz);
//    
//    
//    while (1) { // kill time until the music is over
//        usleep (3 * 1000 * 1000);
//        MusicTimeStamp now = 0;
//        MusicPlayerGetTime (p, &now);
//        if (now >= len)
//            break;
//    }
//    
//    // Stop the player and dispose of the objects
//    MusicPlayerStop(p);
//    DisposeMusicSequence(s);
//    DisposeMusicPlayer(p);
//}

-(void) midiPlay {
    
    // Setup processing graph
    [self createAUGraph];
    [self configureAndStartAudioProcessingGraph: self.processingGraph];
    
    // Create a client
    OSStatus result = noErr;
    MIDIClientRef virtualMidi;
    result = MIDIClientCreate(CFSTR("Virtual Client"),
                              MyMIDINotifyProc,
                              NULL,
                              &virtualMidi);
    
    NSAssert( result == noErr, @"MIDIClientCreate failed. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Create an endpoint
    MIDIEndpointRef virtualEndpoint;
    result = MIDIDestinationCreate(virtualMidi, CFSTR("Virtual Destination"), MyMIDIReadProc, (__bridge void *)(self), &virtualEndpoint);
    
    NSAssert( result == noErr, @"MIDIDestinationCreate failed. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    
    
    // Create a new music sequence
    MusicSequence s;
    // Initialise the music sequence
    result = NewMusicSequence(&s);
    NSLog(@"NewMusicSequence: %d", (int)result);

    // Get a string to the path of the MIDI file which
    // should be located in the Resources folder
    //    NSString *midiFilePath = [[NSBundle mainBundle]
    //                              pathForResource:@"simpletest"
    //                              ofType:@"mid"];s
    NSString *midiFilePath = [[NSBundle mainBundle]
                              pathForResource:INPUT_SONG
                              ofType:INPUT_SONG_EXTENSION];
    NSLog(@"%@", midiFilePath);
    
    // Create a new URL which points to the MIDI file
    NSURL * midiFileURL = [NSURL fileURLWithPath:midiFilePath];
    NSLog(@"%@", midiFileURL);
    
    
    result = MusicSequenceFileLoad(s, (__bridge CFURLRef) midiFileURL, 0, 0);
    NSLog(@"MusicSequenceFileLoad: %d", (int)result);
    
    // Create a new music player
    MusicPlayer  p;
    // Initialise the music player
    result = NewMusicPlayer(&p);
    NSLog(@"NewMusicPlayer: %d", (int)result);
    
    // ************* Set the endpoint of the sequence to be our virtual endpoint
    MusicSequenceSetMIDIEndpoint(s, virtualEndpoint);
    
    if (USE_SOUND_FONT) {
        // Load the sound font from file
        NSURL *presetURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_FONT ofType:SOUND_FONT_EXTENSION]];
        
        // Initialise the sound font
        [self loadFromDLSOrSoundFont: (NSURL *)presetURL withPatch: SOUND_FONT_PATCH];
    }
    
    // Load the sequence into the music player
    result = MusicPlayerSetSequence(p, s);
    NSLog(@"MusicPlayerSetSequence: %d", (int)result);
    // Called to do some MusicPlayer setup. This just
    // reduces latency when MusicPlayerStart is called
    result = MusicPlayerPreroll(p);
    NSLog(@"MusicPlayerPreroll: %d", (int)result);
    
    NSLog(@"Starting to play music.");
    // Starts the music playing
    result = MusicPlayerStart(p);
    NSLog(@"MusicPlayerStart: %d", (int)result);

    // Timer not consistently working on all midi files - esp. poorly formatted ones.
//    // Get length of track so that we know how long to kill time for
//    MusicTrack t;
//    MusicTimeStamp len;
//    UInt32 sz = sizeof(MusicTimeStamp);
//    result = MusicSequenceGetIndTrack(s, 1, &t);
//    NSLog(@"MusicSequenceGetIndTrack: %d", (int)result);
//    
//    result = MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &len, &sz);
//    NSLog(@"MusicTrackGetProperty: %d", (int)result);
//
//    // If we have zero or less length, play for 10 minutes.
//    if (!(len > 0)) len = 600;
//    
//    while (1) { // kill time until the music is over
//        usleep (3 * 1000 * 1000);
//        MusicTimeStamp now = 0;
//        result = MusicPlayerGetTime (p, &now);
//        NSLog(@"MusicPlayerGetTime: %d %f %f", (int)result, now, len);
//        if (now >= len)
//            break;
//    }
//    
//    // Stop the player and dispose of the objects
//    result = MusicPlayerStop(p);
//    NSLog(@"MusicPlayerStop: %d", (int)result);
//    result = DisposeMusicSequence(s);
//    NSLog(@"DisposeMusicSequence: %d", (int)result);
//    result = DisposeMusicPlayer(p);
//    NSLog(@"DisposeMusicPlayer: %d", (int)result);
    
}


@end

//
//  LSViewController.h
//  Lao Shi
//
//  Created by Raymond Louie on 5/10/14.
//  Copyright (c) 2014 Caffeine and Code. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FOREIGN_LANGUAGE @"zh"

#define FOREIGN_SPEECH_VOLUME 1.0 // 0.0 to 1.0
#define FORIEGN_SPEECH_PITCH_MULT 1.0 // 0.5 to 2.0
#define FOREIGN_SPEECH_RATE AVSpeechUtteranceMinimumSpeechRate // AVSpeechUtteranceMaximumSpeechRate, AVSpeechUtteranceMinimumSpeechRate, AVSpeechUtteranceDefaultSpeechRate

#define NATIVE_SPEECH_VOLUME 1.0 // 0.0 to 1.0
#define NATIVE_SPEECH_PITCH_MULT 1.0 // 0.5 to 2.0
#define NATIVE_SPEECH_RATE (AVSpeechUtteranceDefaultSpeechRate-AVSpeechUtteranceMinimumSpeechRate)/3 // AVSpeechUtteranceMaximumSpeechRate, AVSpeechUtteranceMinimumSpeechRate, AVSpeechUtteranceDefaultSpeechRate

@interface LSViewController : UIViewController

@end

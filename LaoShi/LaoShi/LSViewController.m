//
//  LSViewController.m
//  Lao Shi
//
//  Created by Raymond Louie on 5/10/14.
//  Copyright (c) 2014 Caffeine and Code. All rights reserved.
//

#import "LSViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LSSayings.h"
#import "LSSaying.h"

#define MOTION_EFFECT_MIN -10
#define MOTION_EFFECT_MAX +10

@interface LSViewController () <AVSpeechSynthesizerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITextView *speechTextView;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *phraseButton;
@property (weak, nonatomic) IBOutlet UIButton *foreignButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneticButton;
@property (weak, nonatomic) IBOutlet UIButton *nativeButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *localeSegmentedControl;
@property (strong, nonatomic) UISegmentedControl *mySegmentedControl;

@property (strong, nonatomic) NSMutableArray *foreignVoices; // of AVSpeechSynthesisVoice
@property (strong, nonatomic) AVSpeechSynthesisVoice *homeVoice;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@property (nonatomic) int textType;
@property (strong, nonatomic) LSSayings *sayings;
@property (strong, nonatomic) LSSaying *currentSaying;

@end

@implementation LSViewController

#pragma mark - Lazy Instantiation

-(NSMutableArray *)foreignVoices
{
    if (!_foreignVoices) _foreignVoices = [[NSMutableArray alloc] init];
    return _foreignVoices;
}

-(AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Register as delegate for textView
    self.speechTextView.delegate = self;
    
    // Retrieve all Foreign voices
    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
        NSString *language = voice.language;
        NSRange range = [language rangeOfString:FOREIGN_LANGUAGE];
        if (range.location != NSNotFound) [self.foreignVoices addObject:voice.language];
    }
    
    // Create new segmented control with voices and initialize appearance to values from nib segmented control
    self.mySegmentedControl = [[UISegmentedControl alloc] initWithItems:self.foreignVoices];
    self.mySegmentedControl.apportionsSegmentWidthsByContent = self.localeSegmentedControl.apportionsSegmentWidthsByContent;
    self.mySegmentedControl.tintColor = self.localeSegmentedControl.tintColor;
    self.mySegmentedControl.selectedSegmentIndex = 0;
    self.mySegmentedControl.momentary = NO;
    self.mySegmentedControl.enabled = YES;
    self.mySegmentedControl.selected = YES;
    
    // Copy frame and bounds
    self.mySegmentedControl.frame = self.localeSegmentedControl.frame;
    self.mySegmentedControl.bounds = self.localeSegmentedControl.bounds;
    
    // Swap controls
    [self.localeSegmentedControl removeFromSuperview];
    [self.view addSubview:self.mySegmentedControl];
    
    // Create motion effects
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(MOTION_EFFECT_MIN);
    horizontalMotionEffect.maximumRelativeValue = @(MOTION_EFFECT_MAX);
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(MOTION_EFFECT_MIN);
    verticalMotionEffect.maximumRelativeValue = @(MOTION_EFFECT_MAX);
    
    // Apply motion effects
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) continue; // Don't add to imageView
        [view addMotionEffect:horizontalMotionEffect];
        [view addMotionEffect:verticalMotionEffect];
    }
    
    // Initialize sayings
    self.sayings = [LSSayings sharedSayings];
    
    // Initialize home voice
    self.homeVoice = [AVSpeechSynthesisVoice voiceWithLanguage:[AVSpeechSynthesisVoice currentLanguageCode]];
    
    // Initialize textType
    self.textType = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)speakButtonPressed:(UIButton *)sender {
    
    // Drop the keyboard
    [self.speechTextView resignFirstResponder];
    
    // Stop the current speech
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    
    // Prepare utterance
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.speechTextView.text];
    
    // Speak the text in foreign language if foreign language was selected
    if (self.textType == 0) {
        
        // Prepare and speak utterance
        if (sizeof(self.mySegmentedControl.selectedSegmentIndex) == sizeof(int)) {
            NSLog(@"Selected locale index is: %d", (int)[self.mySegmentedControl selectedSegmentIndex]);
        } else if (sizeof(self.mySegmentedControl.selectedSegmentIndex) == sizeof(double)) {
            NSLog(@"Selected locale index is: %f", (double)[self.mySegmentedControl selectedSegmentIndex]);
        }
        
        NSString *selectedVoice = self.foreignVoices[[self.mySegmentedControl selectedSegmentIndex]];
        NSLog(@"Selected voice is: %@", selectedVoice);
        
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:selectedVoice];
        NSLog(@"Voice is: %@", voice);
        
        // Speak the text in foreign language
        [utterance setVoice:voice];
        utterance.volume = FOREIGN_SPEECH_VOLUME;
        utterance.rate = FOREIGN_SPEECH_RATE;
        utterance.pitchMultiplier = FORIEGN_SPEECH_PITCH_MULT;
    } else {
        
        // Speak the text in home language
        [utterance setVoice:self.homeVoice];
        utterance.volume = NATIVE_SPEECH_VOLUME;
        utterance.rate = NATIVE_SPEECH_RATE;
        utterance.pitchMultiplier = NATIVE_SPEECH_PITCH_MULT;
    }
    
    [self.synthesizer speakUtterance:utterance];
}

- (IBAction)phraseButtonPressed:(UIButton *)sender {
    // Retrieve new saying and update textview
    self.currentSaying = [self.sayings randomSaying];
    [self foreignButtonPressed:nil];
}

- (IBAction)foreignButtonPressed:(UIButton *)sender {
    // Update textview
    self.speechTextView.text = self.currentSaying.foreign;
    self.textType = 0;
    self.foreignButton.enabled = NO;
    self.phoneticButton.enabled = YES;
    self.nativeButton.enabled = YES;
}

- (IBAction)phoneticButtonPressed:(UIButton *)sender {
    // Update textview
    self.speechTextView.text = self.currentSaying.pronounciation;
    self.textType = 1;
    self.foreignButton.enabled = YES;
    self.phoneticButton.enabled = NO;
    self.nativeButton.enabled = YES;
}

- (IBAction)nativeButtonPressed:(UIButton *)sender {
    // Update textview
    self.speechTextView.text = self.currentSaying.home;
    self.textType = 2;
    self.foreignButton.enabled = YES;
    self.phoneticButton.enabled = YES;
    self.nativeButton.enabled = NO;
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Drop keyboard on touches outside textview
    [self.speechTextView resignFirstResponder];
}

#pragma mark - UITextView Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Drop keyboard on for return key
    if ([text isEqualToString:@"\n"]) {
        [self.speechTextView resignFirstResponder];
        return NO;
    }
    
    // Enable all buttons
    self.foreignButton.enabled = self.phoneticButton.enabled = self.nativeButton.enabled = YES;
    
    // Change to native language
    self.textType = 0;
    
    return YES;
}

@end

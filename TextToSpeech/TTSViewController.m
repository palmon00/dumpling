//
//  TTSViewController.m
//  Text To Speech
//
//  Created by Raymond Louie on 5/9/14.
//  Copyright (c) 2014 Caffeine and Code. All rights reserved.
//

#import "TTSViewController.h"
#import <AVFoundation/AVFoundation.h>

#define MOTION_EFFECT_MIN -10
#define MOTION_EFFECT_MAX +10

@interface TTSViewController () <AVSpeechSynthesizerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITextView *speechTextView;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *churchillButton;
@property (weak, nonatomic) IBOutlet UIButton *paikeaButton;
@property (weak, nonatomic) IBOutlet UIButton *lincolnButton;
@property (weak, nonatomic) IBOutlet UIButton *savannahButton;
@property (weak, nonatomic) IBOutlet UIButton *bilboButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *localeSegmentedControl;
@property (strong, nonatomic) UISegmentedControl *mySegmentedControl;

@property (strong, nonatomic) NSMutableArray *englishVoices;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@property (nonatomic) float speechRate, pitchMultiplier, speechRateRange;

@end

@implementation TTSViewController

-(NSMutableArray *)englishVoices
{
    if (!_englishVoices) _englishVoices = [[NSMutableArray alloc] init];
    return _englishVoices;
}

-(AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Register as delegate for textView
    self.speechTextView.delegate = self;
    
    // Setup speechRateRange
    self.speechRateRange = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate;
    
    // Retrieve all English voices
    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
        NSString *language = voice.language;
        NSRange range = [language rangeOfString:@"en"];
        if (range.location != NSNotFound) [self.englishVoices addObject:voice.language];
    }
    
    // Create new segmented control with voices and initialize appearance to values from nib segmented control
    self.mySegmentedControl = [[UISegmentedControl alloc] initWithItems:self.englishVoices];
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
    
    // Add motion effects
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(MOTION_EFFECT_MIN);
    horizontalMotionEffect.maximumRelativeValue = @(MOTION_EFFECT_MAX);
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(MOTION_EFFECT_MIN);
    verticalMotionEffect.maximumRelativeValue = @(MOTION_EFFECT_MAX);
    
    [self.instructionLabel addMotionEffect:horizontalMotionEffect];
    [self.instructionLabel addMotionEffect:verticalMotionEffect];
    [self.speechTextView addMotionEffect:horizontalMotionEffect];
    [self.speechTextView addMotionEffect:verticalMotionEffect];
    [self.speakButton addMotionEffect:horizontalMotionEffect];
    [self.speakButton addMotionEffect:verticalMotionEffect];
    [self.churchillButton addMotionEffect:horizontalMotionEffect];
    [self.churchillButton addMotionEffect:verticalMotionEffect];
    [self.paikeaButton addMotionEffect:horizontalMotionEffect];
    [self.paikeaButton addMotionEffect:verticalMotionEffect];
    [self.lincolnButton addMotionEffect:horizontalMotionEffect];
    [self.lincolnButton addMotionEffect:verticalMotionEffect];
    [self.savannahButton addMotionEffect:horizontalMotionEffect];
    [self.savannahButton addMotionEffect:verticalMotionEffect];
    [self.bilboButton addMotionEffect:horizontalMotionEffect];
    [self.bilboButton addMotionEffect:verticalMotionEffect];
    [self.mySegmentedControl addMotionEffect:horizontalMotionEffect];
    [self.mySegmentedControl addMotionEffect:verticalMotionEffect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)speakButton:(UIButton *)sender {
    // Drop the keyboard
    [self.speechTextView resignFirstResponder];

    // Stop the current speech
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    
    // Prepare and speak utterance
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.speechTextView.text];
    NSLog(@"Selected segmented index is: %d", [self.mySegmentedControl selectedSegmentIndex]);
    NSString *selectedVoice = self.englishVoices[[self.mySegmentedControl selectedSegmentIndex]];
    NSLog(@"Selected voice is: %@", selectedVoice);
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:selectedVoice];
    NSLog(@"Voice is: %@", voice);
    [utterance setVoice:voice];
    utterance.volume = 1.0;
    utterance.rate = self.speechRate;
    utterance.pitchMultiplier = self.pitchMultiplier;
    [self.synthesizer speakUtterance:utterance];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.speechTextView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.speechTextView resignFirstResponder];
        return NO;
    }
    
    // Reset pitch and rate if text was changed
    [self adultPitchAndRate];
    return YES;
}

- (IBAction)churchillSpeechButtonPressed:(UIButton *)sender {
    self.speechTextView.text = @"What General Weygand called the Battle of France is over. I expect that the Battle of Britain is about to begin. Upon this battle depends the survival of Christian civilization. Upon it depends our own British life, and the long continuity of our institutions, and our Empire. The whole fury and might of the enemy must very soon be turned on us. Hitler knows that he will have to break us in this Island or lose the war. If we can stand up to him, all Europe may be free, and the life of the world may move forward into broad sunlit uplands. But if we fail, then the whole world, including the United States, including all that we have known and cared for, will sink into the abyss of a new Dark Age, made more sinister, and perhaps more protracted, by the lights of per-verted science. Let us therefore brace ourselves to our duties, and so bear ourselves that if the British Empire and its Commonwealth last for a thousand years, men will still say, 'This was their finest hour.'";
    self.mySegmentedControl.selectedSegmentIndex = [self.englishVoices indexOfObject:@"en-GB"];
    
    [self churchillPitchAndRate];
}

- (IBAction)paikeaSpeechButtonPressed:(UIButton *)sender {
    self.speechTextView.text = @"This speech is a token of my deep love and respect... for Koro Apirana, my grandfather. My name is Paikea Apirana... and I come from a long line of chiefs, stretching all the way back to hawaiki... where our ancient ones are... the ones that first heard the land crying and sent a man. His name was also Paikea... and I am his most recent descendant. But I was not the leader my grandfather was expecting... and by being born... I broke the line back to the ancient ones. -- But we can learn. And if the knowledge is given to everyone, we can have lots of leaders. And soon, everyone will be strong... not just the ones that've been chosen. Because sometimes, even if you're the leader and you need to be strong... you can get tired. Like our ancestor, Paikea, when he was lost at sea... and he couldn't find the land, and he probably wanted to die. But he knew the ancient ones were there for him... so he called out to them to lift him up and give him strength. This is his chant. I dedicate it to my grandfather.  Uia mai koia, whakahuatia ake; Ko wai te whare nei e? Whitireia! Ko wai te tekoteko kei runga? Ko Paikea! Ko Paikea! Whakakau Paikea. Hei! Whakakau he tipua. Hei! Whakakau he taniwha. Hei! Ka ū Paikea ki Ahuahu. Pakia! Kei te whitia koe ko Kahutia-te-rangi. Aue! Me ai tō ure ki te tamahine a Te Whironui - aue! - nāna i noho te Roto-o-tahe. Aue! Aue! He koruru koe, koro e.";
    self.mySegmentedControl.selectedSegmentIndex = [self.englishVoices indexOfObject:@"en-AU"];
    
    [self paikeaPitchAndRate];
}

- (IBAction)madMaxSpeechButtonPressed:(UIButton *)sender {
    self.speechTextView.text = @"Time counts and keeps countin', and we knows now finding the trick of what's been and lost ain't no easy ride. But that's our trek, we gotta' travel it. And there ain't nobody knows where it's gonna' lead. Still in all, every night we does the tell, so that we 'member who we was and where we came from... but most of all we 'members the man that finded us, him that came the salvage. And we lights the city, not just for him, but for all of them that are still out there. 'Cause we knows there come a night, when they sees the distant light, and they'll be comin' home.";
    self.mySegmentedControl.selectedSegmentIndex = [self.englishVoices indexOfObject:@"en-AU"];
    
    [self savannahPitchAndRate];
}


- (IBAction)lincolnSpeechButtonPressed:(UIButton *)sender {
    self.speechTextView.text = @"Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.  Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battle-field of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives, that that nation might live. It is altogether fitting and proper that we should do this.  But, in a larger sense, we can not dedicate -- we can not consecrate -- we can not hallow this ground. The brave men living and dead who struggled here have consecrated it far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us -- that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion -- that we here highly resolve that these dead shall not have died in vain -- that this nation under God, shall have a new birth of freedom -- and that government of the people, by the people, for the people, shall not perish from the earth.";
    self.mySegmentedControl.selectedSegmentIndex = [self.englishVoices indexOfObject:@"en-US"];
    
    [self lincolnPitchAndRate];
}

- (IBAction)bilboSpeechButtonPressed:(UIButton *)sender {
    self.speechTextView.text = @"My dear people. My dear Bagginses and Boffins, and my dear Tooks and Brandybucks, and Grubbs, and Chubbs, and Burrowses, and Hornblowers, and Bolgers, Brace-girdles, Goodbodies, and Proudfoots... Also my good Sackville-Bagginses that I welcome back at last to Bag End. Today is my one hundred and eleventh birthday: I am eleventy-one today! I hope you are enjoying yourselves as much as I am. I shall not keep you long, I have called you all together for a purpose. Indeed, for three purposes! First of all, to tell you that I am immensely fond of you all, and that eleventy-one years is too short a time to live among such excellent and admirable Hobbits. I don't know half of you half as well as I should like; and I like less than half of you half as well as you deserve. Secondly, to celebrate my birthday. I should say: our birthday. For it is, of course, also the birthday of my heir and nephew, Frodo. He comes of age and into his inheritance today. Together we score one hundred and forty-four. Your numbers were chosen to fit this remarkable total: one gross, if I may use the expression. It is also, if I may be allowed to refer to ancient history, the anniversary of my arrival by barrel at Esgaroth on the Long Lake; thought the fact that it was my birthday slipped my memory on that occasion. I was fifty-one then, and birthdays did not seem so important. The banquet was very splendid, however, though I had a bad cold at the time, I remember, and could only say 'Thag you very buch'. I now repeat it more correctly: Thank you very much for coming to my little party. Thirdly and finally, I wish to make an ANNOUNCEMENT! I regret to announce that- though, as I said, eleventy-one years is far too short a time to spend among you, this is the END! I am going. I am leaving NOW! GOODBYE!";
    self.mySegmentedControl.selectedSegmentIndex = [self.englishVoices indexOfObject:@"en-IE"];
    [self bilboPitchAndRate];
}

// Increase pitch and speed for a child's voice
-(void)paikeaPitchAndRate
{
    self.pitchMultiplier = 1.2;
    self.speechRate = self.speechRateRange * 0.2;
}

-(void)savannahPitchAndRate
{
    self.pitchMultiplier = 1.5;
    self.speechRate = self.speechRateRange * 0.2;
}

// Set pitch and speed for an adult's voice
-(void)adultPitchAndRate
{
    self.pitchMultiplier = 1.0;
    self.speechRate = self.speechRateRange * 0.2;
}

-(void)lincolnPitchAndRate
{
    self.pitchMultiplier = 0.5;
    self.speechRate = self.speechRateRange * 0.15;
}

-(void)churchillPitchAndRate
{
    self.pitchMultiplier = 0.8;
    self.speechRate = self.speechRateRange * 0.15;
}

-(void)bilboPitchAndRate
{
    self.pitchMultiplier = 0.5;
    self.speechRate = self.speechRateRange * 0.3;
}
@end

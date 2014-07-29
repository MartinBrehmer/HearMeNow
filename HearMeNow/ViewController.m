//
//  ViewController.m
//  HearMeNow
//
//  Created by Mohamad Jalalzada on 29.07.14.
//  Copyright (c) 2014 Mohamad Jalalzada. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    BOOL hasRecording;
    AVAudioPlayer *soundPlayer;
    AVAudioRecorder *soundRecorder;
    AVAudioSession *session;
    NSString *soundPath;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    soundPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"hearmenow.wav"];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
    
    session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    NSError *error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    

    soundRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:&error];
    
    if (error) {
        NSLog(@"Error While initializiing the recorder: %@", error);
    
    }
    
    soundRecorder.delegate = self;
    [soundRecorder prepareToRecord];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    hasRecording = flag;
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPressed:(id)sender {
    
    if ([soundRecorder isRecording]) {
        
        [soundRecorder stop];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    else
    {
        [session requestRecordPermission:^(BOOL granted)
         {
             if (granted) {
                 [soundRecorder record];
                 [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
             }
             else {
                 NSLog(@"Unable to Record");
             }
         }];
    }
}

- (IBAction)playPressed:(id)sender {
    
    if (soundPlayer.playing) {
        
        [soundPlayer pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    else if (hasRecording)
    {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
        NSError *error;
        soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (!error) {
            soundPlayer.delegate = self;
            [soundPlayer play];
        }
        else{
            NSLog(@"Error initializing player:%@", error);
        }
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        hasRecording = NO;
    }
    else if (soundPlayer){
        [soundPlayer play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    
}
@end

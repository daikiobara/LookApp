//
//  SettingViewController.m
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/28.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//
#import "AVFoundation/AVFoundation.h"
#import "SettingViewController.h"

@interface SettingViewController ()



@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set values of sliders
    
    AVSpeechSynthesizer* speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    
    self.rateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate;
    self.rateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate;
    self.rateSlider.value = AVSpeechUtteranceDefaultSpeechRate;
    self.pitchSlider.minimumValue = 0.5;
    self.pitchSlider.maximumValue = 2.0;
    self.pitchSlider.value = 1.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

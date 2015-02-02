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
    
    [_rateSlider addTarget:self action:@selector(didValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_pitchSlider addTarget:self action:@selector(didValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)didValueChanged:( UISlider *)slider
{
    NSLog(@"%f", _rateSlider.value);
    NSLog(@"%f", _pitchSlider.value);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Return:(id)sender {
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    [settingDefaults setInteger:_rateSlider.value forKey:@"rate"];
    [settingDefaults setInteger:_pitchSlider.value forKey:@"pitch"];
    [settingDefaults synchronize];
    
}
@end

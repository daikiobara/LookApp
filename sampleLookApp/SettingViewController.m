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
    [self.scroller setScrollEnabled:YES ];
    [self.scroller setContentSize:CGSizeMake(320,460)];
    
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    self.rateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate;
    self.rateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate;
    self.rateSlider.value = [settingDefaults floatForKey:@"rate"];
    self.pitchSlider.minimumValue = 0.5;
    self.pitchSlider.maximumValue = 2.0;
    self.pitchSlider.value = [settingDefaults floatForKey:@"pitch"];
    
    [_rateSlider addTarget:self action:@selector(didValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_pitchSlider addTarget:self action:@selector(didValueChanged:) forControlEvents:UIControlEventValueChanged];

    // ステータスバーの部分の背景色を木目に。。。
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mokume.png"]];
    [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)didValueChanged:( UISlider *)slider
{
    
    NSLog(@"%f", _rateSlider.value);
    NSLog(@"%f", _pitchSlider.value);
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    [settingDefaults setFloat:_rateSlider.value forKey:@"rate"];
    [settingDefaults setFloat:_pitchSlider.value forKey:@"pitch"];
    [settingDefaults synchronize];
}

- (IBAction)Return:(id)sender {
    
}
@end

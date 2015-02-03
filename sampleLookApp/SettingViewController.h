//
//  SettingViewController.h
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/28.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UISlider *rateSlider;
@property (strong, nonatomic) IBOutlet UISlider *pitchSlider;
- (IBAction)Return:(id)sender;

@end

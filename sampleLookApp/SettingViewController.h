//
//  SettingViewController.h
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/28.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UISlider *pitchSlider;

- (IBAction)Return:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

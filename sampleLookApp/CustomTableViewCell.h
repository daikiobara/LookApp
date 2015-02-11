//
//  CustomTableViewCell.h
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/19.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CustomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SpeakerImg;
@property (weak, nonatomic) NSArray *sampleArray;

@end

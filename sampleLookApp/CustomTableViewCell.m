//
//  CustomTableViewCell.m
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/19.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setData:(NSString *)str {
//    self.CustomLabel.text = str;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ( touch.view.tag == self.SpeakerImg.tag )
        NSLog(@"speakerや");
       
    else if ( touch.view.tag == self.DictionaryImg.tag )
        NSLog(@"辞書や");
}






@end

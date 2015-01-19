//
//  ViewController.m
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/19.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"


@interface ViewController ()

@property (strong, nonatomic)NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.data = @[@"A", @"B", @"C"];
    
//    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
//    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // カスタムセルを取得
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                       forIndexPath:indexPath];
    
    // カスタムセルのラベルに値を設定
    [cell setData:self.data[indexPath.row]];
     cell.SpeakerImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"speaker1" ofType:@"png"]];
     cell.DictionaryImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Kensaku" ofType:@"png"]];
    
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch *touch = [touches anyObject];
//    NSLog( @"%ld",(long)touch.view.tag );
//    switch (touch.view.tag) {
//        case 1:
//            NSLog(@"音がでるよー");
//    
//            break;
//        case 2:
//            // 2のタグがタップされた場合の処理を記述
//            break;
//        case 3:
//            // 3のタグがタップされた場合の処理を記述
//            break;
//        default:
//            break;
//    }
//    
//}







@end

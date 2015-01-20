//
//  ViewController.h
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/19.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic)NSArray *searchResults;
@property (strong, nonatomic) UITextChecker *checker;

@end


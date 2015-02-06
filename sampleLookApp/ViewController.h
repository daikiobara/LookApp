//
//  ViewController.h
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/19.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashBoxItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *spacerItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic)NSArray *searchResults;
@property (strong, nonatomic) UITextChecker *textChecker;
@property (strong, nonatomic) NSMutableOrderedSet *history;
- (IBAction)Rubbish:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end


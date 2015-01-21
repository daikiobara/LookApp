
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
@property (strong, nonatomic) NSArray *matched;
@property (strong, nonatomic) NSArray *suggestions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResults = [[NSArray alloc] init];
    _SearchBar.delegate = self;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0: // matched
            return self.matched?1:0;
            break;
        case 1: // suggestions
            return [self.searchResults count];
            break;
        default:
            break;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // カスタムセルを取得
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                forIndexPath:indexPath];
    
    NSString *text;
    
    switch ([indexPath section]) {
        case 0: // match
            text = _matched;
            break;
        case 1:
            text = [self.searchResults objectAtIndex:[indexPath row]];
            break;
        default:
            text = @"Error";
            break;
    }
    
    // カスタムセルのラベルに値を設定
    //    [cell setData:self.data[indexPath.row]];
    cell.CustomLabel.text = text;
    cell.SpeakerImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"speaker1" ofType:@"png"]];
    cell.DictionaryImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search" ofType:@"png"]];
    
 
    [cell.SpeakerImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SpeakerImgTapped)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUnreadImage:)];
    [cell.DictionaryImg addGestureRecognizer:tap];

    
//     NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
    
    return cell;
}
-(void)tapUnreadImage:(UIGestureRecognizer *)gesture {
    NSString *word;
    
    // タップした位置（座標点）を取得します。
    CGPoint pos = [gesture locationInView:_tableView];
    // 座標点から、tableViewのメソッドを使って、NSIndexPathを取得します。
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:pos];
    // indexPathを使って、TableView上のタップされた画像を持つCellを取得します。
    
    switch ([indexPath section]) {
        case 0: // match
           NSLog(@"%@",_matched);
            word = _matched;
            break;
        case 1:
           NSLog(@"%@",_searchResults[indexPath.row]);
            word = _searchResults[indexPath.row];
            break;
        default:
            NSLog(@"error");
            break;
    }
     UIReferenceLibraryViewController *dictionary = [[UIReferenceLibraryViewController alloc] initWithTerm:word];
    [self presentViewController:dictionary animated:YES completion:nil];
    
}




- (void)SpeakerImgTapped {
    NSLog(@"ぐわーーーあああああ");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchtext
{
    if ([searchtext length]!=0) {
        // インクリメンタル検索など
        UITextChecker *_checker = [[UITextChecker alloc] init];
        _searchResults = [_checker guessesForWordRange:NSMakeRange(0, [searchtext length])
                                              inString:searchtext
                                              language:@"en_US"];
      //  NSLog(@"%@",_searchResults);
        
        BOOL isMatched = [UIReferenceLibraryViewController
                          dictionaryHasDefinitionForTerm:searchtext];
        if (isMatched) {
            self.matched = searchtext;
        } else {
            self.matched = nil;
        }
        [self.tableView reloadData];
    }
}



@end


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
    
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchtext
{
    NSLog(@"search text=%@", searchtext);
    if ([searchtext length]!=0) {
        // インクリメンタル検索など
        UITextChecker *_checker = [[UITextChecker alloc] init];
        _searchResults = [_checker guessesForWordRange:NSMakeRange(0, [searchtext length])
                                              inString:searchtext
                                              language:@"en_US"];
        NSLog(@"%@",_searchResults);
        
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

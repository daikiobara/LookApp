
//
//  ViewController.m
//  sampleLookApp
//
//  Created by Daiki  on 2015/01/19.
//  Copyright (c) 2015年 Daiz. All rights reserved.
//
#import "AVFoundation/AVFoundation.h"
#import "ViewController.h"
#import "CustomTableViewCell.h"


@interface ViewController ()

@property (strong, nonatomic)NSArray *data;
@property (strong, nonatomic) NSArray *matched;
@property (strong, nonatomic) NSArray *suggestions;
@property (strong, nonatomic) NSArray* history;


/* AVSpeechUtteranceのプロパティ*/
@property(nonatomic, retain) AVSpeechSynthesisVoice *voice;
@property(nonatomic, readonly) NSString *speechString; //再生テキスト
@property(nonatomic) float rate;             // はやさ
@property(nonatomic) float pitchMultiplier;  // 声のピッチ [0.5 - 2] Default = 1
@property(nonatomic) float volume;
@property(weak, nonatomic)NSString *ABC;

-(void)ManageHistoryByUserDefault;

@end

@implementation ViewController


static NSString* HistoryKey = @"History";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchBar.delegate = self;
     [self ManageHistoryByUserDefault];
    
}

-(void)ManageHistoryByUserDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    array = [[defaults arrayForKey:@"a"] mutableCopy];
    
    if(array == nil) {
        array = [NSMutableArray new];
    }
    
    [defaults setObject:array forKey:@"a"];
    
    NSArray *aaa= [defaults arrayForKey:@"a"];
    NSArray *ccc = [[aaa reverseObjectEnumerator] allObjects];
    self.history = [[NSMutableOrderedSet alloc] initWithArray:ccc];
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    switch (section) {
//        case 0: // matched
//            return self.matched?1:0;
//            break;
        case 0: // suggestions
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
//        case 0: // match
//            text = self.matched;
//            break;
        case 0:
            text = [self.searchResults objectAtIndex:[indexPath row]];
            break;
        default:
            text = @"Error";
            break;
    }
    
    
    // カスタムセルのラベルに値を設定
    cell.CustomLabel.text = text;
    cell.SpeakerImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"speaker1" ofType:@"png"]];
    UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappUnreadImage:)];
     [cell.SpeakerImg addGestureRecognizer:tapp];
    
    return cell;
}

-(void)tappUnreadImage:(UIGestureRecognizer *)gesture {
    NSString *word;
    
    // タップした位置（座標点）を取得します。
    CGPoint pos = [gesture locationInView:_tableView];
    // 座標点から、tableViewのメソッドを使って、NSIndexPathを取得します。
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:pos];
    // indexPathを使って、TableView上のタップされた画像を持つCellを取得します。
    
    switch ([indexPath section]) {
//        case 0: // match
//            NSLog(@"%@",self.SearchBar.text);
//            word = self.matched;
//            break;
        case 0:
            NSLog(@"%@",_searchResults[indexPath.row]);
            word = _searchResults[indexPath.row];
            break;
        default:
            NSLog(@"error");
            break;
    }
    
    AVSpeechSynthesizer* speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    NSString* speakingText = word;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speakingText];
    utterance.rate = 0.2;
    [speechSynthesizer speakUtterance:utterance];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchbar resignFirstResponder];
//    NSString *word = self.SearchBar.text;
//    [self.SearchBar resignFirstResponder];
//    UIReferenceLibraryViewController *dictionary = [[UIReferenceLibraryViewController alloc] initWithTerm:word];
//    [self presentViewController:dictionary animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    NSString* language = [[UITextChecker availableLanguages] objectAtIndex:0];
    if( !language ) language = @"en_US";
    
    NSArray *suggestionA = nil;
    NSArray *suggestionB = nil;
    
    if ([searchText length]!=0) {
        // インクリメンタル検索など
        UITextChecker *_checker = [[UITextChecker alloc] init];
        suggestionA = [_checker guessesForWordRange:NSMakeRange(0, [searchText length])
                                              inString:searchText
                                              language:language];
        suggestionB = [_checker completionsForPartialWordRange:NSMakeRange(0, searchText.length)
                                            inString:searchText language:language];
        
        
        NSLog(@"%@@", suggestionA);
        
       NSArray *prepareArray = [suggestionA arrayByAddingObjectsFromArray:suggestionB];
        
        self.searchResults = [[prepareArray reverseObjectEnumerator] allObjects];
        NSLog(@"%@", self.searchResults);
        
        
//        
//        BOOL isMatched = [UIReferenceLibraryViewController
//                          dictionaryHasDefinitionForTerm:searchText];
//        if (isMatched) {
//            self.matched = searchText;
//        } else {
//            self.matched = nil;
//        }
  [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *word;
    switch ([indexPath section]) {
//        case 0: // match
//            word = self.matched;
//            break;
        case 0:
            word = _searchResults[indexPath.row];
            break;
        default:
            NSLog(@"error");
            break;
    }
    UIReferenceLibraryViewController *dictionary = [[UIReferenceLibraryViewController alloc] initWithTerm:word];
    [self presentViewController:dictionary animated:YES completion:nil];
}






@end

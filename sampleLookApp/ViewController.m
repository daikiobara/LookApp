
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
@property (strong, nonatomic) NSString *matched;
@property (strong, nonatomic) NSArray *suggestions;
@property (strong, nonatomic) NSArray *suggestionsA;
@property (strong, nonatomic) NSArray *suggestionsB;
@property (strong, nonatomic) NSArray *prepareArray;
@property (strong, nonatomic) NSString *language;


/* AVSpeechUtteranceのプロパティ*/
//@property(nonatomic, retain) AVSpeechSynthesisVoice *voice;
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
    self.SearchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    self.SearchBar.spellCheckingType = UITextSpellCheckingTypeYes;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        switch (section) {
            case 0: // matched
                return self.matched?1:0;
                break;
            case 1: // suggestions
            if (self.searchResults != nil) {
                return [self.searchResults count];
                break;
            }else{
                return [self.history count];
                break;
            }
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
        case 0: // matched
             if (self.matched) {
             text = self.matched;
             break;
             }
             
        case 1:
             if (self.searchResults != nil) {
            text = [self.searchResults objectAtIndex:[indexPath row]];
            break;
             }else{
          NSLog(@"%@",[self.history objectAtIndex:[indexPath row]]);
                 NSDictionary *htry = [self.history objectAtIndex:[indexPath row]];
                 NSLog(@"%@",htry);
                 text = [htry objectForKey:@"text"];
                 NSLog(@"%@",text);
            break;
             }
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

-(void)viewWillAppear:(BOOL)animated
{
    self.searchResults = nil;
    self.matched = nil;
    [self.tableView reloadData];
    
    NSLog(@"こんにゃろーーー");
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchResults = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}


-(void)tappUnreadImage:(UIGestureRecognizer *)gesture {
    NSString *word;
    
    // タップした位置（座標点）を取得します。
    CGPoint pos = [gesture locationInView:_tableView];
    // 座標点から、tableViewのメソッドを使って、NSIndexPathを取得します。
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:pos];
    // indexPathを使って、TableView上のタップされた画像を持つCellを取得します。
    
    switch ([indexPath section]) {
        case 0:
            if (self.matched) {
                word = _matched;
                break;
            }
        case 1:
            if (self.searchResults != nil) {
            word = _searchResults[indexPath.row];
            break;
            }else{
                NSLog(@"%@",[self.history objectAtIndex:[indexPath row]]);
                NSDictionary *htry = [self.history objectAtIndex:[indexPath row]];
                NSLog(@"%@",htry);
                word= [htry objectForKey:@"text"];
                NSLog(@"%@",word);
                self.language = [htry objectForKey:@"lang"];
            break;
            }
        default:
            NSLog(@"error");
            break;
    }
    
    AVSpeechSynthesizer* speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    NSString* speakingText = word;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speakingText];
    utterance.rate = 0.2;
    AVSpeechSynthesisVoice* Voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.language];
    NSLog(@"%@", Voice);
    
    // voiceをAVSpeechUtteranceに指定。
    utterance.voice =  Voice;
    [speechSynthesizer speakUtterance:utterance];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchbar resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
 if( !_language ) _language = @"en_US";
    
    //並列処理
    dispatch_async(globalQueue, ^{
        
        if ([searchText length]!=0) {
            // インクリメンタル検索など
            UITextChecker *_checker = [[UITextChecker alloc] init];
            self.suggestionsA = [_checker guessesForWordRange:NSMakeRange(0, [searchText length])
                                               inString:searchText
                                               language:_language];
            self.suggestionsB = [_checker completionsForPartialWordRange:NSMakeRange(0, searchText.length)
                                                          inString:searchText language:_language];
            self.prepareArray = [self.suggestionsA arrayByAddingObjectsFromArray:self.suggestionsB];
            
            self.searchResults = [[self.prepareArray reverseObjectEnumerator] allObjects];
            
            BOOL isMatched = [UIReferenceLibraryViewController
                              dictionaryHasDefinitionForTerm:searchText];
            
            UITextInputMode *textInput = [UITextInputMode currentInputMode];
            NSLog(@"%@",self.language);
            
            dispatch_async(mainQueue, ^{
                self.searchResults = [[self.prepareArray reverseObjectEnumerator] allObjects];
                NSString *primaryLanguage = textInput.primaryLanguage;
                NSLog(@"Current text input is: %@", primaryLanguage);
                self.language = primaryLanguage;
    
                if (isMatched) {
                    self.matched = searchText;
                } else {
                    self.matched = nil;
                }
                [self.tableView reloadData];
            });
        }
        
    });
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *word;
    switch ([indexPath section]) {
        case 0: // match
            word = self.matched;
            break;
        case 1:
            if (self.searchResults != nil) {
            word = _searchResults[indexPath.row];
            break;
            }else{
                NSDictionary *htry = [self.history objectAtIndex:[indexPath row]];
                word = [htry objectForKey:@"text"];
                self.language = [htry objectForKey:@"lang"];
            }
        default:
            NSLog(@"errorf");
            break;
    }
    
    UIReferenceLibraryViewController *dictionary = [[UIReferenceLibraryViewController alloc] initWithTerm:word];
    NSDictionary　*historyList = [NSDictionary dictionaryWithObjectsAndKeys:word,@"text",_language,@"lang", nil];
    NSLog(@"このやろー");
    
    NSLog(@"%@", historyList);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    array = [[defaults arrayForKey:@"a"] mutableCopy];
    
    if(array == nil) {
        array = [NSMutableArray new];
    }
    
    [array addObject: historyList];
    [defaults setObject:array forKey:@"a"];
    [defaults synchronize];
    
    NSArray *aaa= [defaults arrayForKey:@"a"];
    NSArray *ccc = [[aaa reverseObjectEnumerator] allObjects];
    self.history = [[NSMutableOrderedSet alloc] initWithArray:ccc];

    [self presentViewController:dictionary animated:YES completion:nil];
}



@end

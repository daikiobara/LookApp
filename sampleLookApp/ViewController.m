
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
#import "SettingViewController.h"

@interface ViewController ()

@property (strong, nonatomic)NSArray *data;
@property (strong, nonatomic) NSString *matched;
@property (strong, nonatomic) NSArray *suggestions;
@property (strong, nonatomic) NSArray *suggestionsA;
@property (strong, nonatomic) NSArray *suggestionsB;
@property (strong, nonatomic) NSArray *prepareArray;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSDictionary *historyList;



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
    
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat windowWitdh = frame.size.width;
    if (windowWitdh <= 320) {
        self.spacerItem.width = 200.0f;
    } else {
        self.spacerItem.width = 250.0f;
    }
    
    self.SearchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    self.SearchBar.spellCheckingType = UITextSpellCheckingTypeYes;
    self.SearchBar.delegate = self;
    [self ManageHistoryByUserDefault];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    
    self.rate = [settingDefaults floatForKey:@"rate"];
    self.pitchMultiplier = [settingDefaults floatForKey:@"pitch"];
    
    NSLog(@"%f",_rate);
    // NSLog(@"%f",_pitchMultiplier);
    
    self.searchResults = nil;
    self.matched = nil;
    //[self.tableView reloadData];
}

-(void)ManageHistoryByUserDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    array = [[defaults arrayForKey:@"history"] mutableCopy];
    
    if(array == nil) {
        array = [NSMutableArray new];
    }
    
    [defaults setObject:array forKey:@"history"];
    NSArray *history= [defaults arrayForKey:@"history"];
    NSArray *reversedHistory = [[history reverseObjectEnumerator] allObjects];
    self.history = [[NSMutableOrderedSet alloc] initWithArray:reversedHistory];
    
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
                 NSDictionary *htry = [self.history objectAtIndex:[indexPath row]];
                 text = [htry objectForKey:@"text"];
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
                NSDictionary *htry = [self.history objectAtIndex:[indexPath row]];
                word= [htry objectForKey:@"text"];
                self.language = [htry objectForKey:@"lang"];
                break;
            }
        default:
            NSLog(@"error");
            break;
    }
    
   // NSInteger *rate = [SettingViewController rateSlider];
    AVSpeechSynthesizer* speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    NSString* speakingText = word;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speakingText];
    utterance.rate = self.rate;
    utterance.pitchMultiplier = self.pitchMultiplier;
    AVSpeechSynthesisVoice* Voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.language];
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
//    
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    if( !_language ) _language = @"en_US";
        //並列処理
//        dispatch_async(globalQueue, ^{
    
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
            
//                BOOL isMatched = [UIReferenceLibraryViewController
//                              dictionaryHasDefinitionForTerm:searchText];
            
                UITextInputMode *textInput = [UITextInputMode currentInputMode];
                NSLog(@"%@",self.language);
            
//                dispatch_async(mainQueue, ^{
                    self.searchResults = [[self.prepareArray reverseObjectEnumerator] allObjects];
                    NSString *primaryLanguage = textInput.primaryLanguage;
                    self.language = primaryLanguage;
                
                    self.matched = searchText;
    
//                    if (isMatched) {
//                        self.matched = searchText;
//                    } else {
//                        self.matched = nil;
//                    }
                    [self.tableView reloadData];
//                });
            }
//        });
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *word;
    //    switch ([indexPath section]) {
    //        case 0: // match
    //            word = self.matched;
    //            break;
    //        case 1:
    //            if (self.searchResults != nil) {
    //                word = _searchResults[indexPath.row];
    //                break;
    //            }else{
    //                NSDictionary *htry = [self.history objectAtIndex:[indexPath row]];
    //                word = [htry objectForKey:@"text"];
    //                self.language = [htry objectForKey:@"lang"];
    //            }
    //        default:
    //            NSLog(@"errorf");
    //            break;
    //    }
    
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
    
    //    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //     dispatch_async(globalQueue, ^{
    
    BOOL hasDefinition = [UIReferenceLibraryViewController
                          dictionaryHasDefinitionForTerm:word];
    if (hasDefinition) {
        self.historyList = [NSDictionary dictionaryWithObjectsAndKeys:word,@"text",_language,@"lang", nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [NSMutableArray array];
        array = [[defaults arrayForKey:@"history"] mutableCopy];
        
        if(array == nil) {
            array = [NSMutableArray new];
        }
        
        [array addObject: self.historyList];
        [defaults setObject:array forKey:@"history"];
        [defaults synchronize];
        
        NSArray *aaa = [defaults arrayForKey:@"history"];
        NSArray *ccc = [[aaa reverseObjectEnumerator] allObjects];
        self.history = [[NSMutableOrderedSet alloc] initWithArray:ccc];
        
    }
    //         dispatch_async(mainQueue, ^{
    
    UIReferenceLibraryViewController *dictionary = [[UIReferenceLibraryViewController alloc] initWithTerm:word];
    //  self.historyList = [NSDictionary dictionaryWithObjectsAndKeys:word,@"text",_language,@"lang", nil];
    [self presentViewController:dictionary animated:YES completion:nil];
    //             });
    //         });
    //
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSMutableArray *array = [NSMutableArray array];
    //    array = [[defaults arrayForKey:@"a"] mutableCopy];
    //
    //    if(array == nil) {
    //        array = [NSMutableArray new];
    //    }
    //
    //    [array addObject: self.historyList];
    //    [defaults setObject:array forKey:@"a"];
    //    [defaults synchronize];
    //
    //    NSArray *aaa= [defaults arrayForKey:@"a"];
    //    NSArray *ccc = [[aaa reverseObjectEnumerator] allObjects];
    //    self.history = [[NSMutableOrderedSet alloc] initWithArray:ccc];
    
    //    [self presentViewController:dictionary animated:YES completion:nil];
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *history = [NSMutableArray array];
         history = [[defaults arrayForKey:@"history"] mutableCopy];
        
        NSMutableArray *reverseHistory = [[history reverseObjectEnumerator] allObjects];
        
        [reverseHistory removeObjectAtIndex:indexPath.row];
        NSMutableArray *array =[[reverseHistory reverseObjectEnumerator] allObjects];
        
        [defaults setObject:array forKey:@"history"];
        [defaults synchronize];
        
        [self.history removeObjectAtIndex:indexPath.row];
        // 削除ボタンが押された行のデータを配列から削除します。
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)Rubbish:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 削除
    [defaults removeObjectForKey:@"history"];
    [defaults synchronize];
    [self.tableView reloadData];
    
}
@end

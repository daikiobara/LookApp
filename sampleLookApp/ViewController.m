
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
@property(strong, nonatomic) UIActivityIndicatorView *indicator;
@property(nonatomic) UIImage *NavImage;




-(void)ManageHistoryByUserDefault;
-(void)setIndicator;


@end

@implementation ViewController


static NSString* HistoryKey = @"History";

- (BOOL)shouldAutorotate
{
    
    float w = _indicator.frame.size.width;
    float h = _indicator.frame.size.height;
    float x = self.view.frame.size.width/2 - w/2;
    float y = self.view.frame.size.height/2 - h/2;
    _indicator.frame = CGRectMake(x, y, w, h);
    _indicator.color = [UIColor redColor];
    
        CGRect rect2 = [[UIScreen mainScreen] applicationFrame];
//    NSLog(@"====================");
//    NSLog(@"%f", rect2.size.width);
//    NSLog(@"====================");
        self.spacerItem.width = rect2.size.width - 70;
    
    // 回転する場合YES, しない場合NO
    if ([[UIDevice currentDevice].model isEqual: @"iPad"]) {
        return YES;
    }
    return NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UINavigationBar appearance].tintColor = [UIColor colorWithRed:0.3254901960784314 green:0.0784313725490196 blue:0.0784313725490196 alpha:1.0];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.3254901960784314 green:0.0784313725490196 blue:0.0784313725490196 alpha:1.0]};
    [UIToolbar appearance].tintColor =  [UIColor colorWithRed:0.3254901960784314 green:0.0784313725490196 blue:0.0784313725490196 alpha:1.0];
    
    self.NavImage = [UIImage imageNamed:@"mokume.png"];
    UIImage *ToolImage = [UIImage imageNamed:@"mokume.png"];
    self.SearchBar.backgroundImage = _NavImage;
    
   // [[self.SearchBar appearance] setBackgroundImage:_NavImage];
    [[UINavigationBar appearance ]setBackgroundImage:_NavImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:ToolImage
                                       forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];

    
    self.SearchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    self.SearchBar.spellCheckingType = UITextSpellCheckingTypeYes;
    self.SearchBar.delegate = self;
    [self ManageHistoryByUserDefault];
    CGRect rect2 = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"rect2.size.width : %f , rect2.size.height : %f", rect2.size.width, rect2.size.height);
    NSLog(@"%f",rect2.size.width);
//    UIBarButtonItem * fixedSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil ];
//    fixedSpacer.width = 30;
    
    self.spacerItem.width = rect2.size.width - 70;
    self.settingBtnItem.width = 10;
    self.trashBoxItem.width = 10;
    
}

//- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
//{
//    
//    return UIBarPositionTopAttached;
//}

-(void)setIndicator
{
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    float w = _indicator.frame.size.width;
    float h = _indicator.frame.size.height;
    float x = self.view.frame.size.width/2 - w/2;
    float y = self.view.frame.size.height/2 - h/2;
    _indicator.frame = CGRectMake(x, y, w, h);
    _indicator.color = [UIColor redColor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setIndicator];
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    self.rate = [settingDefaults floatForKey:@"rate"];
    self.pitchMultiplier = [settingDefaults floatForKey:@"pitch"];
    self.searchResults = nil;
    self.matched = nil;
    
    [self.tableView reloadData];
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
    cell.SpeakerImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Speaker" ofType:@"png"]];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    self.matched = nil;
    self.searchResults = nil;
    [self.tableView reloadData];
    searchBar.text = @"";
    [_SearchBar resignFirstResponder];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if( !_language ) _language = @"en_US";
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
            
            UITextInputMode *textInput = [UITextInputMode currentInputMode];
            
            self.searchResults = [[self.prepareArray reverseObjectEnumerator] allObjects];
            NSString *primaryLanguage = textInput.primaryLanguage;
            self.language = primaryLanguage;
            self.matched = searchText;
            [self.tableView reloadData];
        }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_SearchBar resignFirstResponder];
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    _indicator.hidesWhenStopped = YES;
    
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
    
    UIReferenceLibraryViewController *dictionary = [[UIReferenceLibraryViewController alloc] initWithTerm:word];
    [self presentViewController:dictionary animated:YES completion:^(void){[_indicator stopAnimating];}];
    
  
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
    
    if (self.history.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"Delete";
        alert.delegate = self;
        [alert addButtonWithTitle:@"Cancele"];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        
    }
    
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
            if (self.history) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"history"];
                [defaults synchronize];
                [self.history removeAllObjects];
                [self.tableView reloadData];
            }
            
            break;
    }
    
}

- (IBAction)tapppp:(UIGestureRecognizer *)gesture {
    
    
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
@end

//
//  ViewController.m
//  LangSample
//
//  Created by Infostretch on 19/02/15.
//  Copyright (c) 2015 Infostretch. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import <DropboxSDK/DropboxSDK.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextView *resultTxtView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  if (![[DBManager getSharedInstance] createDB]) {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Failed to create DB" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)addBtnClicked:(id)sender {
  NSString * name = self.nameTxtField.text;
  if (name && [name length] > 0) {
    [[DBManager getSharedInstance] saveData:self.nameTxtField.text];
    self.nameTxtField.text = @"";
  }
}

- (IBAction)getBtnClicked:(id)sender {
  NSArray * names = [[DBManager getSharedInstance] getData];
  if(names && [names count] > 0) {
    self.resultTxtView.text = [names componentsJoinedByString:@"\n"];
  }
}

- (IBAction)saveToDbxBtnClicked:(id)sender {
  if (![[DBSession sharedSession] isLinked]) {
    [[DBSession sharedSession] linkFromController:self];
  }
}


@end

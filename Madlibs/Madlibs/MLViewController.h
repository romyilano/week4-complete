//
//  MLViewController.h
//  Madlibs
//
//  Created by Michele Titolo on 2/7/13.
//  Copyright (c) 2013 Michele Titolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (strong, nonatomic) NSArray* poemLines;

- (IBAction)goPressed:(id)sender;




@end

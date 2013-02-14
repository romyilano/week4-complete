//
//  MLViewController.m
//  Madlibs
//
//  Created by Michele Titolo on 2/7/13.
//  Copyright (c) 2013 Michele Titolo. All rights reserved.
//

#import "MLViewController.h"
#import "MLPoemViewController.h"
// use NSNotificationCenter and UIKeyBoard...did move etc.
// doing the textfields with the scrollview is always a PITA
// http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
#define kOFFSET_FOR_KEYBOARD 80.0

@interface MLViewController ()
    // current content scroll view position
    // and frame
    
@end

@implementation MLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.poemLines = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"madlibs" ofType:@"plist"]];
    
    NSArray* textFields = [NSArray arrayWithObjects:self.textField1, self.textField2, self.textField3, self.textField4, nil];
    
    
    // get notified when the keyboard is shown
    // when it's shown then you throw a method in there.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWasShown:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    //subscribe for UIKeyboardWillHideNotification
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(keyboardHidden:)
    name:UIKeyboardWillHideNotification
    object:nil];
    
    
    
    [self.poemLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* lineInfo = (NSDictionary*)obj;
        
        UITextField* textField = [textFields objectAtIndex:idx];
        
        textField.placeholder = [lineInfo objectForKey:@"type"];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPressed:(id)sender
{
    NSMutableString* poemString = [NSMutableString string];
    
    NSArray* textFields = [NSArray arrayWithObjects:self.textField1, self.textField2, self.textField3, self.textField4, nil];
    
    [self.poemLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* lineInfo = (NSDictionary*)obj;
        
        UITextField* textField = [textFields objectAtIndex:idx];
        
        [poemString appendFormat:[lineInfo objectForKey:@"phrase"], textField.text];
        
        if (idx < (textFields.count - 1)) {
            [poemString appendString:@"\n"];
        }
        
    }];
    
    MLPoemViewController* poemVC = [[MLPoemViewController alloc] initWithNibName:@"MLPoemViewController" bundle:nil];
    
    poemVC.poem = poemString;
    
    [self.navigationController pushViewController:poemVC animated:YES];
    
}

#pragma mark-keyboard methods
-(void)keyboardWasShown:(NSNotification *)aNotification
{
    
    NSLog(@"The keyboard was shown");
    /*
    NSDictionary *info = [aNotification userInfo];
    // get the keyboard size
    // need to ge tthe keyboard's height but we can only do it if we get the width first
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGSize kbSize = kbRect.size;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat sWidth = screenRect.size.width;
    CGFloat sHeight = screenRect.size.height;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ((orientation == UIDeviceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown)) {
        CGFloat kbHeight = kbSize.height;
        CGFloat kbTop = sHeight - kbHeight;
    }
    else
    {
        // notice that the keyboard size not oriented
        // so use width property instead
        CGFloat kbHeight = kbSize.width;
        CGFloat kbTop = sWidth - kbHeight;
    }
     (
     */
    
    
}

-(void)keyboardHidden:(NSNotification *)aNotification
{
    NSLog(@"The keyboard was hidden");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textField4) {
        
        [textField resignFirstResponder];
        [self goPressed:nil];
        
    }
    else if (textField == self.textField1)
    {
        [self.textField2 becomeFirstResponder];
    }
    else if (textField == self.textField2)
    {
        [self.textField3 becomeFirstResponder];
    }
    else if (textField == self.textField3)
    {
        [self.textField4 becomeFirstResponder];
    }
    
    
    return YES;
}

@end

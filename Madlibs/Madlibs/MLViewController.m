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
#define SCROLLVIEW_HEIGHT       460
#define     SCROLLVIEW_WIDTH    320

#define SCROLLVIEW_CONTENT_HEIGHT   720
#define SCROLLVIEW_CONTENT_WIDTH    320

@interface MLViewController ()
{
    BOOL keyboardVisible;
    CGPoint offset;
    
    UITextField *currentTextField;

}
-(void)keyboardWasShown:(NSNotification *)aNotification;
-(void)keyboardDidHide:(NSNotification *)aNotification;
@end

@implementation MLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.poemLines = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"madlibs" ofType:@"plist"]];
    
    NSArray* textFields = [NSArray arrayWithObjects:self.textField1, self.textField2, self.textField3, self.textField4, nil];
    
    
    // specify the frame size for the scrollview
    self.scrollView.frame = CGRectMake(0, 0, 320, 460);
    [[self scrollView] setContentSize:CGSizeMake(320, 1040)];
    
    
    [self.poemLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* lineInfo = (NSDictionary*)obj;
        
        UITextField* textField = [textFields objectAtIndex:idx];
        
        textField.placeholder = [lineInfo objectForKey:@"type"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // -- remove the notifications for the keyboard --
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPressed:(id)sender {
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
-(void)keyboardWasShown:(NSNotification *)aNotification {
    
    // the keyboard is already visible so we are going to jump out of this method
    if(keyboardVisible) return;
    
    NSDictionary *info = [aNotification userInfo];
    
    // -- obtain the size of the keyboard --
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    NSLog(@"%f", keyboardRect.size.height);
    
    //= resize the scrollview (with the keyboard)--
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    self.scrollView.frame = viewFrame;
    
    // -- scroll to the current text field
    CGRect textFieldRect = [currentTextField frame];
    
    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];
    
    keyboardVisible=YES;
    
}

-(void)keyboardDidHide:(NSNotification *)aNotification
{
    
    if(!keyboardVisible)
    {
        NSLog(@"the keyboard is already hidden. ignoring notaification");
        return;
    }
    
    NSDictionary *info = [aNotification userInfo];
    // obtaint he size of the keyboard
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [[self view] convertRect:[aValue CGRectValue] fromView:nil];
    
    // -- resize the scroll view back to the original size
    // without the keyboard
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    self.scrollView.frame = viewFrame;
    
    keyboardVisible=NO;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField=nil;
}
@end

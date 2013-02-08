//
//  MLViewController.m
//  Madlibs
//
//  Created by Michele Titolo on 2/7/13.
//  Copyright (c) 2013 Michele Titolo. All rights reserved.
//

#import "MLViewController.h"
#import "MLPoemViewController.h"

@interface MLViewController ()

@end

@implementation MLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.poemLines = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"madlibs" ofType:@"plist"]];
    
    NSArray* textFields = [NSArray arrayWithObjects:self.textField1, self.textField2, self.textField3, self.textField4, nil];
    
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

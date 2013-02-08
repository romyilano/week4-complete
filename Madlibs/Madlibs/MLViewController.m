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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPressed:(id)sender
{
    MLPoemViewController* poemVC = [[MLPoemViewController alloc] initWithNibName:@"MLPoemViewController" bundle:nil];
    
    [self.navigationController pushViewController:poemVC animated:YES];
    
}

@end

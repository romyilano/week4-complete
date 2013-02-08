//
//  MLPoemViewController.h
//  Madlibs
//
//  Created by Michele Titolo on 2/7/13.
//  Copyright (c) 2013 Michele Titolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLPoemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *poemLabel;

@property (strong, nonatomic) NSString* poem;

@end

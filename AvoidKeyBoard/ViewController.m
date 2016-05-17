//
//  ViewController.m
//  AvoidKeyBoard
//
//  Created by Kumar on 18/05/16.
//  Copyright © 2016 Kumar. All rights reserved.
//

#import "ViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface ViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *myscrollView;
@property (strong, nonatomic) IBOutlet UIView *contenerview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [_myTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_myTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:_myTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField*)sender
{
    if ([sender isEqual:_myTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_myTextField resignFirstResponder];
    return YES;
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.contenerview.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.contenerview.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.contenerview.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.contenerview.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
@end

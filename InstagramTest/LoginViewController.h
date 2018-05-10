//
//  LoginViewController.h
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/22.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *PasswordLogin;

- (IBAction)ButtonSignup:(id)sender;
- (IBAction)LoginButton:(id)sender;

@end

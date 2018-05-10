//
//  RegisterViewController.h
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/22.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *Imagebutton;
- (IBAction)Imagebutton:(id)sender;
- (IBAction)SignupButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *UsernameField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;

@end

//
//  LoginViewController.m
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/22.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>


@interface LoginViewController ()
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
   
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ButtonSignup:(id)sender {
    
    RegisterViewController *ViewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:ViewController animated:YES];
    
}

- (IBAction)LoginButton:(id)sender {
    
    [[FIRAuth auth] signInWithEmail:self.emailLogin.text
                           password:self.PasswordLogin.text
                         completion:^(FIRUser *user, NSError *error) {
                             
                             
                             if (!error) {
                                 
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 NSLog(@"Login");
                             }else{
                                 NSLog(@"Login Error:%@",error);
                             }
                             
                            
                             
                         }];

    
}
@end

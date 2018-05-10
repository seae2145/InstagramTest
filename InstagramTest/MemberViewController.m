//
//  MemberViewController.m
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/26.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import "MemberViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>

@interface MemberViewController ()
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)Logout:(id)sender {
    
    
    //Firebase登出
    NSError *error;
    [[FIRAuth auth]signOut:&error];
    
    if (!error) {
    

        UIViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNV"];
    
        [self presentViewController:ViewController animated:YES completion:nil];
        
        //回到顯示tabBar第一頁
        [self.tabBarController setSelectedIndex:0];
        
    
    }

    
}
@end

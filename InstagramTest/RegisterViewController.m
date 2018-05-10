//
//  RegisterViewController.m
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/22.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import "RegisterViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>


@interface RegisterViewController ()

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:255/255.0f green:222/255.0f blue:173/255.0f alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253/255.0f green:245/255.0f blue:230/255.0f alpha:1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Imagebutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.Imagebutton.imageView.clipsToBounds = YES;
    self.Imagebutton.frame = CGRectMake(130, 100, 120, 120);
    self.Imagebutton.layer.cornerRadius = self.Imagebutton.frame.size.height/8;
    self.Imagebutton.layer.masksToBounds = YES;
    self.Imagebutton.layer.borderWidth = 0;
    
    NSLog(@"width:%f",self.view.frame.size.width/2);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Imagebutton:(id)sender {
    
    //圖片挑選畫面
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate  = self;
    
   
    // bring up the picker
    [self presentViewController:picker animated:YES completion:nil];
    
    
    NSLog(@"imageButton");
    
}



//選完照片動作
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *UserImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.Imagebutton setImage:UserImage forState:UIControlStateNormal];
    
    NSLog(@"image size:%f",UserImage.size.width);
    
    
    //修改圖片像素大小
    CGSize newSize;
    if (UserImage.size.width > 4000) {
        newSize = CGSizeMake(1334.0f, 1000.0f);
    }else{
        newSize = CGSizeMake(1000.0f, 1334.0f);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [UserImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    //UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    ///////////////////
    
    
    [self dismissViewControllerAnimated:YES completion:nil];


}



- (IBAction)SignupButton:(id)sender {

    
    [[FIRAuth auth] createUserWithEmail:self.emailField.text
                               password:self.PasswordField.text
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 
                                 [self.navigationController popViewControllerAnimated:YES];
                                 NSLog(@"Sign up");
                                 
                             }];
  
}



@end

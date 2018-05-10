//
//  NewPostViewController.h
//  InstagramTest
//
//  Created by 張揚法 on 2018/4/24.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,UITextViewDelegate>
{
    NSUserDefaults *UserAccountUUID;
    UIImage *UserImage;
    NSTimer *timer;
    NSString *buttoncount;
}
@property (weak, nonatomic) IBOutlet UITextView *NewTextView;
@property (weak, nonatomic) IBOutlet UINavigationBar *PostNavigationBar;
@property (weak, nonatomic) IBOutlet UIButton *PickButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *PostActivity;
- (IBAction)PickButtonAction:(id)sender;
- (IBAction)CancelButton:(id)sender;

- (IBAction)PostButton:(id)sender;
@end

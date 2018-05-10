//
//  NewPostViewController.m
//  InstagramTest
//
//  Created by 張揚法 on 2018/4/24.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import "NewPostViewController.h"
#import <FirebaseStorage/FirebaseStorage.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface NewPostViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation NewPostViewController



-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSLog(@"imageButton");
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.NewTextView.delegate = self;
    self.NewTextView.text = @"請在這邊輸入...";
    self.NewTextView.textColor = [UIColor lightGrayColor]; //optional

    self.NewTextView.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    self.PostNavigationBar.hidden = YES;
    self.PickButton.hidden = YES;
    
    self.PostActivity.hidden = NO;
    [self.PostActivity startAnimating];
    
    UserAccountUUID = [NSUserDefaults standardUserDefaults];
    
    //監聽廣播端
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewPost:) name:@"NewPost" object:nil];
    
    
    self.ref = [[FIRDatabase database] reference];
    
    //圖片挑選畫面
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    
    // bring up the picker
    [self presentViewController:picker animated:YES completion:nil];
    
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"請在這邊輸入..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"請在這邊輸入...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

//reload方法
-(void)NewPost:(NSNotification *)notification{
    
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//選取圖片Cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    self.PostActivity.hidden = YES;
    [self.PostActivity stopAnimating];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.tabBar.hidden = NO;
    self.PostNavigationBar.hidden = NO;
    self.PickButton.hidden = NO;
    self.NewTextView.hidden = NO;
    
    self.PostActivity.hidden = YES;
    [self.PostActivity stopAnimating];
    
    NSLog(@"buttoncount : %@",buttoncount);
    
    if ([buttoncount isEqualToString:@"1"]) {
        
        self.tabBarController.tabBar.hidden = YES;
        
    }else{
        
        //回到顯示tabBar第一頁
        [self.tabBarController setSelectedIndex:0];
        
    }
    
    
}

//選完照片動作
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UserImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.PickButton setImage:UserImage forState:UIControlStateNormal];
    self.PickButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.PickButton.imageView.clipsToBounds = YES;
    
    self.PostActivity.hidden = YES;
    [self.PostActivity stopAnimating];
    
    self.PostNavigationBar.hidden = NO;
    self.PickButton.hidden = NO;
    self.NewTextView.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}



- (IBAction)PickButtonAction:(id)sender {
    
    //圖片挑選畫面
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    buttoncount = @"1";
    
    // bring up the picker
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (IBAction)CancelButton:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    self.PostNavigationBar.hidden = NO;
    self.PickButton.hidden = NO;
    self.NewTextView.hidden = NO;
    
    //回到顯示tabBar第一頁
    [self.tabBarController setSelectedIndex:0];
        
    
   
}

- (IBAction)PostButton:(id)sender {
    
    NSLog(@"Post ! ");
    
    
    NSData *imageData = UIImageJPEGRepresentation(UserImage, 0.8);
    
    FIRStorage *storage = [FIRStorage storage];
    // Create a root reference
    FIRStorageReference *storageRef = [storage reference];
    
    

    
    //使用者UUID
    NSString *UserUUID = [UserAccountUUID objectForKey:@"UserAccountUUID"];
    
    //利用childByAuto製造id 排順序
    NSString *key = [[_ref child:UserUUID] childByAutoId].key;

    
    NSLog(@"UserUUID : %@",key);
    
    
    //隨機取得UUID
    //NSString *imageID = [[NSUUID UUID] UUIDString];
    //檔名
    NSString *imageName = [NSString stringWithFormat:@"%@/%@.jpg",UserUUID,key];
    
    FIRStorageReference *spaceRef = [storageRef child:imageName];
    
    //儲存路徑
    NSString *imageURL = [NSString stringWithFormat:@"gs://database-demo-32ea7.appspot.com/%@",imageName];
    
    // This is equivalent to creating the full reference
    spaceRef = [storage referenceForURL:imageURL];
    
    //照片資料
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    //檔案類型
    metadata.contentType = @"image/png";
    // Upload the file to the path "images/rivers.jpg"
    
    //上傳圖片
    FIRStorageUploadTask *uploadTask = [spaceRef putData:imageData
                                                metadata:metadata
                                              completion:^(FIRStorageMetadata *metadata,
                                                           NSError *error) {
                                                  if (error != nil) {
                                                      // Uh-oh, an error occurred!
                                                      NSLog(@"error:%@",error);

                                                  } else {
                                                      // Metadata contains file metadata such as size, content-type, and download URL.

                                                      //取得圖片的URL
                                                      NSURL *downloadURL = metadata.downloadURL;
                                                      NSString *downloadURLStr = downloadURL.absoluteString;
                                                      NSLog(@"downloadURL : %@",downloadURL);

                                                      //寫入資料
                                                      //[[[[_ref child:@"UsersPic"] child:UserUUID] child:imageID] setValue:downloadURLStr];


                                                      [[[[[_ref child:@"UserPic"] child:UserUUID] child:key] child:@"imageURL"] setValue:downloadURLStr];
                                                      [[[[[_ref child:@"UserPic"] child:UserUUID] child:key] child:@"text"] setValue:self.NewTextView.text];


                                                  }
                                              }];

    
    self.tabBarController.tabBar.hidden = NO;
    self.PostNavigationBar.hidden = YES;
    self.PickButton.hidden = YES;
    self.NewTextView.hidden = YES;
    
    self.PostActivity.hidden = NO;
    [self.PostActivity startAnimating];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5
                                              target:self
                                            selector:@selector(timerFire:)
                                            userInfo:nil
                                             repeats:YES];
   
    
}

-(void)timerFire:(id)userinfo {
    NSLog(@"Fire999999");
    
    self.PostActivity.hidden = YES;
    [self.PostActivity stopAnimating];
    
    
    self.tabBarController.tabBar.hidden = NO;
    //回到顯示tabBar第一頁
    [self.tabBarController setSelectedIndex:0];
    
    //發出廣播端
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];
    
    
    [timer invalidate];
}
@end

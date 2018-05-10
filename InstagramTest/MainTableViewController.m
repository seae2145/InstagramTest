//
//  MainTableViewController.m
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/26.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import "MainTableViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainTableViewCell.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseStorage/FirebaseStorage.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <SDWebImage/UIImageView+WebCache.h>



@interface MainTableViewController ()
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation MainTableViewController


-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    i = 0;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    //監聽廣播端
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"reload" object:nil];
    
    
    
    UserAccountUUID = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.navigationBarHidden = YES;
    
    //TableCell連結
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MainTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MainTableViewCell class])];
    
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       
                       if ([FIRAuth auth].currentUser) {
                           // User is signed in.
                           // ...
                           FIRUser *user = [FIRAuth auth].currentUser;
                           
                           NSLog(@"User in,User UUID : %@",user.uid);
                           
                           [UserAccountUUID setObject:user.uid forKey:@"UserAccountUUID"];
                           
                           
                       } else {
                           // No user is signed in.
                           
                           NSLog(@"No User");
                           
                           //創建新View宣告 LoginViewController
                           UIViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNV"];
                           
                           [self presentViewController:ViewController animated:YES completion:nil];
                           
                       }
                       
                   }];
    
    
    self.ref = [[FIRDatabase database] reference];
    
    
    //實作重新撈資料
    [self searchPost];
    
    
    
}

//reload方法
-(void)reload:(NSNotification *)notification{
    
    [self searchPost];
    NSLog(@"收到通知");
}
    
- (void)refresh:(UIRefreshControl *)refreshControl {
    
    //實作重新撈資料
    [self searchPost];
    
    NSLog(@"testtesttesttest");
    
    [refreshControl endRefreshing];
}


//查找貼文
-(void)searchPost{
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"UserPic"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        
        
        
        UserPostImageURL = [[NSMutableArray alloc] init];
        UserPostImageText = [[NSMutableArray alloc] init];
        
        
        NSLog(@"snapshot : %@",snapshot);
        
        
        NSArray *friendsArray = [snapshot.value allValues];
        
        
        NSLog(@"friendsArray : %@",friendsArray);
        
        
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            
            //解析json
            NSLog(@"children : %@",[[child value] valueForKey:@"imageURL"]);
            [UserPostImageURL addObject:[[child value] valueForKey:@"imageURL"]];
            [UserPostImageText addObject:[[child value] valueForKey:@"text"]];
        }
       
        
//        //解析第二層
//        for (NSDictionary *p in friendsArray) {
//
//            NSString *ImageURL = [p objectForKey:@"imageURL"];
//            NSLog(@"ImageURL：%@",ImageURL);
//
//            [UserPostImageURL addObject:ImageURL];
//            //NSLog(@"imageURL：%@",snapshot.value[p]);
//
//
//
//        }

        [self.tableView reloadData];
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"error : %@", error.localizedDescription);
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    
    return [UserPostImageURL count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainTableViewCell class]) forIndexPath:indexPath];
    
    cell.UserImageview.contentMode = UIViewContentModeScaleAspectFill;
    cell.UserImageview.clipsToBounds = YES;
    cell.UserImageview.layer.cornerRadius = cell.UserImageview.frame.size.height/8;
    cell.UserImageview.layer.masksToBounds = YES;
    cell.UserImageview.layer.borderWidth = 0;
    cell.UserImageview.image = [UIImage imageNamed:@"addphoto"];
    
    cell.UserContentview.contentMode = UIViewContentModeScaleAspectFit;
    cell.UserContentview.clipsToBounds = YES;
   
    
    NSInteger imageNumber = [UserPostImageURL count] - indexPath.row - 1;
    
    NSLog(@"imageNumber : %ld",(long)imageNumber);
    NSLog(@"Index : %ld",indexPath.row);
    
    [cell.UserContentview sd_setImageWithURL:[NSURL URLWithString:[UserPostImageURL objectAtIndex:imageNumber]]
                 placeholderImage:[UIImage imageNamed:@"addphoto.png"]];
    
    
    cell.UserAccountLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    cell.UserAccountLabel.text = @"seae2145";
    
    NSString *UserText = [NSString stringWithFormat:@"seae2145: %@",[UserPostImageText objectAtIndex:imageNumber]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:UserText];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] range:NSMakeRange(0, 9)];

    cell.MessageLabel.attributedText = attributedString;
    
    
    cell.LoveButton.tag = indexPath.row;
    [cell.LoveButton addTarget:self action:@selector(setLoveButton:) forControlEvents:UIControlEventTouchDown];
    
    if (indexPath.row == 0) {
        if (i == 0) {
            [cell.LoveButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        }else{
            [cell.LoveButton setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
        }
        
    }else{
        
        [cell.LoveButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    
    
    
    return cell;
}

-(void)setLoveButton:(id)sender{
    
     NSLog(@"第%ld個愛心",(long)[sender tag]);
   
        i = 1;
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
        //讀取使用者所選取的cell
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.LoveButton setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
        
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{ //列表每一格的間隔
    
    return 580;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}





@end

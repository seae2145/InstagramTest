//
//  MainTableViewController.h
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/26.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"

@interface MainTableViewController : UITableViewController{
    NSMutableArray *UserPostImageURL;
    NSMutableArray *UserPostImageText;
    MainTableViewCell *cell;
    int i;
    NSUserDefaults *UserAccountUUID;
}

@end

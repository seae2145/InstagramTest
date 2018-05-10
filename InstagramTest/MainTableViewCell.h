//
//  MainTableViewCell.h
//  InstagramTest
//
//  Created by 張揚法 on 2018/3/26.
//  Copyright © 2018年 張揚法. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *MessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UserImageview;
@property (weak, nonatomic) IBOutlet UIImageView *UserContentview;
@property (weak, nonatomic) IBOutlet UIButton *LoveButton;

@end

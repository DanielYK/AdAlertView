//
//  DYAdAlertView.h
//  DYAdAlertViewApp
//
//  Created by Daniel Yao on 16/12/16.
//  Copyright © 2016年 Daniel Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYAdAlertDelegate <NSObject>

-(void)clickAlertViewAtIndex:(NSInteger)index;

@end

@interface DYAdAlertView : UIView

@property(nonatomic,assign)id<DYAdAlertDelegate> delegate;

+(DYAdAlertView *)showInView:(UIView *)view theDelegate:(id)delegate theADInfo: (NSArray *)dataList placeHolderImage: (NSString *)placeHolderStr;

@end


@interface DYItemView : UIView

@property(nonatomic,assign)NSInteger index;//记录当前第几个item
@property(nonatomic,strong)UIImageView*imageView;//自定义视图

@end

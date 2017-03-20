//
//  ViewController.m
//  DYAdAlertViewApp
//
//  Created by Daniel Yao on 16/12/16.
//  Copyright © 2016年 Daniel Yao. All rights reserved.
//

#import "ViewController.h"
#import "DYAdAlertView.h"
#import "DYWKWebVC.h"
#import "DYAdModel.h"

@interface ViewController ()<DYAdAlertDelegate>
@property(nonatomic,strong)NSMutableArray *imgArr;
@property(nonatomic,strong)UIButton *showBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showBtn];

    _imgArr = [self setImgArr];
}
-(NSMutableArray *)setImgArr{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i<=5; i++) {
        DYAdModel *adModel  = [[DYAdModel alloc]init];
        adModel.imgStr      = [NSString stringWithFormat:@"%d",i];
        adModel.linkUrl     = @"https://www.apple.cn";
        [arr addObject:adModel];
    }
    return arr;
}
-(UIButton*)showBtn{
    if (!_showBtn) {
        _showBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
        _showBtn.center = self.view.center;
        _showBtn.bounds = CGRectMake(0, 0, 100, 60);
        [_showBtn setTitle:@"弹、弹、弹" forState:UIControlStateNormal];
        [_showBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showAdAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}
-(void)showAdAlertView{
    [DYAdAlertView  showInView:self.view theDelegate:self theADInfo:_imgArr placeHolderImage:@"1"];
}
-(void)clickAlertViewAtIndex:(NSInteger)index{
    DYAdModel *adModel  = [_imgArr objectAtIndex:index];
    DYWKWebVC *webVC    = [[DYWKWebVC alloc]init];
    webVC.urlStr        = adModel.linkUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

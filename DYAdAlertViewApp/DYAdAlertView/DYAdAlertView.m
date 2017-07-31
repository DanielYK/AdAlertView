//
//  DYAdAlertView.m
//  DYAdAlertViewApp
//
//  Created by Daniel Yao on 16/12/16.
//  Copyright © 2016年 Daniel Yao. All rights reserved.
//

#define BaseTag      100
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define ScrollWidth   _scrollView.frame.size.width
#define ScrollHeight  _scrollView.frame.size.height

#import "DYAdAlertView.h"
#import "DYAdModel.h"

@interface DYAdAlertView()<UIScrollViewDelegate>
{
    UIPageControl   *pageControl;
    UIButton        *cancelBtn;
    NSString        *placeHolderImgStr;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)NSInteger    itemsCount;
@property(nonatomic,strong)NSArray      *adDataList;
@property(nonatomic,assign)BOOL         hiddenPageControl;
@end
@implementation DYAdAlertView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+(DYAdAlertView *)showInView:(UIView *)view theDelegate:(id)delegate theADInfo: (NSArray *)dataList placeHolderImage: (NSString *)placeHolderStr{
    if (!dataList) {
        return nil;
    }
    
    DYAdAlertView *sqAlertView = [[DYAdAlertView alloc] initShowInView:view theDelegate:delegate theADInfo:dataList placeHolderImage:placeHolderStr];
    return sqAlertView;
}
- (instancetype)initShowInView:(UIView *)view theDelegate:(id)delegate
                     theADInfo:(NSArray *)dataList
              placeHolderImage: (NSString *)placeHolderStr{
    self = [super init];
    if (self) {
        self.frame = view.bounds;
        
        self.backgroundColor    = [UIColor colorWithWhite:0.2 alpha:1.0];
        placeHolderImgStr       = placeHolderStr;
        self.delegate           = delegate;
        self.hiddenPageControl  = NO;
        self.adDataList         = dataList;
        
        [[[UIApplication sharedApplication].windows objectAtIndex:0] endEditing:YES];
        [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        
        [self showAlertAnimation];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromCurrentView:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
- (void)showAlertAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue         = [NSNumber numberWithFloat:0];
    animation.toValue           = [NSNumber numberWithFloat:1];
    animation.duration          = 0.25;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:@"opacity"];
}

-(void)removeFromCurrentView:(UIGestureRecognizer *)gesture
{
    UIView * subView    = (UIView *)[self viewWithTag:99];
    UIView * shadowView = self;
    if (CGRectContainsPoint(subView.frame, [gesture locationInView:shadowView]))
    {}else{
        [self removeSelfFromSuperview];
    }
}
- (void)removeSelfFromSuperview
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeight/2-420/2, ScreenWidth, 420)];
        _scrollView.backgroundColor         = [UIColor clearColor];
        _scrollView.userInteractionEnabled  = YES;
        _scrollView.contentSize     = CGSizeMake(self.frame.size.width*_itemsCount, 410);
        _scrollView.delegate        = self;
        _scrollView.pagingEnabled   = YES;
        _scrollView.bounces         = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(void)setAdDataList:(NSArray *)adDataList{
    
    _adDataList = adDataList;
    _itemsCount = adDataList.count;
    
    [self creatItemView];
}
-(void)creatItemView{
    
    if (_itemsCount == 0) {
        return;
    }
    if (_itemsCount == 1) {
        self.hiddenPageControl = YES;
    }
    [self addSubview:self.scrollView];
    
    for ( int i = 0; i < _itemsCount; i++ ) {
        DYAdModel *adModel = [_adDataList objectAtIndex:i];
        DYItemView*item = [[DYItemView alloc]initWithFrame:CGRectMake(ScreenWidth/2-300/2+i*ScrollWidth,0, 300, 420)];
        item.userInteractionEnabled = YES;
        item.index  = i;
        item.tag    = BaseTag+item.index;
        item.imageView.image      = [UIImage imageNamed:adModel.imgStr];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentImgView:)];
        [item addGestureRecognizer:singleTap];
        [_scrollView addSubview:item];
    }
    
    cancelBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(ScreenWidth/2-22, ScreenHeight-80, 44, 44);
    [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeSelfFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ScreenHeight-120, ScreenWidth, 20)];
    pageControl.numberOfPages   = _itemsCount;
    pageControl.currentPage     = 0;
    [pageControl addTarget:self action:@selector(pageValueChange:) forControlEvents:UIControlEventValueChanged];
    pageControl.hidden          = self.hiddenPageControl;
    
    [self addSubview:pageControl];
}
-(void)tapContentImgView:(UITapGestureRecognizer *)gesture{
    UIView *imageView = gesture.view;
    NSInteger itemTag = (long)imageView.tag-BaseTag;
    if ([self.delegate respondsToSelector:@selector(clickAlertViewAtIndex:)]){
        [self.delegate clickAlertViewAtIndex:itemTag];
        [self removeSelfFromSuperview];
    }
}

-(void)pageValueChange:(UIPageControl*)page{
    
    [UIView animateWithDuration:.35 animations:^{
        _scrollView.contentOffset = CGPointMake(page.currentPage*ScreenWidth, 0);
    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index         = scrollView.contentOffset.x/ScreenWidth;
    pageControl.currentPage = index;
}

@end

/*********D*********Y**********分**********割**********线************/
//自定义中间主界面
@implementation DYItemView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews{
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = 5;
    self.layer.shadowOpacity    = .2;
    self.layer.shadowOffset     = CGSizeMake(0, 2.5);
    self.layer.shadowColor      = [UIColor blackColor].CGColor;
    
    [self addSubview:self.imageView];
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.backgroundColor        = [UIColor colorWithWhite:0.1 alpha:1.0];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds    = YES;
    }
    return _imageView;
}



@end


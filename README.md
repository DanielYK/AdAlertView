AdAlertView
=
喜欢的朋友可以下载下来，如果代码对你有所帮助，还请给个Star，非常感谢你的支持！
= 
 * 仿滴滴、易到等广告弹窗的demo
 
 
 * 效果图
 
  ![image](https://github.com/DanielYK/AdAlertView/blob/master/adAlertView.gif)


 * 对应文件
 * DYAdAlertView : 主要显示界面，可以对该界面进行定制自己想要的UI界面
 * DYAdModel：每个界面显示的model
 * DYWKWebVC：点击跳转到的web界面，使用的WKWebView
 
 * 具体使用，简单、粗暴
<pre><code>
[clickBtn addTarget:self action:@selector(showAdAlertView) forControlEvents:UIControlEventTouchUpInside];

-(void)showAdAlertView{
    [DYAdAlertView  showInView:self.view theDelegate:self theADInfo:_imgArr placeHolderImage:@"1"];
}
</code></pre>

* 实现相对应的代理方法 <DYAdAlertDelegate>
<pre><code>
#pragma mark - YKScrollRulerDelegate
-(void)clickAlertViewAtIndex:(NSInteger)index{
    DYAdModel *adModel  = [_imgArr objectAtIndex:index];
    DYWKWebVC *webVC    = [[DYWKWebVC alloc]init];
    webVC.urlStr        = adModel.linkUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}
</code></pre>

 - 使用过程中有问题请加QQ或发邮件:584379066 备注：Git AdAlertView


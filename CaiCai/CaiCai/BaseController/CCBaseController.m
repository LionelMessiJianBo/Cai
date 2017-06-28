//
//  CCBaseController.m
//  CaiCai
//
//  Created by pdid on 2017/6/28.
//  Copyright © 2017年 pdid. All rights reserved.
//

#import "CCBaseController.h"

@interface CCBaseController ()

@end

@implementation CCBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
}
#pragma mark -- 设置导航栏
-(void)setNavigation{
    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString_Ext:@"f4f4f4"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:16],
       NSForegroundColorAttributeName:[UIColor colorWithHexString_Ext:@"333333"]}];
    //开启滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.view.backgroundColor = [UIColor colorWithHexString_Ext:@"f4f4f4"];
    //1.设置阴影颜色
    //    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    //    //2.设置阴影偏移范围
    //    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    //    //3.设置阴影颜色的透明度
    //    self.navigationController.navigationBar.layer.shadowOpacity = 0.6;
    //    //4.设置阴影半径
    //    self.navigationController.navigationBar.layer.shadowRadius = 1;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

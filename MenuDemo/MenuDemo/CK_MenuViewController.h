//
//  CK_MenuViewController.h
//  MenuDemo
//
//  Created by lanou3g on 16/4/14.
//  Copyright © 2016年 ©蒋宗涛©. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuClickDelegate <NSObject>

- (void)didClickMenuIndex:(NSInteger)index Title:(NSString *)title;

@end



@interface CK_MenuViewController : UIViewController

///左侧菜单 controller
@property (nonatomic, strong) UIViewController *leftViewController;

///中间的视图 controller
@property (nonatomic, strong) UIViewController *centerViewController;

///当前菜单的状态      //readonly 展开get方法   只读
@property (nonatomic, assign, readonly) BOOL isShowing;


///菜单中的菜单项
@property (nonatomic, strong ) NSMutableArray *menuArray;

///点击接收数据的代理
@property (nonatomic, weak) id<MenuClickDelegate>menuDelegate;


///第三方的初始化方法
+ (instancetype)instanceWithLeftViewController:(UIViewController *)leftVC CenterViewController:(UIViewController *)centerVC;

///单利 获取抽屉的方法
+ (instancetype)getMenuViewController;

//展示左侧菜单
- (void)showLeftViewController;

//关闭左侧菜单
- (void)hideLeftViewController;






@end

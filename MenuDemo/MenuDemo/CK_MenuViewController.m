//
//  CK_MenuViewController.m
//  MenuDemo
//
//  Created by lanou3g on 16/4/14.
//  Copyright © 2016年 ©蒋宗涛©. All rights reserved.
//

#import "CK_MenuViewController.h"
#import "CK_LeftViewController.h"
#import "ViewController.h"
//抽屉展开的程度
#define kMenuLeftWith  [UIScreen mainScreen].bounds.size.width * 0.7


@interface CK_MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

//默认左侧tableView
@property (nonatomic, strong) UITableView *leftTableView;

@end

@implementation CK_MenuViewController
//判断当前是否展开
- (BOOL)isShowing {
    if (self.centerViewController.view.transform.tx > 0) {
        return YES;
    }
    return NO;
}

//初始化方法
static CK_MenuViewController *CK_menuVC = nil;
+ (instancetype)instanceWithLeftViewController:(UIViewController *)leftVC CenterViewController:(UIViewController *)centerVC {
    //线程锁
    @synchronized(self) {
        if (!CK_menuVC) {
            CK_menuVC = [[CK_MenuViewController alloc]init];
            //设置window的rootViewController
            [UIApplication sharedApplication].keyWindow.rootViewController = CK_menuVC;
            //设置属性
            CK_menuVC.leftViewController = leftVC;
            CK_menuVC.centerViewController = centerVC;
            //添加子视图控制器的子视图
            if (leftVC) {
                [CK_menuVC addChildViewController:leftVC];
                [CK_menuVC.view addSubview:leftVC.view];
            }else {
                [CK_menuVC setupLeftViewController];
            }
            if (centerVC) {
                [CK_menuVC addChildViewController:centerVC];
                [CK_menuVC.view addSubview:centerVC.view];
            }
        }
    }
    return CK_menuVC;
}
//默认的菜单视图
- (void)setupLeftViewController {
    /*
    //没有的时候创建
//    CK_LeftViewController *leftVC = [[CK_LeftViewController alloc]init];
//    [self addChildViewController:leftVC];
//    self.leftViewController = leftVC;
//    [self.view addSubview:leftVC.view];
  */
    
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(-kMenuLeftWith, 0, kMenuLeftWith, self.view.frame.size.height) style:UITableViewStylePlain];
    //设置数据原
    self.leftTableView.dataSource = self;
    //代理
    self.leftTableView.delegate = self;
    [self.view addSubview:self.leftTableView];
}

#pragma mark - UITableViewDataSource
//数据源代理的方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *reuserID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserID];
    }
    cell.textLabel.text = self.menuArray[indexPath.row];
    return cell;
}
//menuArray 的setter的方法
- (void) setMenuArray:(NSMutableArray *)menuArray{
    if (_menuArray != menuArray) {
        _menuArray = nil;
        _menuArray = menuArray;
        [self.leftTableView reloadData];
    }
}



//单利 获取抽屉的方法
+ (instancetype)getMenuViewController {
    return CK_menuVC;
}


//展示左侧菜单
- (void)showLeftViewController{
    [self showLeftViewController:0.7];

}
- (void)showLeftViewController:(CGFloat)duration {
    //动画展开
    [UIView animateWithDuration:0.5 animations:^{
        self.centerViewController.view.transform = CGAffineTransformMakeTranslation(kMenuLeftWith, 0);
        self.leftViewController.view.transform = CGAffineTransformMakeTranslation(kMenuLeftWith, 0);
        self.leftTableView.transform = CGAffineTransformMakeTranslation(kMenuLeftWith, 0);
    }];
}

//关闭左侧菜单
- (void)hideLeftViewController {
    [self hideLeftViewController:0.7];
}
- (void)hideLeftViewController:(CGFloat)duration {
    //动画关闭
    [UIView animateWithDuration:0.5 animations:^{
        self.centerViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
        self.leftViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
        self.leftTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //代理传值
    if ([self.menuDelegate respondsToSelector:@selector(didClickMenuIndex:Title:)]) {
        [self.menuDelegate didClickMenuIndex:indexPath.row Title:self.menuArray[indexPath.row]];
    }
    //关闭抽屉
    [self hideLeftViewController];

    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    //手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMenuWithPanGesture:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - 手势
// 静态变量保存初始状态
static CGPoint begin;
static CGAffineTransform transform;
- (void)panMenuWithPanGesture:(UIPanGestureRecognizer *)pan {
    // 位移量
    CGPoint translatePoint = CGPointZero;
    // 开始手势时的位置
    if (pan.state == UIGestureRecognizerStateBegan) {
        begin = [pan locationInView:self.view];
        transform = self.centerViewController.view.transform;
    }
    // 手势过程中的位置
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint end = [pan locationInView:self.view];
        translatePoint = CGPointMake(end.x - begin.x, 0);
    }
    // 手势结束时的位置
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        if (self.centerViewController.view.transform.tx > kMenuLeftWith * 0.5) {
            // 动画设置动画时长
            [self showLeftViewController:0.13];
        }else {
            [self hideLeftViewController:0.13];
        }
        return;
    }
    // 手势过程中，对视图进行位移
    if(self.centerViewController.view.transform.tx >= 0 && self.centerViewController.view.transform.tx <= kMenuLeftWith) {
        self.centerViewController.view.transform = CGAffineTransformTranslate(transform, translatePoint.x, 0);
        self.leftViewController.view.transform = CGAffineTransformTranslate(transform,translatePoint.x, 0);
        self.leftTableView.transform = CGAffineTransformTranslate(transform, translatePoint.x, 0);
    }
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

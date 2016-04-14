//
//  ViewController.m
//  MenuDemo
//
//  Created by lanou3g on 16/4/14.
//  Copyright © 2016年 ©蒋宗涛©. All rights reserved.
//

#import "ViewController.h"
#import "CK_MenuViewController.h"


@interface ViewController ()<MenuClickDelegate>

///显示 传输过来的值
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.frame = CGRectMake(100, 0, self.view.frame.size.width, 60);
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.frame = CGRectMake(100, 0, self.view.frame.size.width, 64);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBatBtnItem:)];

    //设置为菜单代理
    [CK_MenuViewController getMenuViewController].menuDelegate = self;
    
  
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didClickLeftBatBtnItem:(UIBarButtonItem *) item {
    
    if ([CK_MenuViewController getMenuViewController].isShowing) {
        //关闭菜单
        [[CK_MenuViewController getMenuViewController]hideLeftViewController];
    }else{
        //打开菜单
        [[CK_MenuViewController getMenuViewController]showLeftViewController];
    }
}




#pragma mark - MenuClickDelegate
//点击菜单传递的值
- (void)didClickMenuIndex:(NSInteger)index Title:(NSString *)title {
    self.menuLabel.text = [NSString stringWithFormat:@"第%ld: %@ ",(long)index,title];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

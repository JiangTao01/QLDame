//
//  CK_LeftViewController.m
//  MenuDemo
//
//  Created by lanou3g on 16/4/14.
//  Copyright © 2016年 ©蒋宗涛©. All rights reserved.
//

#import "CK_LeftViewController.h"

@interface CK_LeftViewController ()<UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *leftTableView;

@end

@implementation CK_LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [@[@"开通会员",@"QQ钱包",@"个性装扮"]mutableCopy];
    
    CGFloat x = - [UIScreen mainScreen].bounds.size.width * 0.7;
    CGFloat w = [UIScreen mainScreen].bounds.size.width * 0.7;
    CGFloat h = self.view.frame.size.height;
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(x, 0, w, h) style:UITableViewStylePlain];
    self.leftTableView.dataSource = self;
    //
    [self.view addSubview:self.leftTableView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
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

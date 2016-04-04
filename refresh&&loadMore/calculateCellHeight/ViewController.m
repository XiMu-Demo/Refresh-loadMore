//
//  ViewController.m
//  calculateCellHeight
//
//  Created by Mia on 16/3/20.
//  Copyright © 2016年 Mia. All rights reserved.
//

#import "ViewController.h"
#import "SGLoadMoreView.h"

/************************自定义UIRefreshControl**************************/

@interface WSRefreshControl : UIRefreshControl

@end

@implementation WSRefreshControl

-(void)beginRefreshing
{
    [super beginRefreshing];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)endRefreshing
{
    [super endRefreshing];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end

/********************************************************************/

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong ,nonatomic)NSMutableArray *modelArray;
@property (strong,nonatomic)SGLoadMoreView *loadMoreView;
@end

@implementation ViewController

static NSString *const CellId = @"cell";


- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIRefreshControl *refresh = [[WSRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.loadMoreView = [[SGLoadMoreView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    self.tableView.tableFooterView = self.loadMoreView;
    
    [self.refreshControl beginRefreshing];
}


- (void)refresh{
    if (self.refreshControl.isRefreshing && self.loadMoreView.isAnimating ==NO){
        [self.modelArray removeAllObjects];//清除旧数据，每次都加载最新的数据
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        [self addData];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        self.loadMoreView.tipsLabel.hidden = YES;

    }
}

- (void)loadMore{
    [self addData];
    [self.loadMoreView stopAnimation];//数据加载成功后停止旋转菊花
    [self.tableView reloadData];
    
    if (self.modelArray.count > 60) {//当数据条目大于60的时候，提示没有更多数据。如果是网络数据，那么就是服务器没有数据返回的时候触发该方法
        [self.loadMoreView noMoreData];
    }
}

//加载数据
- (void)addData{
    NSDate *date = [[NSDate alloc]init];
    for (int i = 0; i < 20; i++) {
        [self.modelArray addObject:date];
    }
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.modelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    cell.textLabel.text = [dateFormatter stringFromDate:self.modelArray[indexPath.row]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    /*self.refreshControl.isRefreshing == NO加这个条件是为了防止下面的情况发生：
    每次进入UITableView，表格都会沉降一段距离，这个时候就会导致currentOffsetY + scrollView.frame.size.height   > scrollView.contentSize.height 被触发，从而触发loadMore方法，而不会触发refresh方法。
     */
    if ( currentOffsetY + scrollView.frame.size.height  > scrollView.contentSize.height &&  self.refreshControl.isRefreshing == NO  && self.loadMoreView.isAnimating == NO && self.loadMoreView.tipsLabel.isHidden ){
        [self.loadMoreView startAnimation];//开始旋转菊花
        [self loadMore];
    }
    NSLog(@"%@ ---%f----%f",NSStringFromCGRect(scrollView.frame),currentOffsetY,scrollView.contentSize.height);

}
@end

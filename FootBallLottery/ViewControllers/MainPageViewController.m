//
//  MainPageViewController.m
//  FootBallLottery
//
//  Created by jaye on 15/1/2.
//  Copyright (c) 2015年 jaye. All rights reserved.
//

#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];                         //设置导航栏
    self.dateLabel.text = [Utils timeStamp];
    self.weekLabel.text = [Utils dateDataWithDate:[NSDate date]];
    
    self.dataArray     = [[NSMutableArray alloc] init];
    self.selectArray   = [[NSMutableArray alloc] init];
    self.winVoteArray  = [[NSMutableArray alloc] init];
    self.rqArray       = [[NSMutableArray alloc] init];
    self.bfArray       = [[NSMutableArray alloc] init];
    self.jqArray       = [[NSMutableArray alloc] init];
    self.bqArray       = [[NSMutableArray alloc] init];
    
    self.hasDgArray1   = [[NSMutableArray alloc] init];
    self.hasDgArray2   = [[NSMutableArray alloc] init];
    
    self.message       = [[NSString alloc] init];
    self.tollgateNameArray = [[NSMutableArray alloc] initWithObjects:@"3串3",@"3串4",@"4串4",@"4串5",@"4串6",@"4串11",@"5串5",@"5串6",@"5串10",@"5串16",@"5串20",@"5串26",@"6串6",@"6串7",@"6串15",@"6串20",@"6串22",@"6串35",@"6串42",@"6串50",@"6串57",nil];
    
    self.tollgateNormalArray = [[NSMutableArray alloc] initWithObjects:self.danguanBtn,self.twoToone,self.threeToone,self.fourToone,self.fiveToone, nil];
    self.tollgateArray = [[NSMutableArray alloc] init];
    
    self.selectVoteDic = [[NSMutableDictionary alloc] init];
    
    moneyFloat = 0.0;                               //金额
    pageIndex = 1;                                  //第几页
    beishu = 1;                                     //倍数
    self.tollgateStr = [[NSString alloc] init];     //串关
    
    self.voteinfoStr = [[NSString alloc] init];     //投注串
    self.voteinfoStr = @"";
    
    [self createTableView];
    [self requestMainPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLightView) name:@"activeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voteSuccessRefresh) name:@"voteSuccessRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"back" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeGuide) name:@"removeGuide" object:nil];
}

- (void)removeGuide
{
    if(self.guideImage)
    {
        [self.guideImage removeFromSuperview];
    }
}

- (void)back
{
    self.navigationController.sideMenu.menuState = MFSideMenuStateLeftMenuOpen;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isSuccess)
    {
        [self createLightView];
    }
}

- (void)addLightView
{
    [self createLightView];
}

//投注成功返回
- (void)voteSuccessRefresh
{
    [self clearData];
}

- (void)clearData
{
    [self.selectArray removeAllObjects];
    [self.selectVoteDic removeAllObjects];
    [self.winVoteArray removeAllObjects];
    [self.rqArray removeAllObjects];
    [self.bfArray removeAllObjects];
    [self.jqArray removeAllObjects];
    [self.bqArray removeAllObjects];
    [self.tollgateArray removeAllObjects];
    [self.tableView reloadData];
    
    beishu = 1;
    ballotNum = 0;
    moneyFloat = 2 * ballotNum * beishu;
    self.tollgateStr = @"";
    [self.beishuBtn setTitle:[NSString stringWithFormat:@"%d倍",beishu] forState:UIControlStateNormal];
    self.beishuLabel.text = [NSString stringWithFormat:@"%d注%d倍",ballotNum,beishu];
    self.voteMoneyLabel.text = [NSString stringWithFormat:@"共%.2f元",moneyFloat];
}

//跑马灯效果
- (void)createLightView
{
    if(!self.messageLabel)
    {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, kWindowWidth, 28)];
        self.messageLabel.textColor = [Utils colorWithHexString:@"#ADAEB4"];
        self.messageLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.view addSubview:self.messageLabel];
    }
    
    self.messageLabel.text = self.message;
    CGSize size = CGSizeZero;
    
    if (kSystemVersion)
    {
        size = [self.message boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
    }
    else
    {
        size = [self.message sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 28)];
    }
    
    __block CGRect frame = self.messageLabel.frame;
    frame.origin.x = 0;
    frame.size.width = size.width;
    self.messageLabel.frame = frame;

    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:100.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:100000];
    frame = self.messageLabel.frame;
    frame.origin.x = -frame.size.width;
    self.messageLabel.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - navigationController
- (void)setupMenuBarButtonItems
{
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.titleView = [self tittleLabel];
}

//左边按钮
- (UIBarButtonItem *)leftMenuBarButtonItem
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self.navigationController.sideMenu action:@selector(toggleLeftSideMenu) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

//标题
- (UILabel *)tittleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.textColor = [Utils colorWithHexString:@"#E6E9E7"];
    label.font = [UIFont systemFontOfSize:20.0f];
    label.text = @"竞彩优选";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//右边按钮
- (UIBarButtonItem *)rightMenuBarButtonItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"cup.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self.navigationController.sideMenu action:@selector(toggleRightSideMenu) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//刷新赛事
- (IBAction)updataData:(id)sender
{
    pageIndex = 1;
    isUpdate = YES;
    [self requestMainPage];
}

- (void)showTollgateView
{
    if (self.hasDgArray1.count > 0 || self.hasDgArray2.count > 0) {
        self.danguanBtn.hidden = YES;
    }else{
        self.danguanBtn.hidden = NO;
    }
    
    [self.tollgateArray removeAllObjects];
    self.tollgateStr = @"";
    if(self.selectVoteDic.count == 1)
    {
        self.twoToone.hidden = YES;
        self.threeToone.hidden = YES;
        self.fourToone.hidden = YES;
        self.fiveToone.hidden = YES;
    }
    
    if(self.selectVoteDic.count == 2)
    {
        self.twoToone.hidden = NO;
        self.threeToone.hidden = YES;
        self.fourToone.hidden = YES;
        self.fiveToone.hidden = YES;
    }
    
    if(self.selectVoteDic.count == 3)
    {
        self.twoToone.hidden = NO;
        self.threeToone.hidden = NO;
        self.fourToone.hidden = YES;
        self.fiveToone.hidden = YES;
    }
    
    if(self.selectVoteDic.count == 4)
    {
        self.twoToone.hidden = NO;
        self.threeToone.hidden = NO;
        self.fourToone.hidden = NO;
        self.fiveToone.hidden = YES;
    }
    
    if(self.selectVoteDic.count >= 5)
    {
        self.twoToone.hidden = NO;
        self.threeToone.hidden = NO;
        self.fourToone.hidden = NO;
        self.fiveToone.hidden = NO;
    }
    
    if(self.selectVoteDic.count < 3)
    {
        self.moreTollgateBtn.hidden = YES;
    }
    else
    {
        self.moreTollgateBtn.hidden = NO;
    }
    
    for(int i = 0;i < self.tollgateNormalArray.count;i++)
    {
        UIButton *btn = (UIButton *)[self.tollgateNormalArray objectAtIndex:i];
        NSString *tittle = btn.titleLabel.text;
        if(i == 0)
        {
            tittle = @"1串1";
        }
        
        NSArray *array = [tittle componentsSeparatedByString:@"串"];
        tittle = [NSString stringWithFormat:@"%@*%@",[array objectAtIndex:0],[array objectAtIndex:1]];
        if(![self.tollgateArray containsObject:tittle])
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-normal_01.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-active_01.png"] forState:UIControlStateNormal];
        }
    }
}

//选择串关
- (IBAction)selectLevelActionClick:(id)sender
{
    if(self.selectVoteDic.count == 0)
    {
        return;
    }
    
    if(self.selectVoteDic.count == 1 && (self.hasDgArray1.count > 0 || self.hasDgArray2.count > 0))
    {
        return;
    }
    
    if(self.tollgateView.alpha == 0.0f)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.1];
        [self.tollgateView setAlpha:1.0f];
        [self.collectionView setAlpha:1.0f];
        self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150, kWindowWidth, 100);
        self.collectionView.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 200);
        [UIView commitAnimations];
        [self.moreTollgateBtn setTitle:@"显示复杂过关" forState:UIControlStateNormal];
    }
    else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.1];
        [self.tollgateView setAlpha:0.0f];
        [self.collectionView setAlpha:0.0f];
        self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150, kWindowWidth, 100);
        self.collectionView.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 200);
        [UIView commitAnimations];
    }
}

//更多过关方式
- (IBAction)moreTollgateClick:(id)sender
{
    if(self.normalTollgateView.frame.origin.y != kWindowHeight - 150)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150, kWindowWidth, 100);
            self.collectionView.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 200);
        }];
        [self.moreTollgateBtn setTitle:@"显示复杂过关" forState:UIControlStateNormal];
    }
    else
    {
        if(self.selectVoteDic.count >= 3)
        {
            if(self.selectVoteDic.count == 3)
            {
                tollgateCount = 2;
            }
            
            if(self.selectVoteDic.count == 4)
            {
                tollgateCount = 6;
            }
            
            if(self.selectVoteDic.count == 5)
            {
                tollgateCount = 12;
            }
            
            if(self.selectVoteDic.count >= 6)
            {
                tollgateCount = 21;
            }
            
            CGFloat height;
            if(tollgateCount%5 == 0)
            {
                height = tollgateCount/5*40;
            }
            else
            {
                height = (tollgateCount/5 + 1)*40;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150 - height, kWindowWidth, 100);
                self.collectionView.frame = CGRectMake(0, kWindowHeight - height - 50, kWindowWidth, height);
                [self.collectionView reloadData];
            }];
            [self.moreTollgateBtn setTitle:@"收起复杂过关" forState:UIControlStateNormal];
        }
    }
}

//选择倍数
- (void)selectCount:(NSString *)num
{
    beishu = [num intValue];
    [self.beishuBtn setTitle:[NSString stringWithFormat:@"%d倍",beishu] forState:UIControlStateNormal];
    self.beishuLabel.text = [NSString stringWithFormat:@"%d注%d倍",ballotNum,beishu];
    [self countVoteInfro];
}

//选择标准串关
- (IBAction)selectNormlTollgate:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *tollgateStr;
    if(btn.tag == 30)
    {
        tollgateStr = @"1串1";
    }
    else
    {
        tollgateStr = btn.titleLabel.text;
    }
    
    NSArray *array = [tollgateStr componentsSeparatedByString:@"串"];
    tollgateStr = [NSString stringWithFormat:@"%@*%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    
    if([self.tollgateArray containsObject:tollgateStr])
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-normal_01.png"] forState:UIControlStateNormal];
        [self.tollgateArray removeObject:tollgateStr];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"chuanguan-active_01.png"] forState:UIControlStateNormal];
        [self.tollgateArray addObject:tollgateStr];
    }
    [self countTollgateStr];
}

- (void)countTollgateStr
{
    self.tollgateStr = @"";
    for(int i = 0;i < self.tollgateArray.count;i++)
    {
        if(i != self.tollgateArray.count - 1)
        {
            self.tollgateStr = [self.tollgateStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[self.tollgateArray objectAtIndex:i]]];
        }
        else
        {
            self.tollgateStr = [self.tollgateStr stringByAppendingString:[NSString stringWithFormat:@"%@",[self.tollgateArray objectAtIndex:i]]];
        }
    }
    [self countVoteInfro];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tollgateCount;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [[self.tollgateNameArray objectAtIndex:indexPath.item] componentsSeparatedByString:@"串"];
    NSString *tollgateStr = [NSString stringWithFormat:@"%@*%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    if(![self.tollgateArray containsObject:tollgateStr])
    {
        [self.tollgateArray addObject:tollgateStr];
    }
    else
    {
        [self.tollgateArray removeObject:tollgateStr];
    }
    [self.collectionView reloadData];
    [self countTollgateStr];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TollgateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TollgateCollectionViewCell" forIndexPath:indexPath];
    [cell.tollgateBtn setTitle:[self.tollgateNameArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
    
    NSArray *array = [[self.tollgateNameArray objectAtIndex:indexPath.item] componentsSeparatedByString:@"串"];
    NSString *tollgateStr = [NSString stringWithFormat:@"%@*%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    
    if(![self.tollgateArray containsObject:tollgateStr])
    {
        [cell.tollgateBtn setBackgroundImage:[UIImage imageNamed:@"chuanguan-normal_01.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.tollgateBtn setBackgroundImage:[UIImage imageNamed:@"chuanguan-active_01.png"] forState:UIControlStateNormal];
    }
    return cell;
}

//创建TableView
- (void)createTableView
{
    if(!self.tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 125, kWindowWidth, kWindowHeight - 125 - 50)];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //给tableView添加下拉刷新,上拉加载功能
        [self.tableView addHeaderWithTarget:self action:@selector(pullDownLoading) dateKey:@"table"];
        [self.tableView addFooterWithTarget:self action:@selector(pullUpLoading)];
        [self.view addSubview:self.tableView];
        
        self.tollgateView.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight - 50);
        [self.tollgateView setAlpha:0.0f];
        [self.view addSubview:self.tollgateView];
        
        self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150, kWindowWidth, 100);
        [self.tollgateView addSubview:self.normalTollgateView];
        [self createCollection];
        
        self.footView.frame = CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, CGRectGetWidth(self.footView.frame),CGRectGetHeight(self.footView.frame));
        [self.view addSubview:self.footView];
    }
}

- (void)createCollection
{
    if (!self.collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(60, 40);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 50, kWindowWidth, 200) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView setBackgroundColor:[Utils colorWithHexString:@"#2d2f37"]];
        [self.collectionView registerNib:[UINib nibWithNibName:@"TollgateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TollgateCollectionViewCell"];
        [self.tollgateView addSubview:self.collectionView];
    }
}

//下拉刷新
- (void)pullDownLoading
{
    pageIndex = 1;
    [self requestMainPage];
}

//上拉加载
- (void)pullUpLoading
{
    if(self.dataArray.count == 0)
    {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    pageIndex += 1;
    if(pageCount % 10 == 0)
    {
        if(pageIndex > pageCount/10)
        {
            [Utils showMessage:@"已显示全部内容"];
            [self.tableView footerEndRefreshing];
            return;
        }
    }
    else
    {
        if(pageIndex > pageCount/10+1)
        {
            [Utils showMessage:@"已显示全部内容"];
            [self.tableView footerEndRefreshing];
            return;
        }
    }
    
    [self requestMainPage];
}

//恢复TableView
- (void)resumeTableView
{
    if(self.tableView.headerRefreshing)
    {
        [self.tableView headerEndRefreshing];
    }
    else if (self.tableView.footerRefreshing)
    {
        [self.tableView footerEndRefreshing];
    }
    
    [self.tableView reloadData];
}

#pragma mark - mainPageTableViewCell delegate
//选择胜平负
- (void)selectWinTieFail:(UIView *)view index:(long)index isSelect:(BOOL)isSelect
{
    //将选中的添加到字典中
    long selectIndexfortable = (long)[self.tableView indexPathForCell:(MainPageTableViewCell *)view].row;
    NSString *selectRow = [NSString stringWithFormat:@"%ld",selectIndexfortable];
    NSString *selectIndex = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *selectDic = @{@"seletRow":selectRow,@"selectIndex":selectIndex};
    NSDictionary *ele = [self.dataArray objectAtIndex:selectIndexfortable];

    if(isSelect)
    {
        [self.selectArray addObject:selectDic];
        if ([[ele objectForKey:@"spDg"] isEqualToString:@"0"]) {
            [self.hasDgArray1 addObject:[NSString stringWithFormat:@"%ld-888",index]];
        }
    }
    else
    {
        [self.selectArray removeObject:selectDic];
        if ([[ele objectForKey:@"spDg"] isEqualToString:@"0"]) {
            [self.hasDgArray1 removeLastObject];
        }
    }
   
    if([self.selectVoteDic.allKeys containsObject:selectRow])
    {
        NSMutableDictionary *row = [self.selectVoteDic objectForKey:selectRow];
        [row removeObjectForKey:@"sp"];
        
        NSString *selectContent = [[NSString alloc] init];
        for(int i = 0;i < self.selectArray.count;i++)
        {
            NSDictionary *dic = [self.selectArray objectAtIndex:i];
            NSString *selectIndex = [dic objectForKey:@"selectIndex"];
            if([[dic objectForKey:@"seletRow"] isEqualToString:selectRow])
            {
                if([selectIndex isEqualToString:@"0"])
                {
                    selectIndex = @"3";
                }
                if([selectIndex isEqualToString:@"2"])
                {
                    selectIndex = @"0";
                }
                
                selectContent = [selectContent stringByAppendingString:[NSString stringWithFormat:@"%@/",selectIndex]];
            }
        }
        
        if(selectContent.length != 0)
        {
            selectContent = [NSString stringWithFormat:@"SP=%@",[selectContent substringToIndex:selectContent.length - 1]];
            [row setObject:selectContent forKey:@"sp"];
            [self.selectVoteDic setObject:row forKey:selectRow];
        }
        
        if(row.allKeys.count == 0)
        {
            [self.selectVoteDic removeObjectForKey:selectRow];
        }
    }
    else
    {
        NSString *selectContent = [[NSString alloc] init];
        for(int i = 0;i < self.selectArray.count;i++)
        {
            NSDictionary *dic = [self.selectArray objectAtIndex:i];
            NSString *selectIndex = [dic objectForKey:@"selectIndex"];
            NSString *selRow = [dic objectForKey:@"seletRow"];
            if([selRow isEqualToString:selectRow])
            {
                if([selectIndex isEqualToString:@"0"])
                {
                    selectIndex = @"3";
                }
                if([selectIndex isEqualToString:@"2"])
                {
                    selectIndex = @"0";
                }
                
                selectContent = [selectContent stringByAppendingString:[NSString stringWithFormat:@"%@/",selectIndex]];
            }
        }
        
        selectContent = [NSString stringWithFormat:@"SP=%@",[selectContent substringToIndex:selectContent.length - 1]];
        NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
        [content setObject:selectContent forKey:@"sp"];
        
        [self.selectVoteDic setObject:content forKey:selectRow];
    }
    
    [self showTollgateView];
    [self countVoteInfro];
}

//计算投注和投注钱
- (void)countVoteInfro
{
    NSString *selectInfro = [[NSString alloc] init];
    NSString *urlSelectfro = [[NSString alloc] init];
    if(self.selectVoteDic.count != 0)
    {
        BOOL isFirst = YES;
        for(int i = 0;i < self.dataArray.count;i++)
        {
            NSString *content = [[NSString alloc] init];
            NSString *urlContent = [[NSString alloc] init];
            NSString *chuan = [[NSString alloc] init];
            NSString *key = [NSString stringWithFormat:@"%d",i];
            if([self.selectVoteDic.allKeys containsObject:key])
            {
                NSDictionary *dic = [self.selectVoteDic objectForKey:key];
                NSString *matchId = [[self.dataArray objectAtIndex:i] objectForKey:@"matchId"];
                NSString *companyId = [[self.dataArray objectAtIndex:i] objectForKey:@"companyId"];
                if(isFirst)
                {
                    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@|",matchId]];
                    urlContent = [urlContent stringByAppendingString:[NSString stringWithFormat:@"%@>%@|",matchId,companyId]];
                    isFirst = NO;
                }
                else
                {
                    content = [content stringByAppendingString:[NSString stringWithFormat:@"&%@|",matchId]];
                    urlContent = [urlContent stringByAppendingString:[NSString stringWithFormat:@"&%@>%@|",matchId,companyId]];
                }
                
                if([dic.allKeys containsObject:@"sp"])
                {
                    chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sp"]]];
                }
                
                if([dic.allKeys containsObject:@"rq"])
                {
                    if(chuan.length == 0)
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"rq"]]];
                    }
                    else
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"rq"]]];
                    }
                    
                }
                
                if([dic.allKeys containsObject:@"bf"])
                {
                    if(chuan.length == 0)
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bf"]]];
                    }
                    else
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"bf"]]];
                    }
                }
                
                if([dic.allKeys containsObject:@"jq"])
                {
                    if(chuan.length == 0)
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"jq"]]];
                    }
                    else
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"jq"]]];
                    }
                }
                
                if([dic.allKeys containsObject:@"bq"])
                {
                    if(chuan.length == 0)
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bq"]]];
                    }
                    else
                    {
                        chuan = [chuan stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"bq"]]];
                    }
                }
            }
            content = [content stringByAppendingString:chuan];
            selectInfro = [selectInfro stringByAppendingString:[NSString stringWithFormat:@"%@",content]];
            urlContent = [urlContent stringByAppendingString:chuan];
            urlSelectfro = [urlSelectfro stringByAppendingString:[NSString stringWithFormat:@"%@",urlContent]];
        }
        
        urlSelectInfro = [NSString stringWithFormat:@"HT@%@@%@@%d",urlSelectfro,self.tollgateStr,beishu];
        self.voteinfoStr = [NSString stringWithFormat:@"HT@%@@%@@%d",selectInfro,self.tollgateStr,beishu];
        NSLog(@"select %@",self.voteinfoStr);
        
        ballotNum = [JCUtil getMultiPassBallotNum:self.voteinfoStr];
        moneyFloat = 2 * ballotNum * beishu;
        self.beishuLabel.text = [NSString stringWithFormat:@"%d注%d倍",ballotNum,beishu];
        self.voteMoneyLabel.text = [NSString stringWithFormat:@"共%.2f元",moneyFloat];
    }
    else
    {
        ballotNum = 0;
        moneyFloat = 2 * ballotNum * beishu;
        self.beishuLabel.text = [NSString stringWithFormat:@"%d注%d倍",ballotNum,beishu];
        self.voteMoneyLabel.text = [NSString stringWithFormat:@"共%.2f元",moneyFloat];
    }
}

//混投
- (void)showMixBuyView:(UIButton *)btn
{
    NSMutableArray *spArray = [[NSMutableArray alloc] init];
    
    NSString *nibName = nil;
    if(kIsIphone4)
    {
        nibName = @"MixBuyView_4";
    }
    else
    {
        nibName = @"MixBuyView";
    }

    MixBuyView *mixBuyView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    mixBuyView.delegate = self;
    for(int i = 0;i < self.selectArray.count;i++)
    {
        NSString *row = [[self.selectArray objectAtIndex:i] objectForKey:@"seletRow"];
        NSString *selectIndex = [[self.selectArray objectAtIndex:i] objectForKey:@"selectIndex"];
        if(btn.tag == [row integerValue])
        {
            [spArray addObject:selectIndex];
        }
    }
    
    mixBuyView.indexRow = btn.tag;
    mixBuyView.dataDic = [self.dataArray objectAtIndex:btn.tag];
    mixBuyView.spArray = spArray;               //胜负平
    for(int i = 0;i < self.rqArray.count;i++)   //让球
    {
        NSDictionary *dic = [self.rqArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] integerValue] == btn.tag)
        {
            mixBuyView.rqArray = [dic objectForKey:@"selectIndex"];
        }
    }
    
    for(int i = 0;i < self.bfArray.count;i++)   //比分
    {
        NSDictionary *dic = [self.bfArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] integerValue] == btn.tag)
        {
            mixBuyView.bfArray = [dic objectForKey:@"selectIndex"];
        }
    }
    
    for(int i = 0;i < self.jqArray.count;i++)   //进球
    {
        NSDictionary *dic = [self.jqArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] integerValue] == btn.tag)
        {
            mixBuyView.jqArray = [dic objectForKey:@"selectIndex"];
        }
    }
    
    for(int i = 0;i < self.bqArray.count;i++)   //半全场
    {
        NSDictionary *dic = [self.bqArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] integerValue] == btn.tag)
        {
            mixBuyView.bqArray = [dic objectForKey:@"selectIndex"];
        }
    }

    [self showDialogView:mixBuyView fromFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1)];
}

//混投回调
- (void)MixDoneAction:(NSMutableArray *)spArray rqDic:(NSDictionary *)rqDic bfDic:(NSDictionary *)bfDic jqDic:(NSDictionary *)jqDic bqDic:(NSDictionary *)bqDic  indexRow:(NSInteger)index
{
    [self.selectVoteDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    BOOL hasDg = true;
    NSDictionary *ele = [self.dataArray objectAtIndex:index];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    NSString *spStr = [[NSString alloc] init];
    if(spArray.count != 0)
    {
        for (int i = 0;i < spArray.count;i++)
        {
            NSDictionary *dic = [spArray objectAtIndex:i];
            NSString *selectSpIndex = [dic objectForKey:@"selectIndex"];
            if([selectSpIndex isEqualToString:@"0"])
            {
                selectSpIndex = @"3";
            }
            else if ([selectSpIndex isEqualToString:@"2"])
            {
                selectSpIndex = @"0";
            }
            
            if(i != spArray.count - 1)
            {
                spStr = [spStr stringByAppendingString:[NSString stringWithFormat:@"%@/",selectSpIndex]];
            }
            else
            {
                spStr = [spStr stringByAppendingString:[NSString stringWithFormat:@"%@",selectSpIndex]];
            }
        }
        
        spStr = [NSString stringWithFormat:@"SP=%@",spStr];
        [dataDic setObject:spStr forKey:@"sp"];
        if ([[ele objectForKey:@"spDg"] isEqualToString:@"0"]) {
            hasDg = false;
        }
    }
    
    NSString *rqStr = [[NSString alloc] init];
    NSMutableArray *rqArr = [rqDic objectForKey:@"selectIndex"];
    if(rqArr.count != 0)
    {
        for (int i = 0;i < rqArr.count; i++)
        {
            NSDictionary *dic = [rqArr objectAtIndex:i];
            NSString *selectRqIndex = [dic objectForKey:@"selectContent"];
            
            if(i != rqArr.count - 1)
            {
                rqStr = [rqStr stringByAppendingString:[NSString stringWithFormat:@"%@/",selectRqIndex]];
            }
            else
            {
                rqStr = [rqStr stringByAppendingString:[NSString stringWithFormat:@"%@",selectRqIndex]];
            }
        }
        rqStr = [NSString stringWithFormat:@"RQ=%@",rqStr];
        [dataDic setObject:rqStr forKey:@"rq"];
        if ([[ele objectForKey:@"rqDg"] isEqualToString:@"0"]) {
            hasDg = false;
        }
    }
    
    NSString *bfStr = [[NSString alloc] init];
    NSMutableArray *bfArr = [bfDic objectForKey:@"selectIndex"];
    if(bfArr.count != 0)
    {
        for (int i = 0;i < bfArr.count; i++)
        {
            NSDictionary *dic = [bfArr objectAtIndex:i];
            NSString *selectBfIndex = [dic objectForKey:@"selectContent"];
            
            if(i != bfArr.count - 1)
            {
                bfStr = [bfStr stringByAppendingString:[NSString stringWithFormat:@"%@/",selectBfIndex]];
            }
            else
            {
                bfStr = [bfStr stringByAppendingString:[NSString stringWithFormat:@"%@",selectBfIndex]];
            }
        }
        bfStr = [NSString stringWithFormat:@"BF=%@",bfStr];
        [dataDic setObject:bfStr forKey:@"bf"];
        if ([[ele objectForKey:@"bfDg"] isEqualToString:@"0"]) {
            hasDg = false;
        }
    }
    
    NSString *jqStr = [[NSString alloc] init];
    NSMutableArray *jqArr = [jqDic objectForKey:@"selectIndex"];
    if(jqArr.count != 0)
    {
        for (int i = 0;i < jqArr.count; i++)
        {
            NSDictionary *dic = [jqArr objectAtIndex:i];
            NSString *selectJqIndex = [dic objectForKey:@"selectContent"];
            
            if(i != jqArr.count - 1)
            {
                jqStr = [jqStr stringByAppendingString:[NSString stringWithFormat:@"%@/",selectJqIndex]];
            }
            else
            {
                jqStr = [jqStr stringByAppendingString:[NSString stringWithFormat:@"%@",selectJqIndex]];
            }
        }
        jqStr = [NSString stringWithFormat:@"JQ=%@",jqStr];
        [dataDic setObject:jqStr forKey:@"jq"];
        if ([[ele objectForKey:@"jqDg"] isEqualToString:@"0"]) {
            hasDg = false;
        }
    }
    
    NSString *bqStr = [[NSString alloc] init];
    NSMutableArray *bqArr = [bqDic objectForKey:@"selectIndex"];
    if(bqArr.count != 0)
    {
        for (int i = 0;i < bqArr.count; i++)
        {
            NSDictionary *dic = [bqArr objectAtIndex:i];
            NSString *selectBqIndex = [dic objectForKey:@"selectContent"];
            
            if(i != bqArr.count - 1)
            {
                bqStr = [bqStr stringByAppendingString:[NSString stringWithFormat:@"%@/",selectBqIndex]];
            }
            else
            {
                bqStr = [bqStr stringByAppendingString:[NSString stringWithFormat:@"%@",selectBqIndex]];
            }
        }
        bqStr = [NSString stringWithFormat:@"BQ=%@",bqStr];
        [dataDic setObject:bqStr forKey:@"bq"];
        if ([[ele objectForKey:@"bqDg"] isEqualToString:@"0"]) {
            hasDg = false;
        }
    }
    
    if (hasDg) {
        [self.hasDgArray2 removeObject:[NSString stringWithFormat:@"%ld-999",(long)index]];
    }else{
        [self.hasDgArray2 addObject:[NSString stringWithFormat:@"%ld-999",(long)index]];
    }
    
    [self.selectVoteDic setObject:dataDic forKey:[NSString stringWithFormat:@"%ld",(long)index]];
    
    NSDictionary *dic = [self.selectVoteDic objectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    if(dic.count == 0)
    {
        [self.selectVoteDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    }
    
    [self showTollgateView];
    
    //胜负平
    NSString *row = [NSString stringWithFormat:@"%ld",(long)index];
    for(int i = 0;i < self.selectArray.count;i++)
    {
        NSDictionary *dic = [self.selectArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] isEqual:row])
        {
            [self.selectArray removeObjectAtIndex:i];
        }
    }
    
    for(int j = 0;j < spArray.count;j++)
    {
        [self.selectArray addObject:[spArray objectAtIndex:j]];
    }
    
    //让球
    for(int i = 0;i < self.rqArray.count;i++)
    {
        NSDictionary *dic = [self.rqArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] isEqual:row])
        {
            [self.rqArray removeObjectAtIndex:i];
        }
    }
    [self.rqArray addObject:rqDic];
    NSLog(@"self.rqArray %@",self.rqArray);
    
    //比分
    for(int i = 0;i < self.bfArray.count;i++)
    {
        NSDictionary *dic = [self.bfArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] isEqual:row])
        {
            [self.bfArray removeObjectAtIndex:i];
        }
    }
    [self.bfArray addObject:bfDic];
    NSLog(@"self.bfArray %@",self.bfArray);
    
    //进球
    for(int i = 0;i < self.jqArray.count;i++)
    {
        NSDictionary *dic = [self.jqArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] isEqual:row])
        {
            [self.jqArray removeObjectAtIndex:i];
        }
    }
    [self.jqArray addObject:jqDic];
    NSLog(@"self.jqArray %@",self.jqArray);
    
    //半全场
    for(int i = 0;i < self.bqArray.count;i++)
    {
        NSDictionary *dic = [self.bqArray objectAtIndex:i];
        if([[dic objectForKey:@"seletRow"] isEqual:row])
        {
            [self.bqArray removeObjectAtIndex:i];
        }
    }
    [self.bqArray addObject:bqDic];
    NSLog(@"self.bqArray %@",self.bqArray);
    
    [self.tableView reloadData];
    [self countVoteInfro];
}

//不赞同
- (void)disAgreeAction:(UIButton *)btn
{
    DisagreeView *disagreeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DisagreeView class]) owner:self options:nil] objectAtIndex:0];
    disagreeView.delegate = self;
    self.matchId = [[self.dataArray objectAtIndex:btn.tag] objectForKey:@"matchId"];
    [self showDialogView:disagreeView fromFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1)];
}

- (void)handDisagree:(NSString*)disagreeStr
{
    [self requestDisagree:disagreeStr];
}

//分析
- (void)analyseAction:(UIButton *)btn
{
    AnalyseView *analyseView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AnalyseView class]) owner:self options:nil] objectAtIndex:0];
    NSDictionary *dic = [self.dataArray objectAtIndex:btn.tag];
    analyseView.analyseLabel.text = [dic objectForKey:@"content"];
    [self showDialogView:analyseView fromFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1)];
}

#pragma mark - buyView
- (IBAction)voteActionClick:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.1];
    [self.tollgateView setAlpha:0.0f];
//    [self.normalTollgateView setAlpha:0.0f];
//    [self.collectionView setAlpha:0.0f];
    self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150, kWindowWidth, 100);
    self.collectionView.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 200);
    [UIView commitAnimations];
    
    if(![[AppDelegate getAppDelegate] isLogin])
    {
        [Utils showMessage:@"您还未登录，请先去登录"];
        return;
    }
    
    if(self.selectVoteDic.count == 0)
    {
        [Utils showMessage:@"请选择投注项"];
        return;
    }
    
    if(self.tollgateStr.length == 0)
    {
        [Utils showMessage:@"请选择串关"];
        return;
    }
    
    
    if(moneyFloat > [[[AppDelegate getAppDelegate] accountRemaind] floatValue])
    {
        NOVoteView *noVoteView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NOVoteView class]) owner:self options:nil] objectAtIndex:0];
        noVoteView.delegate = self;
        noVoteView.voteMoney.text = [NSString stringWithFormat:@"%.2f元",moneyFloat];
        noVoteView.remainMoney.text = [NSString stringWithFormat:@"%@元",[[AppDelegate getAppDelegate] accountRemaind]];
        [self showDialogView:noVoteView fromFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1)];
        return;
    }
    
    VoteView *voteView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VoteView class]) owner:self options:nil] objectAtIndex:0];
    voteView.voteMoney.text = [NSString stringWithFormat:@"%.2f元",moneyFloat];
    voteView.remainMoney.text = [NSString stringWithFormat:@"%@元",[[AppDelegate getAppDelegate] accountRemaind]];
    voteView.delegate = self;
    [self showDialogView:voteView fromFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1)];
}

//去充值
- (void)rechargeAction
{
    self.navigationController.sideMenu.menuState = MFSideMenuStateLeftMenuOpen;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recharge" object:nil];
}

//选择倍数
- (IBAction)selectNum:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.1];
    [self.tollgateView setAlpha:0.0f];
//    [self.normalTollgateView setAlpha:0.0f];
//    [self.collectionView setAlpha:0.0f];
    self.normalTollgateView.frame = CGRectMake(0, kWindowHeight - 150, kWindowWidth, 100);
    self.collectionView.frame = CGRectMake(0, kWindowHeight - 50, kWindowWidth, 200);
    [UIView commitAnimations];
    
    SelectNum *selectNumView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectNum class]) owner:self options:nil] objectAtIndex:0];
    selectNumView.delegate = self;
    selectNumView.numTextField.text = [NSString stringWithFormat:@"%d",beishu];
    [self showDialogView:selectNumView fromFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1)];
}


//去投注
- (void)voteAction
{
    NSString *un = [[AppDelegate getAppDelegate] userName];
    NSString *pp = [NSString stringWithFormat:@"%.2f",moneyFloat];
    NSString *mu = [NSString stringWithFormat:@"%d",beishu];
    NSString *ub = [NSString stringWithFormat:@"%d",ballotNum];
    NSString *pw = [[AppDelegate getAppDelegate] userPassword];
    NSString *url = [NSString stringWithFormat:@"un=%@&&pp=%@&&pc=%@&&mu=%@&&pt=6&&ub=%@&&pw=%@",un,pp,urlSelectInfro,mu,ub,pw];
    NSString *voteUrl = [JCUtil scrambleUrl:url];
    
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",Vote_URL,voteUrl];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webUrl]];
    
    NSLog(@"vote infro %@\n%@\n%@\n%@",url,voteUrl,[Vote_URL stringByAppendingString:voteUrl],[NSURL URLWithString:webUrl]);
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"mainPageTableView";
    MainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MainPageTableViewCell" owner:nil options:nil] lastObject];
    }
    
    //每行选中
    if(self.selectArray.count != 0)
    {
        for(int i = 0;i < self.selectArray.count;i++)
        {
            NSDictionary *dic = [self.selectArray objectAtIndex:i];
            if([[dic objectForKey:@"seletRow"] integerValue] == indexPath.row)
            {
                int index = [[dic objectForKey:@"selectIndex"] intValue];
                if(index == 0)
                {
                    [cell.winBtn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                    [cell.winBtn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
                }
                else if (index == 1)
                {
                    [cell.tieBtn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                    [cell.tieBtn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
                }
                else if (index == 2)
                {
                    [cell.failBtn setBackgroundColor:[Utils colorWithHexString:@"#1B1D24"]];
                    [cell.failBtn setTitleColor:[Utils colorWithHexString:@"#DEA20C"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    cell.delegate = self;
    cell.dataDic = [self.dataArray objectAtIndex:indexPath.row];
    cell.mixBtn.tag = cell.analyseBtn.tag = cell.disagreeBtn.tag = indexPath.row;
    [cell.mixBtn addTarget:self action:@selector(showMixBuyView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.analyseBtn addTarget:self action:@selector(analyseAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.disagreeBtn addTarget:self action:@selector(disAgreeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(tableView.visibleCells.count != 0)
    {
        UITableViewCell *tmpCell =  [tableView.visibleCells objectAtIndex:0];
        NSIndexPath *index = [tableView indexPathForCell:tmpCell];
        NSString *gameTime = [[[self.dataArray objectAtIndex:index.row] objectForKey:@"gameTime"] substringWithRange:NSMakeRange(0,10)];
        self.dateLabel.text = gameTime;
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate*inputDate = [inputFormatter dateFromString:gameTime];
        self.weekLabel.text = [Utils dateDataWithDate:inputDate];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.dataArray isEqual:[NSNull null]])
        return 0;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//默认推荐
- (void)defaultRecommend
{
    if(self.dataArray.count != 0)
    {
        for(int i = 0;i < self.dataArray.count;i++)
        {
            NSDictionary *dic = [self.dataArray objectAtIndex:i];
            if([dic.allKeys containsObject:@"spContent"])
            {
                NSString *selectRow = [NSString stringWithFormat:@"%d",i];
                NSString *spContent = [dic objectForKey:@"spContent"];
                NSString *selectIndex = nil;
                if([spContent isEqualToString:@"胜"])
                {
                    selectIndex = @"0";
                }
                else if([spContent isEqualToString:@"平"])
                {
                    selectIndex = @"1";
                }
                else if([spContent isEqualToString:@"负"])
                {
                    selectIndex = @"2";
                }
                
                NSDictionary *selectDic = @{@"seletRow":selectRow,@"selectIndex":selectIndex};
                [self.selectArray addObject:selectDic];
            }
            
//            if([dic.allKeys containsObject:@"rqContent"])
//            {
//                NSString *selectContent = nil;
//                NSString *selectIndex = nil;
//                if([dic objectForKey:@"胜"])
//                {
//                    selectContent = @"3";
//                    selectIndex = @"0";
//                }
//                else if([dic objectForKey:@"平"])
//                {
//                    selectContent = @"1";
//                    selectIndex = @"1";
//                }
//                else if ([dic objectForKey:@"负"])
//                {
//                    selectContent = @"0";
//                    selectIndex = @"2";
//                }
//                
//                NSDictionary *selectRq = @{@"selectContent":selectContent,@"selectIndex":selectIndex};
//                NSDictionary *selectRqDic = @{@"selectIndex":selectRq,@"seletRow":[NSString stringWithFormat:@"%d",i]};
//                [self.rqArray addObject:selectRqDic];
//            }
        }
        
        for (int i = 0; i < self.selectArray.count; i++)
        {
            NSDictionary *dic = [self.selectArray objectAtIndex:i];
            NSString *selectRow = [dic objectForKey:@"seletRow"];
            NSString *selectIndex = [dic objectForKey:@"selectIndex"];
            NSDictionary *ele = [self.dataArray objectAtIndex:i];
            
            if ([[ele objectForKey:@"spDg"] isEqualToString:@"0"]) {
                [self.hasDgArray1 addObject:selectIndex];
            }
            
            if([self.selectVoteDic.allKeys containsObject:selectRow])
            {
                NSMutableDictionary *row = [self.selectVoteDic objectForKey:selectRow];
                [row removeObjectForKey:@"sp"];
                
                NSString *selectContent = [[NSString alloc] init];
                for(int i = 0;i < self.selectArray.count;i++)
                {
                    NSDictionary *dic = [self.selectArray objectAtIndex:i];
                    NSString *selectIndex = [dic objectForKey:@"selectIndex"];
                    if([[dic objectForKey:@"seletRow"] isEqualToString:selectRow])
                    {
                        if([selectIndex isEqualToString:@"0"])
                        {
                            selectIndex = @"3";
                        }
                        if([selectIndex isEqualToString:@"2"])
                        {
                            selectIndex = @"0";
                        }
                        
                        selectContent = [selectContent stringByAppendingString:[NSString stringWithFormat:@"%@/",selectIndex]];
                    }
                }
                
                if(selectContent.length != 0)
                {
                    selectContent = [NSString stringWithFormat:@"SP=%@",[selectContent substringToIndex:selectContent.length - 1]];
                    [row setObject:selectContent forKey:@"sp"];
                    [self.selectVoteDic setObject:row forKey:selectRow];
                }
                
                if(row.allKeys.count == 0)
                {
                    [self.selectVoteDic removeObjectForKey:selectRow];
                }
            }
            else
            {
                NSString *selectContent = [[NSString alloc] init];
                for(int i = 0;i < self.selectArray.count;i++)
                {
                    NSDictionary *dic = [self.selectArray objectAtIndex:i];
                    NSString *selectIndex = [dic objectForKey:@"selectIndex"];
                    NSString *selRow = [dic objectForKey:@"seletRow"];
                    if([selRow isEqualToString:selectRow])
                    {
                        if([selectIndex isEqualToString:@"0"])
                        {
                            selectIndex = @"3";
                        }
                        if([selectIndex isEqualToString:@"2"])
                        {
                            selectIndex = @"0";
                        }
                        
                        selectContent = [selectContent stringByAppendingString:[NSString stringWithFormat:@"%@/",selectIndex]];
                    }
                }
                
                selectContent = [NSString stringWithFormat:@"SP=%@",[selectContent substringToIndex:selectContent.length - 1]];
                NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
                [content setObject:selectContent forKey:@"sp"];
                
                [self.selectVoteDic setObject:content forKey:selectRow];
            }
        }
        
        [self showTollgateView];
        [self countVoteInfro];
    }
}

#pragma mark - request server
//竞彩可以投注的赛事查询
- (void)requestMainPage
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<pagenum>%d</pagenum>"
                        "<pagesize>10</pagesize>"
                        "</element>"
                        "</elements>"
                        "</body>",pageIndex];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12030</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<pagenum>%d</pagenum>"
            "<pagesize>10</pagesize>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],pageIndex];
    
    NSLog(@"main page quest %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"main page responseDict %@",responseDict);
         NSMutableDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSMutableDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSDictionary *elements = [bodyDic objectForKey:@"elements"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.countLabel.text = [NSString stringWithFormat:@"推荐%@场比赛",[elements objectForKey:@"comCount"]];
             pageCount = [[elements objectForKey:@"count"] intValue];
             
             if(self.tableView.headerRefreshing || isUpdate)
             {
                 if([[elements objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dic = [elements objectForKey:@"element"];
                     [self.dataArray addObject: dic];
                 }
                 else
                 {
                     self.dataArray = [elements objectForKey:@"element"];
                 }
                 
                 [self clearData];
                 [self defaultRecommend];
                 [self resumeTableView];
                 [self countVoteInfro];
                 [self requestWinVote];
             }
             else if(self.tableView.footerRefreshing)
             {
                 if([[elements objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dic = [elements objectForKey:@"element"];
                     [self.dataArray addObject: dic];
                 }
                 else
                 {
                     [self.dataArray addObjectsFromArray:[elements objectForKey:@"element"]];
                 }
                 
                 if(self.selectArray.count != 0)
                 {
//                     [self.selectArray removeAllObjects];
                     beishu = 1;
                     ballotNum = 0;
                 }
                 
                 [self resumeTableView];
                 [self countVoteInfro];
             }
             else
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"autoLogin" object:nil];
                 
                 if([[elements objectForKey:@"element"] isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dic = [elements objectForKey:@"element"];
                     [self.dataArray addObject: dic];
                 }
                 else
                 {
                     self.dataArray = [elements objectForKey:@"element"];
                 }
                 
                 [self defaultRecommend];
                 
                 if(![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"])
                 {
                     self.guideImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                     [self.guideImage setImage:[UIImage imageNamed:@"guide.png"]];
                     [self.navigationController.view addSubview:self.guideImage];
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
                 }
                 
                 [self resumeTableView];
                 [self countVoteInfro];
                 [self requestWinVote];
             }
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
             [self resumeTableView];
         }
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self resumeTableView];
          NSLog(@"main page fail %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

//中奖纪录查询
- (void)requestWinVote
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<size>10</size>"
                        "</element>"
                        "</elements>"
                        "</body>"];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12029</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<size>10</size>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str]];
    
    NSLog(@"win vote quest %@",post);
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         NSLog(@"win vote responseDict %@",responseDict);
         NSMutableDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSMutableDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         NSMutableDictionary *elements = [bodyDic objectForKey:@"elements"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
             self.winVoteArray = [elements objectForKey:@"element"];
             for(int i = 0;i < self.winVoteArray.count;i++)
             {
                 NSDictionary *dic = [self.winVoteArray objectAtIndex:i];
                 NSString *mess = [NSString stringWithFormat:@"%@%@%@    %@元         ",[dic objectForKey:@"username"],[dic objectForKey:@"lotteryname"],[dic objectForKey:@"guoguan"],[dic objectForKey:@"bonus"]];
                 self.message = [self.message stringByAppendingString:mess];
             }
             
             if(!isSuccess)
             {
                 [self createLightView];
             }
             isSuccess = YES;
         }
         else
         {
//             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
         }
         [self resumeTableView];
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self resumeTableView];
//         NSLog(@"win vote fail %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

//投注
- (void)requestVote
{
    NSString *tollgate = [self.tollgateStr stringByReplacingOccurrencesOfString:@"*" withString:@"_"];
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<lotteryid>136</lotteryid>"
                        "<uid>%@</uid>"
                        "<votetype>2</votetype>"
                        "<votenums>%d</votenums>"
                        "<multiple>%d</multiple>"
                        "<voteinfo>%@</voteinfo>"
                        "<totalmoney>%.2f</totalmoney>"
                        "<playtype>6</playtype>"
                        "<passtype>%@</passtype>"
                        "<buymoney>%.2f</buymoney>"
                        "<protype>1</protype>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],ballotNum,beishu,self.voteinfoStr,moneyFloat,tollgate,moneyFloat];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12006_1.1</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<lotteryid>136</lotteryid>"
            "<uid>%@</uid>"
            "<votetype>2</votetype>"
            "<votenums>%d</votenums>"
            "<multiple>%d</multiple>"
            "<voteinfo>%@</voteinfo>"
            "<totalmoney>%.2f</totalmoney>"
            "<playtype>6</playtype>"
            "<passtype>%@</passtype>"
            "<buymoney>%.2f</buymoney>"
            "<protype>1</protype>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],ballotNum,beishu,self.voteinfoStr,moneyFloat,tollgate,moneyFloat];
    
    NSLog(@"vote quest %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"vote quest responseDict %@",responseDict);
         NSMutableDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSMutableDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         if([[oelement objectForKey:@"errorcode"] isEqualToString:@"0"])
         {
//             [Utils showMessage:@""];
         }
         else
         {
             [Utils showMessage:[oelement objectForKey:@"errormsg"]];
         }
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self resumeTableView];
         NSLog(@"main page fail %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

//不同意
- (void)requestDisagree:(NSString *)disagreeStr
{
    NSMutableString *unmd5str = [[NSMutableString alloc] init];
    [unmd5str appendString:TestKey];
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<body>"
                        "<elements>"
                        "<element>"
                        "<uid>%@</uid>"
                        "<matchId>%@</matchId>"
                        "<vote>1</vote>"
                        "<content>%@</content>"
                        "</element>"
                        "</elements>"
                        "</body>",[[AppDelegate getAppDelegate] uid],self.matchId,disagreeStr];
    [unmd5str appendString:xmlStr];
    
    NSMutableString *post = [[NSMutableString alloc] init];
    post = [NSMutableString stringWithFormat:
            @"SumaLottery=<?xml version =\"1.0\"encoding=\"UTF-8\"?>"
            "<message version=\"1.0\">"
            "<header>"
            "<transactiontype>12028</transactiontype>"
            "<timestamp>%@</timestamp>"
            "<digest>%@</digest>"
            "<agenterid>10000002</agenterid>"
            "<ipaddress></ipaddress>"
            "<source>WEB</source>"
            "</header>"
            "<body>"
            "<elements>"
            "<element>"
            "<uid>%@</uid>"
            "<matchId>%@</matchId>"
            "<vote>1</vote>"
            "<content>%@</content>"
            "</element>"
            "</elements>"
            "</body>"
            "</message>",
            [Utils getcurrenttime],[Utils md5:unmd5str],[[AppDelegate getAppDelegate] uid],self.matchId,disagreeStr];
    
    NSLog(@"vote quest %@",post);
    [self showProgressHUD:@"加载中"];
    
    [self.connection requestConnection:SERVER_URL
                            postParams:post
                            completion:^(NSMutableDictionary *responseDict)
     {
         [self hideProgressHUD];
         NSLog(@"vote quest responseDict %@",responseDict);
         NSMutableDictionary *bodyDic = [responseDict objectForKey:@"body"];
         NSMutableDictionary *oelement = [bodyDic objectForKey:@"oelement"];
         [Utils showMessage:[oelement objectForKey:@"errormsg"]];
     }
     failed:^(NSString *failedMessage)
     {
         [self hideProgressHUD];
         [self resumeTableView];
         NSLog(@"main page fail %@",failedMessage);
         [Utils showMessage:failedMessage];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  DetailsDestinationSecondAreaCell.m
//  GoTravel
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "DetailsDestinationSecondAreaCell.h"
#import "DetailsDesSecCollectionViewCell.h"

@interface DetailsDestinationSecondAreaCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DetailsDestinationSecondAreaCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        layout.itemSize = CGSizeMake(self.contentView.frame.size.width/2, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.collectionView registerClass:[DetailsDesSecCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)sendArray:(NSMutableArray *)array
{
    self.dataArray = array;
    [self.collectionView reloadData];
}
#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsDesSecCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell binModel:self.dataArray[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsDestinationViewModel *model = self.dataArray[indexPath.item];
    self.block(model.projectid, model.cnname);
    
}

@end

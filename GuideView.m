//
//  GuideView.m
//  ProjectDemo
//
//  Created by 远方 on 2017/3/2.
//  Copyright © 2017年 远方. All rights reserved.
//

#import "GuideView.h"
#import "DefineConst.h"

@implementation PageControl {
    NSMutableArray *_imageArr;
}

- (instancetype)init {
    self  = [super init];
    if (self) {
        _imageArr = [NSMutableArray array];
    }
    return self;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    self.frame = CGRectMake(0, 0, 28 * count + 8, 20);
    [_imageArr removeAllObjects];
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(28 * i, 0, 20, 20);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        if (i == 0) {
            imageView.backgroundColor = [UIColor blackColor];
        } else {
            imageView.backgroundColor = [UIColor whiteColor];
        }
        [_imageArr addObject:imageView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    for (int i = 0; i < _imageArr.count; i++) {
        UIImageView *imageView = [_imageArr objectAtIndex:i];
        if (i == currentPage) {
            imageView.backgroundColor = [UIColor whiteColor];
        } else {
            imageView.backgroundColor = [UIColor blackColor];
        }
    }
}

@end

@interface GuideView () <UIScrollViewDelegate>

@property (nonatomic, strong) PageControl * pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GuideView

- (void)setImages:(NSArray<NSString *> *)images {
    _images = images;
    self.pageIndex = 0;
    [self setScrollView];
    [self setPageControl];
    [self timerStart];
}

- (void)setScrollView {
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.scrollView.contentSize = CGSizeMake(_images.count * SCREENWIDTH, 0);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        for (NSUInteger i = 0; i < _images.count; i++) {
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.frame = CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
            imageV.image = [UIImage imageNamed:[_images objectAtIndex:i]];
            imageV.tag = i + 1000;
            [self.scrollView addSubview:imageV];
        }
    }
}

- (void)setPageControl {
    if (_pageControl == nil) {
        _pageControl = [[PageControl alloc] init];
        _pageControl.count = self.images.count;
        _pageControl.currentPage = 0;
        _pageControl.center = CGPointMake(SCREENWIDTH / 2.0,self.scrollView.frame.size.height - 15);
        [self addSubview:_pageControl];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *pointValue = [change objectForKey:@"new"];
        CGPoint point;
        [pointValue getValue:&point];
        [self setCurrentPage:point];
    }
}

//上次读取位置
- (void)setScrollViewLastReadPage {
    NSInteger lastRead = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"JJSLGuideViewLastReadPage"]];
    if (lastRead > _images.count - 1) {//防止上一版本的图片多于本版本导致错误
        lastRead = _images.count - 1;
    }
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width * lastRead, 0);
    [self setAndUpdataTimer:lastRead];
}

- (void)setCurrentPage:(CGPoint)point{
    NSInteger index = fabs(point.x) / self.bounds.size.width;
    //保存页数
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[NSString stringWithFormat:@"JJSLGuideViewLastReadPage"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //设置最后一页按钮的显示隐藏
    if (index == _images.count - 1) {
        
    } else if (self.pageIndex == _images.count - 1 && ((int)point.x)%((int)self.bounds.size.width) > 30){
        
    }
    
    if (self.pageIndex != index) {
        self.pageIndex = index;
        _pageControl.currentPage = self.pageIndex;
        [self setAndUpdataTimer:self.pageIndex];
    }
}

- (void)setAndUpdataTimer:(NSInteger)num {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (num < _images.count - 1) {//只有当前所在的图片小于图片总数减一时，才会开始定时器6s计时
        self.timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(updateCurrentPage) userInfo:nil repeats:NO];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self timerInvalidate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self timerStart];
}

- (void)updateCurrentPage {
    NSLog(@"self.pageIndex====%ld",self.pageIndex);
    if (self.pageIndex < _images.count - 1) {
        [self.scrollView setContentOffset:CGPointMake((self.pageIndex + 1) * SCREENWIDTH, 0) animated:YES];
        _pageControl.currentPage = self.pageIndex + 1;
    }
}

- (void)timerStart {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(updateCurrentPage) userInfo:nil repeats:YES];
    }
}

- (void)timerInvalidate {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    };
}

- (void)removeAll {
    [self timerInvalidate];
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end

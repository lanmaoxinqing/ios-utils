# Model

`YYModel Required`

* MZIdNamePair.h

```Objective-C
@interface MZIdNamePair : NSObject <YYModel, NSCoding>
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *name;

@end
```

* MZIdNamePair.m

```Objective-C
#import "MZIdNamePair.h"

@implementation MZIdNamePair

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.id = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(id))];
        self.name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (self.id) {
        [aCoder encodeObject:self.id forKey:NSStringFromSelector(@selector(id))];
    }
    if (self.name) {
        [aCoder encodeObject:self.name forKey:NSStringFromSelector(@selector(name))];
    }
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, id: %@, name: %@>", NSStringFromClass(self.class), self, self.id, self.name];
}

#pragma mark ================ address ================
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"name" : @[ @"name", @"locationName" ],
             };
}


@end
```


* MZLevelRegion.h

```Objective-C
#import "MZIdNamePair.h"


/**
 省市县三级区域
 */
@interface MZLevelRegion : NSObject

@property (nonatomic, strong) MZIdNamePair *province;
@property (nonatomic, strong) MZIdNamePair *city;
@property (nonatomic, strong) MZIdNamePair *county;

- (NSString *)componentsJoinedByString:(NSString *)separator;

@end

@interface MZLevelRegionItem : NSObject<YYModel>

@property (nonatomic, strong) MZIdNamePair *info;
@property (nonatomic, strong) NSArray<MZLevelRegionItem *> *subItems;

@end
```

* MZLevelRegion.m

```Objective-C
#import "MZLevelRegion.h"

@implementation MZLevelRegion

- (NSString *)componentsJoinedByString:(NSString *)separator {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.province.name) {
        [arr addObject:self.province.name];
    }
    if (self.city.name) {
        [arr addObject:self.city.name];
    }
    if (self.county.name) {
        [arr addObject:self.county.name];
    }
    return [arr componentsJoinedByString:separator];
}

@end

@implementation MZLevelRegionItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"subItems" : @[@"subItems", @"items"],
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *regionId, *name;
    id tempId = dic[@"id"];
    if ([tempId isKindOfClass:[NSNumber class]]) {
        regionId = [(NSNumber *)tempId stringValue];
    }
    id tempName = dic[@"name"];
    if ([tempName isKindOfClass:[NSString class]]) {
        name = [tempName copy];
    }
    self.info = [[MZIdNamePair alloc] init];
    self.info.id = regionId;
    self.info.name = name;

    return YES;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"subItems" : [MZLevelRegionItem class],
             };
}

@end
```


# Picker
`Masory Required`
* MZActivityViewController.h

```Objective-C

typedef NS_ENUM(NSInteger, MZActivityPresentationStyle) {
    MZActivityPresentationStyleDimmer,
    MZActivityPresentationStyleBlur
};

@interface MZActivityViewController : MZViewController
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;    // default 300, set before present, or it won't work
@property (nonatomic, assign) MZActivityPresentationStyle style;
@end
```

* MZActivityViewController.m

```Objective-C
#import "MZActivityViewController.h"

@interface MZActivityViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation MZActivityViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentHeight = 300.f;
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor clearColor];
    [(UIControl *)self.view addTarget:self
                               action:@selector(onDismiss:)
                     forControlEvents:UIControlEventTouchDown];

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.contentHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.bottom = self.view.height;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.contentView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isBeingPresented) {
        switch (self.style) {
            case MZActivityPresentationStyleDimmer: {
                self.backgroundView = [[UIView alloc] init];
                self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
                break;
            }
            case MZActivityPresentationStyleBlur: {
                UIImage *snapshot = [self.presentingViewController.view mz_snapshotImage];
                self.backgroundView = [[UIImageView alloc] initWithImage:[snapshot stackBlur:10]];
                break;
            }
        }
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.alpha = 0;
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.presentingViewController) {
        self.view.frame = self.presentingViewController.view.frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    if (_contentHeight != contentHeight) {
        _contentHeight = contentHeight;
        if (self.isViewLoaded) {
            self.contentView.height = contentHeight;
        }
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];

        _backgroundView = backgroundView;

        _backgroundView.frame = self.view.bounds;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view insertSubview:_backgroundView atIndex:0];
    }
}

- (void)onDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

#pragma mark - UIViewController Transitioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return UINavigationControllerHideShowBarDuration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    MZActivityViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MZActivityViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // presenting
    if ([to isKindOfClass:[MZActivityViewController class]]) {
        UIView *containerView = [transitionContext containerView];
        to.view.frame = containerView.bounds;
        to.contentView.top = to.view.height;
        [containerView addSubview:to.view];

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             to.backgroundView.alpha = 1;
                             to.contentView.bottom = containerView.height - containerView.top;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    // dismissing
    else if ([from isKindOfClass:[MZActivityViewController class]]) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             from.contentView.top = from.view.height;
                             from.backgroundView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}


@end

```

* MZLevelRegionPickerViewController.h

```Objective-C
#import "MZActivityViewController.h"
#import "MZLevelRegion.h"

@class MZLevelRegionPickerViewController;

@protocol MZLevelRegionPickerDelegate <NSObject>

- (void)levelRegionPicker:(MZLevelRegionPickerViewController *)picker didSelectRegion:(MZLevelRegion *)region;
- (void)levelRegionPickerDidCancel:(MZLevelRegionPickerViewController *)picker;

@end

@interface MZLevelRegionPickerViewController : MZActivityViewController

@property (nonatomic, weak) id<MZLevelRegionPickerDelegate> delegate;
@property (nonatomic, strong) MZLevelRegion *selectedRegion;

@end

```

* MZLevelRegionPickerViewController.m

```Objective-C
#import "MZLevelRegionPickerViewController.h"
#import <Masonry/Masonry.h>

@interface MZLevelRegionPickerViewController ()<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelButton, *confirmButton;
@property (nonatomic, strong) NSArray<MZLevelRegionItem *> *provinces;

@property (nonatomic, assign) NSUInteger provinceIndex;
@property (nonatomic, assign) NSUInteger cityIndex;
@property (nonatomic, assign) NSUInteger countyIndex;

@property (nonatomic, strong) NSArray<MZLevelRegionItem *> *cities;
@property (nonatomic, strong) NSArray<MZLevelRegionItem *> *counties;

@end

@implementation MZLevelRegionPickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentHeight = 264;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.contentView addSubview:self.pickerView];

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelButton setTitleColor:[UIColor beautyTitleTextColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消"
                       forState:UIControlStateNormal];
    [self.cancelButton addTarget:self
                          action:@selector(onCancel)
                forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];

    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor beautyMainColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self
                           action:@selector(onConfirm)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.confirmButton];

    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.mas_equalTo(44);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.mas_equalTo(44);
        make.width.equalTo(self.cancelButton);
        make.left.equalTo(self.cancelButton.mas_right);
    }];


    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"level_region" ofType:@"json"];
    NSData *itemsData = [NSData dataWithContentsOfFile:filePath];
    self.provinces = [NSArray yy_modelArrayWithClass:MZLevelRegionItem.class json:itemsData];
    [self updateSelection];
}

- (void)setSelectedRegion:(MZLevelRegion *)selectedRegion {
    _selectedRegion = selectedRegion;
    if (self.isViewLoaded) {
        [self updateSelection];
    }
}

- (void)updateSelection {
    if (!self.selectedRegion) {
        self.selectedRegion = [MZLevelRegion new];
        [self selectDatasourceWithProvince:0 city:0 county:0];
        return;
    }
    __block NSUInteger provinceIndex = 0;
    __block NSUInteger cityIndex = 0;
    __block NSUInteger countyIndex = 0;
    [self.provinces enumerateObjectsUsingBlock:^(MZLevelRegionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.info.id isEqualToString:self.selectedRegion.province.id]) {
            NSArray<MZLevelRegionItem *> *cities = obj.subItems;
            [cities enumerateObjectsUsingBlock:^(MZLevelRegionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.info.id isEqualToString:self.selectedRegion.city.id]) {
                    NSArray<MZLevelRegionItem *> *counties = obj.subItems;
                    [counties enumerateObjectsUsingBlock:^(MZLevelRegionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.info.id isEqualToString:self.selectedRegion.county.id]) {
                            countyIndex = idx;
                            *stop = YES;
                        }
                    }];
                    cityIndex = idx;
                    *stop = YES;
                }
            }];
            provinceIndex = idx;
            *stop = YES;
        }
    }];

    [self selectDatasourceWithProvince:provinceIndex city:cityIndex county:countyIndex];
}


#pragma mark ================ uipickerview delegate ================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    } else if (component == 1) {
        return self.cities.count;
    } else if (component == 2) {
        return self.counties.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *title = @"";
    if (component == 0) {
        title = self.provinces[row].info.name;
    } else if (component == 1) {
        title = self.cities[row].info.name;
    } else if (component == 2) {
        title = self.counties[row].info.name;
    }

    UILabel *label = nil;
    if ([view isKindOfClass:[UILabel class]]) {
        label = (UILabel *)view;
    }
    if (!label) {
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_SYS(16);
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        label.textColor = [UIColor beautyContentTextColor];
    }
    label.text = title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self selectDatasourceWithProvince:row city:0 county:0];
    } else if (component == 1) {
        [self selectCityComponentAtIndex:row];
        [self selectCountyComponentAtIndex:0];
    } else if (component == 2) {
        [self selectCountyComponentAtIndex:row];
    }
}

- (void)selectDatasourceWithProvince:(NSUInteger)provinceIndex city:(NSUInteger)cityIndex county:(NSUInteger)countyIndex {
    [self selectProvinceComponentAtIndex:provinceIndex];
    [self selectCityComponentAtIndex:cityIndex];
    [self selectCountyComponentAtIndex:countyIndex];
}

- (void)selectProvinceComponentAtIndex:(NSInteger)index {
    if (index == -1 || index >= self.provinces.count) {
        self.selectedRegion.province = nil;
        self.cities = nil;
        [self.pickerView reloadComponent:1];
        return;
    }
    MZLevelRegionItem *item = self.provinces[index];
    self.selectedRegion.province = item.info;
    self.cities = item.subItems;

    [self.pickerView selectRow:index inComponent:0 animated:NO];
    [self.pickerView reloadComponent:1];
}

- (void)selectCityComponentAtIndex:(NSInteger)index {
    if (index == -1 || index >= self.cities.count) {
        self.selectedRegion.city = nil;
        self.counties = nil;
        [self.pickerView reloadComponent:2];
        return;
    }
    MZLevelRegionItem *item = self.cities[index];
    self.selectedRegion.city = item.info;
    self.counties = item.subItems;

    [self.pickerView selectRow:index inComponent:1 animated:NO];
    [self.pickerView reloadComponent:2];
}

- (void)selectCountyComponentAtIndex:(NSInteger)index {
    if (index == -1 || index >= self.counties.count) {
        self.selectedRegion.county = nil;
        return;
    }
    MZLevelRegionItem *item = self.counties[index];
    self.selectedRegion.county = item.info;
    [self.pickerView selectRow:index inComponent:2 animated:NO];
}

#pragma mark ================ event ================
- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(levelRegionPickerDidCancel:)]) {
        [self.delegate levelRegionPickerDidCancel:self];
    }
}

- (void)onConfirm {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(levelRegionPicker:didSelectRegion:)]) {
        [self.delegate levelRegionPicker:self didSelectRegion:self.selectedRegion];
    }
}

@end
```

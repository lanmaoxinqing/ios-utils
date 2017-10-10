//
//  MZLevelRegionPickerViewController.m
//  Meixue
//
//  Created by 心情 on 2017/7/10.
//  Copyright © 2017年 NetEase. All rights reserved.
//

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

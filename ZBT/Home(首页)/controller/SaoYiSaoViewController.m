//
//  SaoYiSaoViewController.m
//  ZBT
//
//  Created by 钟文斌 on 2018/8/1.
//  Copyright © 2018年 钟文斌. All rights reserved.
//

#import "SaoYiSaoViewController.h"
#import "Globefile.h"
#import "UIView+Extension.h"

@interface SaoYiSaoViewController ()
@property (nonatomic, strong) UIButton *flashlightBtn;
@end

@implementation SaoYiSaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor blackColor];
    
    //明暗对比
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:maskView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height)];
    
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50+ 64,SCREENBOUNDS.width - 100, SCREENBOUNDS.width - 100) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.path = maskPath.CGPath;
    
    maskView.layer.mask = maskLayer;
    
    
    
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"请去设置-隐私-相机中对扫一扫授权" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action2){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [alert addAction:action2];
        //5.将警告呈现出来
        [self presentViewController:alert animated:YES completion:nil];
        hasCameraRight = NO;
        return;
    }
    hasCameraRight = YES;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50+ 64,SCREENBOUNDS.width - 100, SCREENBOUNDS.width - 100)];
    imageView.image = [UIImage imageNamed:@"contact_scanframe"];
    [self.view addSubview:imageView];
    
    
    UILabel * introudctionLB= [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(imageView.frame) + 20, SCREENBOUNDS.width - 100, 30)];
    introudctionLB.backgroundColor = [UIColor clearColor];
    introudctionLB.textColor=[UIColor whiteColor];
    introudctionLB.font = [UIFont systemFontOfSize:13];
    introudctionLB.textAlignment = NSTextAlignmentCenter;
    introudctionLB.text=@"将取景框对准二维码，即可自动扫描";
    [self.view addSubview:introudctionLB];
    
    self.flashlightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENBOUNDS.width/2 - 20, CGRectGetMaxY(introudctionLB.frame) + 20, 100, 40)];
    [self.flashlightBtn setTitle:@"打开手电筒" forState:UIControlStateNormal];
    [self.flashlightBtn addTarget:self action:@selector(flashlightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashlightBtn];
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50+ 64 + 8, SCREENBOUNDS.width - 100 - 40, 2)];
    _line.centerX = self.view.x;
    _line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_line];
    
    [self setupCamera];
    
    [self setUpNav];
}

-(void)flashlightBtnAction:(UIButton *)sender {//闪光灯
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch]) { // 判断是否有闪光灯
            
            // 请求独占访问硬件设备
            
            [device lockForConfiguration:nil];
            
            if (sender.tag == 0) {
                
                
                sender.tag = 1;
                
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
                
            }else{
                
                
                sender.tag = 0;
                
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
                
            }
            
            // 请求解除独占访问硬件设备
            
            [device unlockForConfiguration];
            
        }
        
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 50+ 64 + 8+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (2 * num >= CGRectGetHeight(imageView.frame) - 16) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 50+ 64 + 8+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (hasCameraRight) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

- (void)setupCamera
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        weakSelf.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        weakSelf.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // Output
        weakSelf.output = [[AVCaptureMetadataOutput alloc]init];
        //    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        
        
        [weakSelf.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        weakSelf.session = [[AVCaptureSession alloc]init];
        [weakSelf.session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([weakSelf.session canAddInput:weakSelf.input])
        {
            [weakSelf.session addInput:weakSelf.input];
        }
        
        if ([weakSelf.session canAddOutput:weakSelf.output])
        {
            [weakSelf.session addOutput:weakSelf.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        weakSelf.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            weakSelf.preview =[AVCaptureVideoPreviewLayer layerWithSession:weakSelf.session];
            weakSelf.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    _preview.frame =CGRectMake(20,110,280,280);
            weakSelf.preview.frame = self.view.bounds;
            
            [self.view.layer insertSublayer:weakSelf.preview atIndex:0];
            // Start
            [weakSelf.session startRunning];
            
            CGRect intertRect = [weakSelf.preview metadataOutputRectOfInterestForRect:imageView.frame];
            
            //限制区域
            [weakSelf.output setRectOfInterest : intertRect];
            
        });
    });
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [_session stopRunning];
        [timer invalidate];
        NSLog(@"%@",stringValue);
        
        if (stringValue.length > 0) {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action2){
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action2];
            //5.将警告呈现出来
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    
}


@end

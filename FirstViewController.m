//
//  FirstViewController.m
//  Le
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 lebang. All rights reserved.
//

#import "FirstViewController.h"
#import "FMDatabase.h"
#import "AFNetworking.h"

@interface FirstViewController ()

@property (strong,nonatomic) FMDatabase *database;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *homePath = NSHomeDirectory();
    NSLog(@"homePath = %@",homePath);
    
    //第一个参数 指定路径名称  第二个参数限定在沙盒内
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSLog(@"documentPath = %@",documentPath);
    
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"FMDB.db"];
    self.database = [FMDatabase databaseWithPath:filePath];
    [self.database open];
    if ([self creat]) {
        NSLog(@"create success");
    }else{
        NSLog(@"create wrong");
    }
    [self.database close];
}

-(BOOL) creat{
    NSString *sql_create = @"create table if not exists mytable(age text,name text,sex text);";
    BOOL result = [self.database executeUpdate:sql_create];
    return result;
}


- (IBAction)update:(id)sender {
    [self.database open];
    NSString *sql_insert = @"insert into mytable(age,name,sex) values ('eighteen','liaohuan','girl');";
    BOOL result = [self.database executeUpdate:sql_insert];
    NSLog(@"insert %d",result);
    [self.database close];
}

- (IBAction)query:(id)sender {
    [self.database open];
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:@"select * from mytable;"];
    while ([resultSet next]) {
        NSString *bean = [resultSet stringForColumn:@"name"];
        bean  = [bean stringByAppendingString:[resultSet stringForColumn:@"age"]];
        [array addObject:bean];
    }
    [self.database close];
    NSLog(@"array = %@", array);
}

- (IBAction)getRequest:(id)sender {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"http://lebang08.github.io/update/le.apk"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: ----->  %@", filePath);
//    }];
//    [downloadTask resume];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:@"http://lebang08.github.io/update/leday.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];

    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = @"ccbbaa";
    params[@"password"] = @"aaaaaa";

    
    NSString *urlStr = @"http://api.iyuce.com/v1001/account/login";
    [session POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功 ----> responseObject %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}
@end

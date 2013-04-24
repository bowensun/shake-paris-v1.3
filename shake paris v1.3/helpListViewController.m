//
//  helpListViewController.m
//  shake paris v1.3
//
//  Created by user on 24/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "helpListViewController.h"

@interface helpListViewController ()

@end

@implementation helpListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showbutton1"]) {
        [segue.destinationViewController initWithInfoString:@"报警电话： 17 \n救护车： 15\n消防车： 18\n中毒急救中心： 01.40.05.48.48\n药物信息中心： 0.800.23.13.13\n急症医生中心： 01.47.07.77.77\n电力突发事故电话： 0.801.131.333\n煤气突发事故电话： 0.801.131.433\n动物急救中心： 01.47.46.09.09\n夜间护士中心： 01.45.77.40.50\n药品中心紧急电话： 01.48.74.65.18\n心脏病急救电话： 01.47.07.50.50\n紧急牙医： 01.43.37.51.00\n临时收容中心： 0.800.306.306\n虐待儿童紧急投诉电话： 119\n国际药品急救电话： 01.55.87.55.55\n自杀者心理热线： 01.45.39.40.00\n自杀急救电话： 01.40.50.34.34\n抗暑热线： 0821 222 300（0.12欧元每分钟\n红十字会： 0800 858 858\n紧急戒毒： 0800 231 313(座机免费) 0170 231 313(手机免费)\n家庭暴力救助： 01 40 33 80 60\n 抗爱滋热线(免费、匿名)： 0800 840 800\n 性侵害救助(免费、匿名)： 0800 059 595\n "];
        NSLog(@"成功");
    }else if ([segue.identifier isEqualToString:@"showbutton2"]) {
        [segue.destinationViewController initWithInfoString:@"法国电信： 1014\n电话报时： 01.40.50.34.34\n资料查询电话： 12\n国际资料查询： 003312+国家代码\n电话自动闹钟： 时间按照4位数键入，然后加*和#\n天气查询电话： 0.892.68.08.08\n扣车查询电话： 3699\n失物找寻电话： 01.55.76.20.20\n信用卡挂失： 0.836.69.08.80\n支票本挂失： 0.836.68.32.08\n警察办证中心： 01.53.71.53.71\n青年旅馆： 01.44.16.78.78\n博物馆展览查询： 0.836.68.60.06\n巴黎补助中心： 0.836.67.55.55\n巴黎大区公路查询： 01.45.17.46.80\n全法公路查询： 01.48.12.44.44\n "];
        NSLog(@"成功");
    }else if ([segue.identifier isEqualToString:@"showbutton3"]) {
        [segue.destinationViewController initWithInfoString:@"紧急求助电话号码被侵犯的时候 　　如果您要投诉妨害你的人或事，和被侵犯的时候，您可以到最近的警察局（commissariat)，在一般的工作日里警察局从早上9点到晚上19点办公，周末和节假日全天办公）。在其它的时间里您可以：\n致警察局：电话号码 17\n您也可以联系您国家驻法国大使馆或领事馆\n\n车祸遇险或生病的时候\n紧急医疗救护处 (SAMU) ：15（相当中国的120急救中心）\n消防救护处： 18 （相当中国的110和119。在中国由110承担的众多诸如救助，解困的任务在法国一般都是由消防队承担）\n如果从手机呼叫，可拨打唯一号码： 112\n您也可以联系您国家驻法国大使馆或领事馆\n\n失物或被盗\n假如您的财物被盗，首先要向当地警察局报案，然后联系您所属国驻法国大使馆或领事馆（联系方式见下表）。无论您是失窃还是丢失财物，都要在最短时间内联系以下部门：\n\n◆护照或身份证\n在警察局报填一份遗失声明，然后通知您所属国大使馆或领事馆。\n\n◆信用卡或支票\n您所在银行的紧急服务处\n\nAmerican Express驻法国挂失处电话 ：01 47 77 72 00\n\nVisa卡驻法国挂失处电话：08 36 69 08 80\n\n万事达卡（Master Card） ? 欧洲卡 （Eurocard）挂失处电话：01 45 67 53 53\n　 \nDiner:'s Club ： 01 49 06 17 50\n\n支票挂失：08 36 68 32 08\n"];
        NSLog(@"成功");
    }else if ([segue.identifier isEqualToString:@"showbutton4"]) {
        [segue.destinationViewController initWithInfoString:@"如果您在遇到麻烦的时候想不起来紧急求助电话号码，您可以向任何一个法国人寻问或者拨打英文的紧急求助电话号码。\n\nS.O.S Help：01 47 23 80 80\n\n全欧洲紧急求助电话号码：112\n\n假如你迷路了：法国的警察都很和蔼可亲，并且为人排忧解难是他们的职责，因此在您迷路的时候不要犹豫，问警察叔叔（阿姨）吧，说不定他们还会用警车把您送回去呢，又省了一笔路费不是。\n\n大使馆及领事馆\n在一个说着您跟本听不懂的语言的国家遇到麻烦可真是个大麻烦事。所以您千万不要忘了自已国家驻法国的大使馆和领事馆，去掉了交流的困难，您的问题一定会更容易解决。大使馆及领事馆的职责是：\n\n在护照被盗或丢失时对本国公民给予帮助。\n\n在本国公民重伤、重病或去世时给予帮助。\n\n在本国公民被拘留或扣留时给予帮助。\n\n在紧急情况下对本国公民给予帮助。\n\n\n建议 * 外出时随身携带您的护照、身份证和一些能证明您居留合法性的文件。\n\n* 将您的护照复印一份带在身上，如果万一您将正件丢失，通过复印件官方也可以查您的合法身份。\n\n* 不要在您的钥匙牌上写明您的姓名和地址。\n\n* 记下您在法国的临时住址并随身携带。\n"];
        NSLog(@"成功");
    }else if ([segue.identifier isEqualToString:@"showbutton5"]) {
        [segue.destinationViewController initWithInfoString:@"中华人民共和国驻法兰西共和国大使馆（巴黎）地址：No.11, George V Avenue 75008 Paris France\n传真：0033-1 47 20 24 22\n电话：0033-1 47 23 36 77\n网址：http://www.amb-chine.fr\n中华人民共和国驻法兰西共和国大使馆教育处（巴黎）\n地址：29，Rue Glaciere 75013 Paris France\n电话：0033-1 44 08 19 40\n中华人民共和国驻马赛总领事馆\n\n地址：20 Boulevard Carmagnole 13008 Marseille France\n传真：0033-4 91 32 00 08\n电话：0033-4 91 32 00 00\n中华人民共和国驻斯特拉斯堡总领事馆\n\n地址：3535 Rue Bautain 67000 Strasbourg France\n传真：0033-3 88 45 32 23\n总机：0033-3 88 45 32 32\n办公室：0033-3 88 45 32 33\n电子信箱：consugene.chn@wanadoo.fr\n\n请大家牢记，关键时刻非常有用！！！"];
        NSLog(@"成功");
    }
}

@end

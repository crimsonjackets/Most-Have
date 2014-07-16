//
//  Bridge.m
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Bridge.h"
#import "OneBridge.h"
#import "time.h"
#import "MHBridgeInfo.h"

@implementation Bridge
@synthesize locBridges;
//@synthesize bridgesScrollView;
@synthesize bridges;
@synthesize info;
@synthesize timeInterval;
@synthesize mostOnTime;
@synthesize infoOnTime;
@synthesize timeIntervalForInfo;

#define Myhour 2
#define MyMin 20
#define MyhourDif 0
#define MyMinDif 0

+(Bridge*)initWithView:(UIView*)view belowBiew:(UIView*)upView
{
    

    
    Bridge* mybridge=[self new];
    mybridge.bridges=[[NSMutableDictionary alloc]initWithCapacity:10];

    //получение данных по каждому мосту
    NSDictionary *allDict=[mybridge createArrays];
    
    NSDictionary * names = [allDict objectForKey:@"names"];
    NSDictionary * bigMost = [allDict objectForKey:@"bigMost"];
    NSDictionary * bridgeGraph = [allDict objectForKey:@"bridgeGraph"];
  //  NSDictionary * titlePhoto = [allDict objectForKey:@"titlePhoto"];
    NSDictionary * moreInfo = [allDict objectForKey:@"moreInfo"];
    NSArray *times = [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePaths]];
    NSArray * time1 = times[0];
    NSArray * time2= times[1];
    NSArray * coords = [allDict objectForKey:@"coords"];
    NSArray * points = [allDict objectForKey:@"points"];
    
    //Новые данные
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgesInfo"];
    NSArray *newBridgesInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //Массив, отображающий индексы старых данных на индексы новых
    int indexInNew[13] = {0, 1, 4, 5, 6, 7, 8, 3, 2, 10, 11, 12, 9};
    
    
    //заполнение мостов данными
    for(int i=0;i<13;i++)
    {
        
        
        
        UIImage* image=[UIImage imageNamed:@"bridge_icon_black1.png"];

        OneBridge * bridge=[[OneBridge alloc]initWithFrame:CGRectMake([[points objectAtIndex:i] CGPointValue].x, [[points objectAtIndex:i] CGPointValue].y, 50, 17) ];
        bridge.imageBackGr=[bigMost objectForKey:[NSNumber numberWithInt:i]];
        bridge.image=image;
        bridge.statys=YES;
        bridge.name=[names objectForKey:[NSNumber numberWithInt:i]];
        bridge.location=[[points objectAtIndex:i] CGPointValue];
        Mytime * timeFirst=[Mytime MAkeTimeWIthOpenTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).openTime andCloseTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).closeTime];//[time1 objectAtIndex:i];
        Mytime * timeSecond;
        if (((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).isOpenedTwoTimes){
            timeSecond=[Mytime MAkeTimeWIthOpenTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).openTime2 andCloseTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).closeTime2];//[time2 objectAtIndex:i];
        }else {
            timeSecond=[Mytime MAkeTimeWIthOpenTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).openTime andCloseTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).closeTime];//[time2 objectAtIndex:i];
        }
        
        NSLog(@"Bridge.name == %@", bridge.name);
        NSLog(@"TimeFirst.hourOpen = %d", timeFirst.hourOpen);
        NSLog(@"TimeFirst.minuteOpen = %d", timeFirst.minOpen);
        NSLog(@"TimeFirst.hourClose = %d", timeFirst.hourClose);
        NSLog(@"TimeFirst.minuteClose = %d", timeFirst.minClose);
        
        bridge.time1=timeFirst;
        bridge.time2=timeSecond;
        bridge.coord=[[coords objectAtIndex:i] CGPointValue];
        bridge.moreinfo=[moreInfo objectForKey:[NSNumber numberWithInt:i]];
        bridge.bridgeGraph=[bridgeGraph objectForKey:[NSNumber numberWithInt:i]];
        
        if(timeFirst.hourOpen==timeSecond.hourOpen)
        {   
            bridge.info=[NSString stringWithFormat:@"Разведен с %@%i-%@%i до %@%i-%@%i",
                         timeFirst.hourClS,timeFirst.hourClose,timeFirst.minClS, timeFirst.minClose,timeFirst.hourOpS, timeFirst.hourOpen,timeFirst.minOpS,timeFirst.minOpen];
        }
        else
        {
            bridge.info=[NSString stringWithFormat:@"Разведен с %@%i-%@%i до %@%i-%@%i,с %@%i-%@%i до %@%i-%@%i",
                         timeFirst.hourClS,timeFirst.hourClose,timeFirst.minClS, timeFirst.minClose,timeFirst.hourOpS, timeFirst.hourOpen,timeFirst.minOpS,timeFirst.minOpen,
                         timeSecond.hourClS,timeSecond.hourClose,timeSecond.minClS, timeSecond.minClose,timeSecond.hourOpS, timeSecond.hourOpen,timeSecond.minOpS,timeSecond.minOpen];
        }
        //добавление моста на вьюху, под низ вьюхи, которая будет скрывать его
        if(i<9)
        {
            [view insertSubview:bridge belowSubview:upView];
        }
        //добавление соваря с данным мостом в общий словарь мостов
        NSDictionary *dictBr = [NSDictionary dictionaryWithObjectsAndKeys:
                           bridge, [NSNumber numberWithInt:i],
                           nil];
        
        [mybridge.bridges addEntriesFromDictionary:dictBr];
    }
    //Добавление лого на шапку
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(110, 20, 100, 31)];
    logoImage.image=[UIImage imageNamed:@"logo.png"];
    [view addSubview:logoImage];
    //добавление всплывающей информации по мосту(пока что скрыто)
    mybridge.info=[[UILabel alloc]initWithFrame:CGRectMake(100, 21, 120, 22)];
    mybridge.info.shadowColor=[UIColor grayColor];
    mybridge.info.backgroundColor=[UIColor whiteColor];
    //добавление информации на слой выше лого(для хорошего отображения)
    [view insertSubview:mybridge.info aboveSubview:logoImage];
    mybridge.info.alpha=0;
    [mybridge.info setTextAlignment:UITextAlignmentCenter];
    [mybridge.info setFont: [UIFont fontWithName:@"Arial" size:12.0]];
    mybridge.info.layer.borderColor=[[UIColor colorWithRed:51.0f/255 green:255.0f/255 blue:254.0f/255 alpha:1] CGColor];
    mybridge.info.layer.borderWidth=2;
    
    
    
    
    
    
    return mybridge;
}




//создание базы данных по всем мостам
-(NSDictionary*)createArrays
{
    NSDictionary * names = [NSDictionary dictionaryWithObjectsAndKeys:
                            // Rounded rect buttons
                            @"мост Л. Шмидта", [NSNumber numberWithInt:0],
                            @"Дворцовый мост", [NSNumber numberWithInt:1],
                            @"Троицкий мост", [NSNumber numberWithInt:2],
                            @"Литейный мост", [NSNumber numberWithInt:3],
                            @"Б-Охтинский мост", [NSNumber numberWithInt:4],
                            @"мост А. Невского", [NSNumber numberWithInt:5],
                            @"Володарский мост", [NSNumber numberWithInt:6],
                            @"Тучков мост", [NSNumber numberWithInt:7],
                            @"Биржевой мост", [NSNumber numberWithInt:8],
                            @"Сампсониев мост", [NSNumber numberWithInt:9],
                            @"Гренадерский мост", [NSNumber numberWithInt:10],
                            @"Кантемировский", [NSNumber numberWithInt:11],
                            @"Финляндский мост", [NSNumber numberWithInt:12],
                            nil];
    NSDictionary * bigMost = [NSDictionary dictionaryWithObjectsAndKeys:
                            // Rounded rect buttons
                            @"mh_lashmidta.png", [NSNumber numberWithInt:0],
                            @"mh_dvorcoviy.jpg", [NSNumber numberWithInt:1],
                            @"mh_troickiy.jpg", [NSNumber numberWithInt:2],
                            @"mh_liteiniy.jpg", [NSNumber numberWithInt:3],
                            @"mh_bolsheohtinskiy.png", [NSNumber numberWithInt:4],
                            @"mh_anevskogo.jpg", [NSNumber numberWithInt:5],
                            @"mh_volodarskiy.jpg", [NSNumber numberWithInt:6],
                            @"mh_tuuchkov.jpg", [NSNumber numberWithInt:7],
                            @"mh_birgevoy.jpg", [NSNumber numberWithInt:8],
                            @"Сампсониев мост", [NSNumber numberWithInt:9],
                            @"Гренадерский мост", [NSNumber numberWithInt:10],
                            @"Кантемировский", [NSNumber numberWithInt:11],
                            @"Финляндский мост", [NSNumber numberWithInt:12],
                            nil];
    NSDictionary * moreInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            // Rounded rect buttons
                               @"Годы основания: 1843 — 1850 \n\nДлина моста: 331 м.\nШирина: 37 м.\n\nМост Лейтенанта Шмидта стал первым мостом Санкт-Петербурга. В своей истории мост несколько раз проходил реконструкцию. Самая масштабная произошла в 1930 – е годы, когда существенно расширили проезжую часть, а разводная опора перешла в центр моста.\nИзначально мост был назван Невским, позже переименован в Благовещенский мост (название происходило от Благовещенской площади, располагавшейся на левом берегу), с 1855 г. строение получило имя Николаевского Моста. В 1917 г. после революции мост вновь был переименован и название Мост Лейтенанта Шмидта сохранилось до начала XXI в., после чего мосту вернули прежнее историческое название.", [NSNumber numberWithInt:0],
                            @"Годы основания: 1912 — 1917\n\nДлина моста: 260 м.\nШирина: 27.8 м.\n\nОдин из самых конструктивно сложных мостов Петербурга был основан в 1917 г. по проекту архитектора Пшеницкого. Строительство моста происходило очень медленно из-за империалистической войны начала XX в. К тому же мост должен был находиться в самом центре архитектурного ансамбля города и сочетать, таким образом, технические особенности с простотой и изысканностью, сохранив культурный символизм города. Последний капитальный ремонт моста был произведен в 1997 г. Реконструкции подверглись фонари и разводная часть. Годом позже с Дворцового Моста сняли трамвайные пути.", [NSNumber numberWithInt:1],
                            @"Годы основания: 1897 — 1903  \n\nДлина моста: 578,3 м.\nШирина: 23,6 м.\n\nОдин из старейших мостов Петербурга построен по проекту французских инженеров и архитекторов. Название мост получил от Троицкого Собора, разрушенного в 1932 г. В начале XX в. мост несколько раз переименовывали. Сначала в Суворовский, затем в Кировский. Последнее название сохранилось до 1991 г., после чего Троицкому Мосту вернули прежнее имя.", [NSNumber numberWithInt:2],
                               @"Годы основания: 1875 – 1879\n\nДлина моста: 396 м.\nШирина: 34 м.\n\nЛитейный Мост является одним из старейших мостов Петербурга. Строение создано по проекту А.Е. Струве. В своей истории Литейный Мост несколько раз менял названия. В начале XX в. мост именовался Александровский (Мост Императора Александра II). Однако это имя не прижилось и за мостом вновь закрепилось название Литейный.\nПерила моста в виде чугунных стоек и литых секций, изготовленные по проекту архитектора К. К. Рахау, представляют собой образцы высокохудожественного ремесла. На литых чугунных решетках перил Литейного моста изображение герба СПб.", [NSNumber numberWithInt:3],
                               @"Годы основания: 1909 — 1911\n\nДлина моста: 335 м.\nШирина: 23.5 м.\n\nБольшеохтинский Мост или Мост Императора Петра Великого был построен по проекту профессора инженерной академии Кривошеина Г. Г. С. П. Бобровский, Г. П. Передерий, арх. В. П. Апышков, при участии проф. Н. А. Белелюбского, Г. Н. Соколова и др. В башнях, выполненных в виде маяков, находятся механизмы, управляющие разводом моста. С 1990 — 1997 мост был закрыт на капитальный ремонт. С 2005 года прекращено трамвайное движение.\n\nОпоры на кессонном основании, облицованы гранитом. Около устоев — гранитные спуски к воде, на быках — облицованные гранитом башни-маяки. В 1983 за правобережным устоем сооружен жел.-бетон. путепровод над набережной. В 1993-97 Б. м. реконструирован с сохранением прежней конструкции и внеш. вида (инж. Н. Г. Тихомиров, В. А. Паршин, В. М. Жирухин). Клепанные металлоконструкции разводного пролета заменены цельносварными, электромеханич. привод заменен электрогидравлическим. На арочных фермах поврежденные заклепки заменены высокопрочными болтами. Проезжая часть выполнена в виде металлич. ортотропной плиты с асфальто-бетон. покрытием. По Смольнинской и Синопской набережным построены подпорные стенки и жел.-бетон. путепровод за левобережным устоем.", [NSNumber numberWithInt:4],
                            @"Годы основания: 1959 — 1965\n\nДлина моста: 629 м.\nШирина: 35 м.\n\nСтратегически постройка моста была необходима для того, чтобы решить транспортные проблемы Малой Охты. Сооружено строение по проекту архитекторов Ленинградского филиала Академии строительства и архитектуры СССР. В 2000 — 2001 гг. проведена реконструкция моста по проекту инженера А. А. Журдина под руководством инженера В. Г. Павлова. Сегодня мост Александра Невского органично вписывается в архитектурный ансамбль города.", [NSNumber numberWithInt:5],
                            @"Годы основания: 1932 – 1936\n\nДлина моста: 325,24 м\nШирина: 36 м.\n\nВолодарский мост, расположенный между Ивановской и Народной улицей, был назван по имени известного революционного деятеля М. М. Володарского. Архитектором строения является Г. П. Передерия, именно по его проекту сооружен Володарский Мост. Центр. разводной пролет 2-крылый, раскрывающийся. В годы Великой Отечественной войны 1941-45 Володарский мост использовался как дублер Финляндского ж.-д. моста.", [NSNumber numberWithInt:6],
                            @"Год основания: 1982\n\nДлина: 312 м.\nШирина: 27 м.\n\nСоединяет правый берег реки Невы и Аптекарский остров через Большую Невку, связывая Выборгский и Петроградский районы Санкт-Петербурга. Последний по времени возведения разводной мост.\nНазван по одноимённой улице, которая переименована в память об освобождении от немецких оккупантов в декабре 1942 года железнодорожной станции Кантемировки в Воронежской области.\n\nВ 2002 году была выполнена художественная подсветка моста. Освещение производится 360 светильниками, расположенными по периметру переправы. Дополнительно под и на опорах моста установлены мощные прожектора.", [NSNumber numberWithInt:7],
                               @"Годы основания: 1893 — 1894\n\nДлина моста: 239 м.\nШирина: 27 м.\n\nКонструктивно Биржевой Мост близок Дворцовому. Изначально длина моста была более 300 метров, а сама постройка выполнена из дерева. В 30 — е годы XX в. деревянные основания моста были заменены на металлические. Современный вид мост обрел к 1960 году. Строительство откладывалось из — за второй мировой войны.", [NSNumber numberWithInt:8],
                            @"Годы основания: 1955 — 1957 \n\nДлина моста: 215 м.\nШирина: 27.7 м\n\nМост, носящий имя Сампсониевского собора, получил современный образ после реконструкции, произведенной русскими инженерами В. В. Демченко, Б. Б. Левиным. С 1806 здесь наводился Гренадерский наплавной мост. В 1923 г. мост переименовали в Мост Свободы. И только в 1991 г. вернули историческое название. В 2000 г. Сампсониевский мост подвергся капитальному ремонту.", [NSNumber numberWithInt:9],
                               @"Годы основания: 1904 — 1905  \n\nДлина моста: 218 м.\nШирина: 27 м\n\nГренадерский Мост связывает Петроградскую и Выборгскую стороны. В своей истории мост пять раз подвергался реконструкциям. В 1971 г. по проекту русских инженеров и архитекторов Гренадерский мост приобрел современный вид, став трехпролетным с разводной центральной частью.", [NSNumber numberWithInt:10],
                               @"Годы основания: 1979 — 1982  \n\nДлина моста: 312 м.\nШирина: 31 м.\n\nОдин из самых поздних разводных мостов Петербурга построен по проекту инженеров Б. Н. Брудно и Б. Б. Левина. Мост состоит из пяти речных пролетов. Центральный разводной пролет однокрылый, раскрывающийся, с неподвижной осыо вращения. Кантемировский мост через Большую Невку, соединяет проспект Медиков на Аптекарском острове с Выборгской набережной и Кантемировской улицей. (отсюда назв.) В 2002 году создана художественная подсветка Кантемировского моста.", [NSNumber numberWithInt:11],
                               @"Годы основания: 1910 — 1912  \n\nДлина моста: 514 м.\nШирина: 31 м.\n\nФинляндский железнодорожный мост является важным дублирующим звеном железнодорожной системы Северо-Запада, связывая оба промышленных берега Петербурга между собой. Первый мост был построен по проекту архитектора В. П. Апышкова. В 2002 г. был произведен капитальный ремонт моста.", [NSNumber numberWithInt:12],
                            nil];

//    NSDictionary * titlePhoto = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 // Rounded rect buttons
//                                 @"lSmid.png", [NSNumber numberWithInt:0],
//                                 @"DvorcON.png", [NSNumber numberWithInt:1],
//                                 @"Troic.png", [NSNumber numberWithInt:2],
//                                 @"Litein.png", [NSNumber numberWithInt:3],
//                                 @"bOhtin.png", [NSNumber numberWithInt:4],
//                                 @"aNevsk.png", [NSNumber numberWithInt:5],
//                                 @"volodar.png", [NSNumber numberWithInt:6],
//                                 @"tuchk.png", [NSNumber numberWithInt:7],
//                                 @"birzh.png", [NSNumber numberWithInt:8],
//                                 @"sampson.png", [NSNumber numberWithInt:9],
//                                 @"tuchk.png", [NSNumber numberWithInt:10],
//                                 @"birzh.png", [NSNumber numberWithInt:11],
//                                 @"sampson.png", [NSNumber numberWithInt:12],
//                                 nil];

    NSDictionary * bridgeGraph = [NSDictionary dictionaryWithObjectsAndKeys:
                                  // Rounded rect buttons
                                  @"forLSmidt.png", [NSNumber numberWithInt:0],
                                  @"forDvorc.png", [NSNumber numberWithInt:1],
                                  @"forTroizk.png", [NSNumber numberWithInt:2],
                                  @"forLitein.png", [NSNumber numberWithInt:3],
                                  @"forBolshO.png", [NSNumber numberWithInt:4],
                                  @"forAlNevsk.png", [NSNumber numberWithInt:5],
                                  @"forVolod.png", [NSNumber numberWithInt:6],
                                  @"forTuchk.png", [NSNumber numberWithInt:7],
                                  @"forBirzh.png", [NSNumber numberWithInt:8],
                                  @"forSampson.png", [NSNumber numberWithInt:9],
                                  @"forGrenad.png", [NSNumber numberWithInt:10],
                                  @"forKantem.png", [NSNumber numberWithInt:11],
                                  @"forFinl.png", [NSNumber numberWithInt:12],
                                  nil];
    
        
    NSArray * coords = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(59.934796, 30.28941)],
                        [NSValue valueWithCGPoint:CGPointMake(59.940933,30.308483)],
                        [NSValue valueWithCGPoint:CGPointMake(59.948993,30.327144)],
                        [NSValue valueWithCGPoint:CGPointMake(59.951701,30.349374)],
                        [NSValue valueWithCGPoint:CGPointMake(59.942718,30.400529)],
                        [NSValue valueWithCGPoint:CGPointMake(59.925603,30.395637)],
                        [NSValue valueWithCGPoint:CGPointMake(59.877675,30.453494)],
                        [NSValue valueWithCGPoint:CGPointMake(59.948757,30.285094)],
                        [NSValue valueWithCGPoint:CGPointMake(59.946285,30.303333)],
                        [NSValue valueWithCGPoint:CGPointMake(59.957997,30.336574)],
                        [NSValue valueWithCGPoint:CGPointMake(59.967956,30.334469)],
                        [NSValue valueWithCGPoint:CGPointMake(59.978723,30.321953)],
                        [NSValue valueWithCGPoint:CGPointMake(59.915433,30.409252)],
                        nil];
    //978356
    

    
    
    mostOnTime = [NSArray arrayWithObjects:
                        [NSMutableArray arrayWithObjects:
                                [NSString stringWithFormat:@"%d",7],
                         [NSString stringWithFormat:@"%d",8],
                         nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",7],
                   [NSString stringWithFormat:@"%d",8],
                   [NSString stringWithFormat:@"%d",2],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",7],
                   [NSString stringWithFormat:@"%d",8],
                   [NSString stringWithFormat:@"%d",2],
                   [NSString stringWithFormat:@"%d",3],
                   [NSString stringWithFormat:@"%d",0],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",2],
                   [NSString stringWithFormat:@"%d",3],
                   [NSString stringWithFormat:@"%d",0],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",2],
                   [NSString stringWithFormat:@"%d",3],
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",4],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",3],
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",4],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",4],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",4],
                   [NSString stringWithFormat:@"%d",5],
                   [NSString stringWithFormat:@"%d",6],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",5],

                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",5],
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",6],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",6],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",0],
                   [NSString stringWithFormat:@"%d",3],
                   [NSString stringWithFormat:@"%d",4],
                   [NSString stringWithFormat:@"%d",2],
                   [NSString stringWithFormat:@"%d",5],
                   [NSString stringWithFormat:@"%d",8],
                    [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",2],
                   [NSString stringWithFormat:@"%d",5],
                   [NSString stringWithFormat:@"%d",8],
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",5],
                   [NSString stringWithFormat:@"%d",8],
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",7],
                   nil],
                  [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat:@"%d",6],
                   nil],

                                      nil];
    
    
    NSInteger x=20;
    NSInteger y=70;
    NSArray * points = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(x, y)],
                        [NSValue valueWithCGPoint:CGPointMake(x+57, y)],


                        [NSValue valueWithCGPoint:CGPointMake(x, y+30)],
                        [NSValue valueWithCGPoint:CGPointMake(x+57, y+30)],
                        [NSValue valueWithCGPoint:CGPointMake(x+114, y+30)],
                        [NSValue valueWithCGPoint:CGPointMake(x+171, y+30)],
                        [NSValue valueWithCGPoint:CGPointMake(x+230, y+30)],
                        [NSValue valueWithCGPoint:CGPointMake(x+171, y)],
                        [NSValue valueWithCGPoint:CGPointMake(x+114, y)],
                        [NSValue valueWithCGPoint:CGPointMake(x, y)],
                        [NSValue valueWithCGPoint:CGPointMake(x, y)],
                        [NSValue valueWithCGPoint:CGPointMake(x, y)],
                        [NSValue valueWithCGPoint:CGPointMake(x, y)],
                        nil];
    
    
    
    NSDictionary * allDict = [NSDictionary dictionaryWithObjectsAndKeys:
                            // Rounded rect buttons
                             names,@"names",
                             moreInfo,@"moreInfo",
                            coords,@"coords",
                             points,@"points",
                             bridgeGraph,@"bridgeGraph",
                              bigMost,@"bigMost",
                            nil];
    
    infoOnTime = [NSArray arrayWithObjects:
                  [NSMutableArray arrayWithObjects:
                    @"пришло время",
                    @"запланировать",
                    @"свой маршрут",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"час романтики",
                   @"васильевского",
                   @"острова",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"есть шанс",
                   @"а. невского",
                   @"сведен",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"время",
                   @"короткой",
                   @"сводки",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"для нетерпеливых",
                   @"володарский",
                   @"на подходе",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"романтика",
                   @"белых ночей",
                   @"во всей красе",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"метро работает",
                   @"мосты сведены",
                   @"идеальный мир",
                   nil],
                  [NSMutableArray arrayWithObjects:
                   @"ВСЕ МОСТЫ",
                   @"СВЕДЕНЫ",
                   @"ХОРОШЕГО НАСТРОЕНИЯ",
                   nil],
                  nil];
    timeInterval = [NSArray arrayWithObjects:
                    [Mytime MakeTimeWithHourOP:0 minOP:45 hourCl:0 minCl:35],
                    [Mytime MakeTimeWithHourOP:0 minOP:50 hourCl:0 minCl:45],
                    [Mytime MakeTimeWithHourOP:1 minOP:05 hourCl:0 minCl:50],
                    [Mytime MakeTimeWithHourOP:1 minOP:10 hourCl:1 minCl:5],
                    [Mytime MakeTimeWithHourOP:1 minOP:15 hourCl:1 minCl:10],
                    [Mytime MakeTimeWithHourOP:1 minOP:20 hourCl:1 minCl:15],
                    [Mytime MakeTimeWithHourOP:1 minOP:25 hourCl:1 minCl:20],
                    [Mytime MakeTimeWithHourOP:1 minOP:40 hourCl:1 minCl:25],
                    [Mytime MakeTimeWithHourOP:2 minOP:10 hourCl:1 minCl:40],
                    [Mytime MakeTimeWithHourOP:2 minOP:20 hourCl:2 minCl:10],
                    [Mytime MakeTimeWithHourOP:2 minOP:45 hourCl:2 minCl:20],
                    [Mytime MakeTimeWithHourOP:3 minOP:05 hourCl:2 minCl:45],
                    [Mytime MakeTimeWithHourOP:3 minOP:10 hourCl:3 minCl:05],
                    [Mytime MakeTimeWithHourOP:3 minOP:45 hourCl:3 minCl:10],
                    [Mytime MakeTimeWithHourOP:4 minOP:15 hourCl:3 minCl:45],
                    [Mytime MakeTimeWithHourOP:5 minOP:0 hourCl:4 minCl:15],
                    [Mytime MakeTimeWithHourOP:5 minOP:5 hourCl:5 minCl:0],
                    [Mytime MakeTimeWithHourOP:5 minOP:10 hourCl:5 minCl:05],
                    [Mytime MakeTimeWithHourOP:5 minOP:15 hourCl:5 minCl:10],
                    [Mytime MakeTimeWithHourOP:5 minOP:45 hourCl:5 minCl:15],
                    [Mytime MakeTimeWithHourOP:0 minOP:35 hourCl:5 minCl:45],
                    
                    nil];

    timeIntervalForInfo = [NSArray arrayWithObjects:
                    [Mytime MakeTimeWithHourOP:1 minOP:25 hourCl:0 minCl:35],
                    [Mytime MakeTimeWithHourOP:2 minOP:00 hourCl:1 minCl:25],
                    [Mytime MakeTimeWithHourOP:2 minOP:20 hourCl:2 minCl:00],
                    [Mytime MakeTimeWithHourOP:3 minOP:10 hourCl:2 minCl:20],
                    [Mytime MakeTimeWithHourOP:3 minOP:45 hourCl:3 minCl:10],
                    [Mytime MakeTimeWithHourOP:5 minOP:00 hourCl:3 minCl:45],
                    [Mytime MakeTimeWithHourOP:5 minOP:45 hourCl:5 minCl:00],
                    nil];
    
    return allDict;
    

}

-(NSArray *)getInfoTitlewithCalendar:(NSCalendar *)calendar
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComps = [calendar components:(  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    NSInteger hour=currentComps.hour;
    NSInteger min=currentComps.minute;
    NSInteger minCur=60*(hour-MyhourDif)+min-MyMinDif;
    int index=-1;
    for(int i=0;i<=6;i++)
    {
        Mytime* timeInter=[timeIntervalForInfo objectAtIndex:i];
        NSInteger minOp1=timeInter.hourOpen*60+timeInter.minOpen;
        NSInteger minCl1=timeInter.hourClose*60+timeInter.minClose;
        if(minCl1<=minCur && minOp1>minCur)
        {
            index=i;
            break;
        }
    }
    if(index>-1)
    return [infoOnTime objectAtIndex:index];
    else
        return [infoOnTime objectAtIndex:7];
    
}

-(NSString*)getTimeToClose:(OneBridge*)curBridge withTime:(NSDateComponents *)currentComps
{
    NSInteger hour=currentComps.hour;
    NSInteger min=currentComps.minute;
    NSInteger difTime=[curBridge timeToCloseWithHour:hour-MyhourDif andMin:min-MyMinDif];

    if(difTime>-1)
    {
        NSString *result=[NSString stringWithFormat:@"%i",difTime];
        return result;
    }
    else
    {
        
        difTime=[curBridge timeToOpenWithHour:hour-MyhourDif andMin:min-MyMinDif];
        NSString *result=[NSString stringWithFormat:@"%i",difTime];
        return result;
    }
}

-(NSArray*)sortBridges:(NSMutableArray*)myBridges
{
    locationManager = [[CLLocationManager alloc] init];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
  //  int n = [s intValue];


    for(int i=[myBridges count]-1;i>0;i--)
    {
        for(int j=0;j<i;j++)
        {
            int n1 =[[myBridges objectAtIndex:j] intValue];
            int n2 =[[myBridges objectAtIndex:j+1] intValue];
            OneBridge *bridge1=[self.bridges objectForKey:[NSNumber numberWithInt:n1]];
            OneBridge *bridge2=[self.bridges objectForKey:[NSNumber numberWithInt:n2]];
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:bridge1.coord.x longitude:bridge1.coord.y ];
            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:bridge2.coord.x longitude:bridge2.coord.y ];
            CLLocationDistance dist1 = [loc distanceFromLocation:loc1];

            CLLocationDistance dist2 = [loc distanceFromLocation:loc2];



            
            if(dist1>dist2)
            {
                [myBridges exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
            }
        }
    }
    return myBridges;
}

-(NSArray*)getListOfMostwithCalendar:(NSCalendar *)calendar
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComps = [calendar components:(  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    NSInteger hour=currentComps.hour;
    NSInteger min=currentComps.minute;
    NSInteger minCur=60*(hour-MyhourDif)+min-MyMinDif;;
    int index=-1;
    for(int i=0;i<=20;i++)
    {
        Mytime* timeInter=[timeInterval objectAtIndex:i];
        NSInteger minOp1=timeInter.hourOpen*60+timeInter.minOpen;
        NSInteger minCl1=timeInter.hourClose*60+timeInter.minClose;
        if(minCl1<=minCur && minOp1>minCur)
        {
            index=i;
            break;
        }
    }

    if(index==-1)
        return nil;
    
    NSMutableArray* findBridges=[mostOnTime objectAtIndex:index];
    
    NSArray *resultPre = [NSArray arrayWithArray:[self sortBridges:findBridges]];
    
    NSMutableArray *result=[NSMutableArray new];

    NSString *resultString;
    
    for(int i=0;i<[resultPre count];i++)
    {
        
        OneBridge *bridge=[bridges objectForKey:[NSNumber numberWithInt:[[resultPre objectAtIndex:i] intValue]]];
        NSString *time=[self getTimeToClose:bridge withTime:currentComps];
        NSInteger ident=[time intValue]%10;
        NSString *minute=[NSString new];
        if (ident==1) {
            minute=@"минута";
        }
        else
        {
            if(ident>1&&ident<5)
            {
                minute=@"минуты";
            }
            else
                minute=@"минут";
        }
        resultString=[NSString stringWithFormat:@"%@ : %@ %@", bridge.name,time,minute ];
        resultString =[resultString uppercaseString];

        [result addObject:resultString];
        
    }
    
    return result;
}

//проверка и замена статуса нужного моста
-(void)ChandeStatys:(NSInteger)index withCalendar:(NSCalendar *)calendar
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComps = [calendar components:(  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    NSInteger hour=currentComps.hour;
    NSInteger min=currentComps.minute;
    OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:index]] ;

    bridge.statys=[bridge OpenWithHour:hour andMin:min];
}

//поиск моста, на который сейчас указывает тач
-(NSInteger)findBridge:(CGPoint)point
{

    for(int i=0;i<10;i++)
    {
        OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:i]] ;
        if(bridge.frame.origin.x-2< point.x&&bridge.frame.origin.x+bridge.frame.size.width+2>point.x&&bridge.frame.origin.y-4<point.y&&bridge.frame.origin.y+bridge.frame.size.height+4>point.y)
        {
            return i;
        }
    }
    return  -1;
}

-(NSInteger)beforeAfterwithCalendar:(NSCalendar *)calendar
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComps = [calendar components:(  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    NSInteger hour=currentComps.hour;
    NSInteger min=currentComps.minute;
    NSInteger minCur=60*(hour-MyhourDif)+min-MyMinDif;;
    int index=-1;
    for(int i=0;i<=20;i++)
    {
        Mytime* timeInter=[timeInterval objectAtIndex:i];
        NSInteger minOp1=timeInter.hourOpen*60+timeInter.minOpen;
        NSInteger minCl1=timeInter.hourClose*60+timeInter.minClose;
        if(minCl1<=minCur && minOp1>minCur)
        {
            index=i;
            break;
        }
    }
    
    return index;

}


-(void)Information:(NSInteger)index
{
//если мост был под тачем то отображаем инфу по нему
if(index>=0)
{
    OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:index]] ;
    
    if (bridge.statys) {
        bridge.image=[UIImage imageNamed:@"bridge_icon_blue1.png"];
    }
    else{
        bridge.image=[UIImage imageNamed:@"bridge_icon_blue0.png"];
    }
    for(int i=0;i<10;i++)
    {
        if(i!=index)
        {
        OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:i]] ;
        if (bridge.statys) {
            bridge.image=[UIImage imageNamed:@"bridge_icon_black1.png"];
        }
        else{
            bridge.image=[UIImage imageNamed:@"bridge_icon_black0.png"];
        }}
    }
    NSString *message =bridge.name;
    self.info.text=message;

    //плавное вылезание информации по мосту
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.info.alpha=1;
    [UIView commitAnimations];
    
}
else
{
    for(int i=0;i<10;i++)
    {
        OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:i]] ;
        if (bridge.statys) {
            bridge.image=[UIImage imageNamed:@"bridge_icon_black1.png"];
        }
        else{
            bridge.image=[UIImage imageNamed:@"bridge_icon_black0.png"];
        }
    }
    self.info.alpha=0;
}

}

-(void)hideBridge:(BOOL)hiden
{
    for(int i=0;i<13;i++)
    {
        
        OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:i]] ;
        if(hiden)
        {
            bridge.hidden=YES;
        }
        else
        {
            bridge.hidden=NO;
        }
    }
    
}

-(UIImage *) findAnnImage:(NSInteger)index
{
    OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:index]] ;
    if (bridge.statys==NO)
    {
        return [UIImage imageNamed: @"annClose.png"];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComps = [calendar components:(  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    NSInteger hour=currentComps.hour;
    NSInteger min=currentComps.minute;
    if([bridge OpenWithHour:hour andMin:min+15]==YES)
        return [UIImage imageNamed: @"annOpen.png"];
    else
        return [UIImage imageNamed: @"annWait.png"];
    
}

-(void)refreshLoad:(BOOL)load
{

    if(load)
    {
        BRAppHelpers *help=[[BRAppHelpers alloc]init];
        [help parsRSSBridge];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSArray *times = [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePaths]];
    
    NSArray * time2= times[1];
    
    NSArray * time1 =times[0];
    
    //Новые данные
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgesInfo"];
    NSArray *newBridgesInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //Массив, отображающий индексы старых данных на индексы новых
    int indexInNew[13] = {0, 1, 4, 5, 6, 7, 8, 3, 2, 10, 11, 12, 9};
    
    for(int i=0;i<10;i++)
    {
        
        [self ChandeStatys:i withCalendar:calendar];
        OneBridge *bridge=[self.bridges objectForKey:[NSNumber numberWithInt:i]] ;
        if (bridge.statys) {
            bridge.image=[UIImage imageNamed:@"bridge_icon_black1.png"];
        }
        else{
            bridge.image=[UIImage imageNamed:@"bridge_icon_black0.png"];
        }
        Mytime * timeFirst=[Mytime MAkeTimeWIthOpenTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).openTime andCloseTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).closeTime];//[time1 objectAtIndex:i];
        Mytime * timeSecond;
        if (((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).isOpenedTwoTimes){
            timeSecond=[Mytime MAkeTimeWIthOpenTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).openTime2 andCloseTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).closeTime2];//[time2 objectAtIndex:i];
        }else {
            timeSecond=[Mytime MAkeTimeWIthOpenTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).openTime andCloseTime:((MHBridgeInfo *)newBridgesInfo[indexInNew[i]]).closeTime];//[time2 objectAtIndex:i];
        }
        bridge.time1=timeFirst;
        bridge.time2=timeSecond;
        if(timeFirst.hourOpen==timeSecond.hourOpen)
        {
            bridge.info=[NSString stringWithFormat:@"Разведен с %@%i-%@%i до %@%i-%@%i",
                         timeFirst.hourClS,timeFirst.hourClose,timeFirst.minClS, timeFirst.minClose,timeFirst.hourOpS, timeFirst.hourOpen,timeFirst.minOpS,timeFirst.minOpen];
        }
        else
        {
            bridge.info=[NSString stringWithFormat:@"Разведен с %@%i-%@%i до %@%i-%@%i,с %@%i-%@%i до %@%i-%@%i",
                         timeFirst.hourClS,timeFirst.hourClose,timeFirst.minClS, timeFirst.minClose,timeFirst.hourOpS, timeFirst.hourOpen,timeFirst.minOpS,timeFirst.minOpen,
                         timeSecond.hourClS,timeSecond.hourClose,timeSecond.minClS, timeSecond.minClose,timeSecond.hourOpS, timeSecond.hourOpen,timeSecond.minOpS,timeSecond.minOpen];
        }
        if(i==1)
        {
          //  NSLog(@"change it! %@",bridge.info);
        }
    }
}

@end
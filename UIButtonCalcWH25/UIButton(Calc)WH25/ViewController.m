//
//  ViewController.m
//  UIButton(Calc)WH25
//
//  Created by Nikolay Berlioz on 22.11.15.
//  Copyright © 2015 Nikolay Berlioz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) double resultVar;

@property (assign, nonatomic) CGFloat firstOperand;
@property (assign, nonatomic) CGFloat secondOperand;

@property (assign, nonatomic) NSInteger operatorVar;

@property (strong, nonatomic) NSString *tempString;

//flags
@property (assign, nonatomic) BOOL operatorFlag;
@property (assign, nonatomic) BOOL equalFlag;
@property (assign, nonatomic) BOOL pointFlag;


@end

@implementation ViewController
{
    BOOL flagOperatorEnabled;
    CGFloat numberIn;
    NSInteger count;
    NSInteger countDigitAfterComa;
    NSInteger totalDigitCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//-----------------------------  Инициализация флагов  -----------------------------------------------
    flagOperatorEnabled = NO;
    count = 1;
    self.resultVar = 0;
    self.operatorFlag = YES;
    self.equalFlag = YES;
    self.pointFlag = NO;
    countDigitAfterComa = 0;
    totalDigitCount = 0;
    
    UIImage *grayButton = [UIImage imageNamed:@"greyButton.png"];// создаем две картинки-фон для нажатых кнопок
    UIImage *blueButton = [UIImage imageNamed:@"blueButton.png"];
    
    for (UIButton *button in self.blueButtonCollection) //каждой кнопке присвиваем это изображение
    {
        [button setBackgroundImage:blueButton forState:UIControlStateHighlighted];
    }
    
    for (UIButton *button in self.grayButtonCollection)
    {
        [button setBackgroundImage:grayButton forState:UIControlStateHighlighted];
    }
}

#pragma mark - Methods

//-----------------------------  Вывод числа на экран в правильном формате  --------------------------
- (NSString*) testString
{
    NSString *string = [NSString stringWithFormat:@"%.18lf", self.resultVar];
    
    //создаем маску из целых чисел, этот алгоритм будет возвращать диапазон первого с конца чилса которое не 0
    NSString *specialCharacterString = @"123456789";
    
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    NSRange range = [string rangeOfCharacterFromSet:specialCharacterSet options:NSBackwardsSearch];
    
    //тут ищем точку и если число целое обрезаем его по точку
    NSRange range2 = [string rangeOfString:@"."];

    if (self.pointFlag) //если нажата запятая
    {
        string = [string substringToIndex:range2.location + countDigitAfterComa + 1];//обрезаем по точку + кол-во знаков после запятой
    }
    else    //иначе
    {
        if (self.resultVar == 0) //если число = 0
        {
            string = [string substringToIndex:range2.location]; //обрезаем по точку
        }
        else    //если число не ноль
        {
            if ((self.resultVar - (int)self.resultVar) != 0) //если число не целое
            {
                string = [string substringToIndex:range.location + 1]; // обрезаем все нули с конца
            }
            else    //если целое
            {
                string = [string substringToIndex:range2.location]; //обрезаем по точку
            }
        }

    }
    
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@","];//ну и как в настоящем калькуляторе заменяем точку запятой
    
    return string;
}

#pragma mark - Actions

//-----------------------------  Ввод цифр  ------------------------------------------------------------
- (IBAction)actionNumberIn:(UIButton *)sender
{
    if (!self.equalFlag)    //если равно в данный момент не доступно, все сбрасывается в ноль, а равно становится доступно
    {
        self.resultVar = 0;
        self.firstOperand = 0;
        self.secondOperand = 0;
        self.equalFlag = YES;
    }
    
    if (totalDigitCount < 18)//если цифр на экране меньше 21
    {
        if (!self.pointFlag)    //если кнопка запятая не нажата, все обычно
        {
            numberIn = sender.tag;
            
            self.resultVar = self.resultVar * 10 + numberIn;
            numberIn = 0;
            totalDigitCount++;
            self.screenLabel.text = [self testString];
        }
        else        //в противном случае другой алгоритм
        {
            numberIn = sender.tag;
            count *= 10;
            numberIn /= count;
            self.resultVar = self.resultVar + numberIn;
            countDigitAfterComa++;
            totalDigitCount++;
            self.screenLabel.text = [self testString];
        }
    }
}


//-----------------------------  Сброс на ноль  -----------------------------------------------
- (IBAction)actionButtonClear:(UIButton *)sender
{
    self.resultVar = 0;
    self.pointFlag = NO; //сбрасывает флаг операции точка
    count = 1; //сброс значения после запятой
    countDigitAfterComa = 0; //сброс кол-ва символов после запятой
    self.tempString = [NSString stringWithFormat:@"%.0f.", self.resultVar];//сбрасываем строку в начальное состояние
    totalDigitCount = 0; //сбрасываем максимальное кол-во цифр
    
    self.screenLabel.text = [self testString];
    
}

//-----------------------------  Нажатие на оператор  -----------------------------------------
- (IBAction)actionOperator:(UIButton *)sender
{
    self.equalFlag = YES; //разблокирует равно
    
    if (self.operatorFlag)   //если флаг оператора йес выполняется все(защита от двойного нажатия на операнд)
    {
        self.firstOperand = self.resultVar;
        self.resultVar = 0;
        switch (sender.tag)
        {
            case 11:    //разделить
                self.operatorVar = 1;
                break;
            case 12:    //умножить
                self.operatorVar = 2;
                break;
            case 13:    //вычесть
                self.operatorVar = 3;
                break;
            case 14:    //прибавить
                self.operatorVar = 4;
                break;
            default:
                break;
        }
        self.operatorFlag = NO; //выключает повторное нажатие на оператор
        self.pointFlag = NO; //сбрасывает флаг операции точка
        count = 1; //сброс значения после запятой
        countDigitAfterComa = 0; //сброс кол-ва символов после запятой
        totalDigitCount = 0; //сбрасываем максимальное кол-во цифр
    }
}

//-----------------------------  Кнопка равно  -----------------------------------------
- (IBAction)actionEqual:(UIButton *)sender
{
    if (self.equalFlag)
    {
        self.secondOperand = self.resultVar;
        
        switch (self.operatorVar)
        {
            case 1:
                self.resultVar = self.firstOperand / self.secondOperand;
                break;
            case 2:
                self.resultVar = self.firstOperand * self.secondOperand;
                break;
            case 3:
                self.resultVar = self.firstOperand - self.secondOperand;
                break;
            case 4:
                self.resultVar = self.firstOperand + self.secondOperand;
                break;
            default:
                break;
        }
        self.equalFlag = NO;//клавиша равно пока не доступна
        self.screenLabel.text = [self testString];
        
        self.firstOperand = 0;  //сброс обоих операндов на ноль
        self.secondOperand = 0;
        
        self.operatorFlag = YES; //оператор опять доступен для нажатия
        self.pointFlag = NO; //сбрасывает флаг операции точка
        count = 1; //сброс значения после запятой
        countDigitAfterComa = 0; //сброс кол-ва символов после запятой
        totalDigitCount = 0; //сбрасываем максимальное кол-во цифр
    }
}

//-----------------------------  Запятая  ---------------------------------------------
- (IBAction)actionPoint:(UIButton *)sender

{
    self.pointFlag = YES;
    
    self.screenLabel.text = [self testString];
}

//-----------------------------  Процент  ---------------------------------------------
- (IBAction)actionPercent:(UIButton *)sender
{
    self.resultVar /= 100;
    self.screenLabel.text = [self testString];
}

//-----------------------------  Знак  ------------------------------------------------
- (IBAction)actionSign:(UIButton *)sender
{
    self.resultVar *= -1;
    self.screenLabel.text = [self testString];
}

@end

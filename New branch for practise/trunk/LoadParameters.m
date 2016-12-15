%Parameters.mat包含系统的所有参数。一次性导入系统后，无需再次加载；如果是运行这个.m文件需要每次都加载；这个.m文件可以用来生成
%Parameters.mat文件。
clc;
clear;
clear all;
%% %%%%%%%加载测试用例%%%%%%%%%%%%
%% 遥控器参数
channelnum=6;%通道总数
%% 加载参数(最好对应全参数)
%全局常量
Discretetime_400Hz=0.0025;%400Hz下的离散时间s
Discretetime_1Hz=1.0;%1Hz下的离散时间s
M_PI=3.141592653589793;%圆周率，这种理论上的常量，要分为一类，统一管理。
DEG_TO_RAD=(M_PI/180.0);%角度弧度转换系数
%PID控制器参数
p_angle_roll=11.8;%roll角度控制P参数
p_angle_pitch=11.8;%pitch角度控制P参数
p_angle_yaw=5.38;%yaw角度控制P参数
Kp_angle=[p_angle_roll;p_angle_pitch;p_angle_yaw];

Cutoff_frequency_roll=20.0;%roll速率控制中d控制前的滤波器参数
Cutoff_frequency_yaw=20.0;%yaw速率控制中d控制前的滤波器参数
roll_rate_kp=0.12;%2.95roll速率控制的pid参数
roll_rate_ki=0.001;%5.5;
roll_rate_kd=0.0027;
yaw_rate_kp=0.45;%yaw速率控制的pid参数
yaw_rate_ki=1.050;
yaw_rate_kd=0.0090;
%Ghost2.0参数
% p_angle_yaw=4.5;%yaw角度控制P参数
% yaw_rate_kp=0.25;%yaw速率控制的pid参数
% yaw_rate_ki=0.020;
% yaw_rate_kd=0.0000;
%% 传感器模型参数
g=[0 0 9.81]';%大地坐标系下重力加速度
dc=[0.55 0 0];%地磁场强度大约是0.5-0.6，单位高斯
%% AHRS系统参数
kalman_Ak=[1 0 0;0 1 0;0 0 1];%状态转移矩阵
kalman_Hk=[1 0 0;0 1 0;0 0 1];%观测矩阵

kalman_Q=0.00000001*[1 0 0;0 1 0;0 0 1];%融合算法中过程噪声协方差矩阵
kalman_R=0.00004*[1 0 0;0 1 0;0 0 1];%融合算法中观测噪声协方差矩阵

kalman_x0=[0;0;0];%初始状态
kalman_p0=[0 0 0;0 0 0;0 0 0];%初始估计误差协方差矩阵
kalman_w=0.07*[1 0 0;0 1 0;0 0 1];%噪声模型中，过程噪声协方差矩阵

kalman_v=0.00004*[1 0 0;0 1 0;0 0 1];%噪声模型中，观测噪声协方差矩阵
kalman_gyro=0.001*[1 0 0;0 1 0;0 0 1];%陀螺仪噪声协方差矩阵
%% PWM计算
%电机布局矩阵
MotorLayout=[  45  -1; %电机1的安装角、旋转方向
             -135  -1; %电机2的安装角、旋转方向
              -45   1; %电机3的安装角、旋转方向
              135   1];%电机4的安装角、旋转方向
thrust_rpyt_up  =[1 1 1 1]';
thrust_rpyt_down=[0 0 0 0]';%thrust_rpyt_out上下限制值

%% 加载仿真输入
% load('euler_roll_angle_cd.mat')%加载输入信号测试
% load('euler_pitch_angle_cd.mat')
% load('euler_yaw_rate_cd.mat')
% save euler_roll_angle_cd
% save euler_pitch_angle_cd
% save euler_yaw_rate_cd
%% try试验
% save M_PI%存为.mat文件夹  
% t=0:0.0025:10;
% y=sin(t);
% y12=[t;y];
% save y12;
% save euler_roll_angle_cd;

%% 四轴模型参数
Mass=1.858;%飞机起飞重量
MomentInertiaTensor=[0.00590195086917869           0 0;
                     0       0.00699358933038145     0;
                     0       0      0.0317149305750431];%飞机转动惯量
motorCoeffs=5*[0.000109093888547525 0.0075590948720063 0.0906095091594229];%电机模型系数
Motor_F=3*1000/70; %时间常数为70ms
QL=0.34;%Ghost2.0轴距34cm
Qlx=QL/2.0*sqrt(1.0/2);%电机对x轴力臂
Qly=Qlx;%电机对y轴力臂

%% 这个以后要根据动力分配矩阵去自动计算，不需要手手动设置
Mxfactor=[1 -1 -1 1];%每个电机对x轴力矩的影响因子
Myfactor=[-1 1 -1 1];%每个电机对y轴力矩的影响因子 
  
%% alt_hold 控制参数
P_pos_z=2.5;   %高度控制P参数
P_vel_z=15.00; %z轴速度控制P参数
P_acc_z=1.0;   %z轴加速度控制P参数
I_acc_z=0.2;   %z轴加速度控制I参数
D_acc_z=0.01;  %z轴加速度控制D参数
Cutoff_frequency_acc_z=20;%z轴加速度控制D之前的滤波器参数
%% poshold
P_pos_x=3.25;
P_vel_x=8;
I_vel_x=1;
D_vel_x=0.3;

P_pos_y=3.25;
P_vel_y=8;
I_vel_y=1;
D_vel_y=0.3;
%% 
%调试用，以后删除

%% 加载数据结构
load BusParameters
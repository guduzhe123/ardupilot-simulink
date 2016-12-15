%Parameters.mat����ϵͳ�����в�����һ���Ե���ϵͳ�������ٴμ��أ�������������.m�ļ���Ҫÿ�ζ����أ����.m�ļ�������������
%Parameters.mat�ļ���
clc;
clear;
clear all;
%% %%%%%%%���ز�������%%%%%%%%%%%%
%% ң��������
channelnum=6;%ͨ������
%% ���ز���(��ö�Ӧȫ����)
%ȫ�ֳ���
Discretetime_400Hz=0.0025;%400Hz�µ���ɢʱ��s
Discretetime_1Hz=1.0;%1Hz�µ���ɢʱ��s
M_PI=3.141592653589793;%Բ���ʣ����������ϵĳ�����Ҫ��Ϊһ�࣬ͳһ����
DEG_TO_RAD=(M_PI/180.0);%�ǶȻ���ת��ϵ��
%PID����������
p_angle_roll=11.8;%roll�Ƕȿ���P����
p_angle_pitch=11.8;%pitch�Ƕȿ���P����
p_angle_yaw=5.38;%yaw�Ƕȿ���P����
Kp_angle=[p_angle_roll;p_angle_pitch;p_angle_yaw];

Cutoff_frequency_roll=20.0;%roll���ʿ�����d����ǰ���˲�������
Cutoff_frequency_yaw=20.0;%yaw���ʿ�����d����ǰ���˲�������
roll_rate_kp=0.12;%2.95roll���ʿ��Ƶ�pid����
roll_rate_ki=0.001;%5.5;
roll_rate_kd=0.0027;
yaw_rate_kp=0.45;%yaw���ʿ��Ƶ�pid����
yaw_rate_ki=1.050;
yaw_rate_kd=0.0090;
%Ghost2.0����
% p_angle_yaw=4.5;%yaw�Ƕȿ���P����
% yaw_rate_kp=0.25;%yaw���ʿ��Ƶ�pid����
% yaw_rate_ki=0.020;
% yaw_rate_kd=0.0000;
%% ������ģ�Ͳ���
g=[0 0 9.81]';%�������ϵ���������ٶ�
dc=[0.55 0 0];%�شų�ǿ�ȴ�Լ��0.5-0.6����λ��˹
%% AHRSϵͳ����
kalman_Ak=[1 0 0;0 1 0;0 0 1];%״̬ת�ƾ���
kalman_Hk=[1 0 0;0 1 0;0 0 1];%�۲����

kalman_Q=0.00000001*[1 0 0;0 1 0;0 0 1];%�ں��㷨�й�������Э�������
kalman_R=0.00004*[1 0 0;0 1 0;0 0 1];%�ں��㷨�й۲�����Э�������

kalman_x0=[0;0;0];%��ʼ״̬
kalman_p0=[0 0 0;0 0 0;0 0 0];%��ʼ�������Э�������
kalman_w=0.07*[1 0 0;0 1 0;0 0 1];%����ģ���У���������Э�������

kalman_v=0.00004*[1 0 0;0 1 0;0 0 1];%����ģ���У��۲�����Э�������
kalman_gyro=0.001*[1 0 0;0 1 0;0 0 1];%����������Э�������
%% PWM����
%������־���
MotorLayout=[  45  -1; %���1�İ�װ�ǡ���ת����
             -135  -1; %���2�İ�װ�ǡ���ת����
              -45   1; %���3�İ�װ�ǡ���ת����
              135   1];%���4�İ�װ�ǡ���ת����
thrust_rpyt_up  =[1 1 1 1]';
thrust_rpyt_down=[0 0 0 0]';%thrust_rpyt_out��������ֵ

%% ���ط�������
% load('euler_roll_angle_cd.mat')%���������źŲ���
% load('euler_pitch_angle_cd.mat')
% load('euler_yaw_rate_cd.mat')
% save euler_roll_angle_cd
% save euler_pitch_angle_cd
% save euler_yaw_rate_cd
%% try����
% save M_PI%��Ϊ.mat�ļ���  
% t=0:0.0025:10;
% y=sin(t);
% y12=[t;y];
% save y12;
% save euler_roll_angle_cd;

%% ����ģ�Ͳ���
Mass=1.858;%�ɻ��������
MomentInertiaTensor=[0.00590195086917869           0 0;
                     0       0.00699358933038145     0;
                     0       0      0.0317149305750431];%�ɻ�ת������
motorCoeffs=5*[0.000109093888547525 0.0075590948720063 0.0906095091594229];%���ģ��ϵ��
Motor_F=3*1000/70; %ʱ�䳣��Ϊ70ms
QL=0.34;%Ghost2.0���34cm
Qlx=QL/2.0*sqrt(1.0/2);%�����x������
Qly=Qlx;%�����y������

%% ����Ժ�Ҫ���ݶ����������ȥ�Զ����㣬����Ҫ���ֶ�����
Mxfactor=[1 -1 -1 1];%ÿ�������x�����ص�Ӱ������
Myfactor=[-1 1 -1 1];%ÿ�������y�����ص�Ӱ������ 
  
%% alt_hold ���Ʋ���
P_pos_z=2.5;   %�߶ȿ���P����
P_vel_z=15.00; %z���ٶȿ���P����
P_acc_z=1.0;   %z����ٶȿ���P����
I_acc_z=0.2;   %z����ٶȿ���I����
D_acc_z=0.01;  %z����ٶȿ���D����
Cutoff_frequency_acc_z=20;%z����ٶȿ���D֮ǰ���˲�������
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
%�����ã��Ժ�ɾ��

%% �������ݽṹ
load BusParameters
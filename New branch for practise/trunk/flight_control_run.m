%% ���зɿط���
close all; clc; clear all;
%% ���ز���%���ط�������
LoadParameters
%% ����ģʽ����
%����ģʽ 1/2/3  stabilize/althold/poshold,ѡ��ģʽ����Ӧ����Ӧ�Ĳ������ݡ�
flight_mode=1;
%1Ϊ��ͷģʽ 2Ϊ��ͷģʽ
simple_mode=2;
%% Simulink �����������
starttime_selfdefine=0.0;%���濪ʼʱ��
endtime_selfdefine=12.0;%�������ʱ�䣬���ڲ����źŵ�10�������ʷ���ʱ�䲻Ҫ����10s
%���з���ģ��
sim('Flight_Control_System',[starttime_selfdefine,endtime_selfdefine]);
%log����
LogData_Plot
%% end
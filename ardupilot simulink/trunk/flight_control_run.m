%% 运行飞控仿真

%% 加载参数%加载仿真用例
LoadParameters
%% 飞行模式设置
%飞行模式 1/2/3  stabilize/althold/poshold,选择模式后会对应有相应的测试数据。
flight_mode=1;
%1为有头模式 2为无头模式
simple_mode=2;
%% Simulink 仿真参数设置
starttime_selfdefine=0.0;%仿真开始时间
endtime_selfdefine=12.0;%仿真结束时间，由于测试信号到10结束，故仿真时间不要超过10s
%运行仿真模型
sim('Flight_Control_System',[starttime_selfdefine,endtime_selfdefine]);
%log分析
LogData_Plot
%% end
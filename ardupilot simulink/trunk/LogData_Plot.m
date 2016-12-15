%% stabilize 姿态调试绘图
i=0;
if flight_mode==1
%姿态角度曲线

i=i+1;
figure(i)
plot(system_time.signals.values,[tar_angle.signals.values,cur_angle.signals.values])
xlabel('时间[s]')
ylabel('姿态角度[radian]')
h=legend('roll-tar','pitch-tar','yaw-tar','roll-cur','pitch-cur','yaw-cur');

%roll控制调试log
i=i+1;
figure(i)
% plot(system_time.signals.values,roll_rate_kpid_out.signals.values)
% xlabel('时间[s]')
% ylabel('姿态角度[radian]')
% h=legend('Kp','Ki','Kd',3);
%plot(system_time.signals.values,[tar_angle.signals.values(:,1),cur_angle.signals.values(:,1),roll_rate_kpid_out.signals.values])
plot(system_time.signals.values,[roll_rate_kpid_out.signals.values])
xlabel('时间[s]')
ylabel('roll姿态角速度[radian/s]')
h=legend('Kp','Ki','Kd','rate_tar','rate_cur');

%yaw控制调试log
i=i+1;
figure(i)
plot(system_time.signals.values,[yaw_rate_kpid_out.signals.values])
xlabel('时间[s]')
ylabel('yaw姿态角速度[radian/s]')
h=legend('Kp','Ki','Kd','rate_tar','rate_cur');
end 
%% 飞机状态信息绘图
%遥控器输出信号
i=i+1;
figure(i)
plot([rc_out.signals.values])
xlabel('时间[s]')
ylabel('遥控器通道输出信号')
%h=legend('ch1','ch2','ch3','ch4','ch5','ch6',6);
h=legend('ch1','ch2','ch3','ch4','ch5','ch6');
%飞机位移曲线
i=i+1;
figure(i)
plot([NED_x_out.signals.values])
xlabel('时间[s]')
ylabel('飞机位移[x]')
h=legend('x','y','z');
%飞机姿态曲线
i=i+1;
figure(i)
plot([NED_a_out.signals.values])
xlabel('时间[s]')
ylabel('飞机姿态[radian]')
h=legend('roll','pitch','yaw');
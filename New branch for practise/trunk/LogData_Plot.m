%% stabilize ��̬���Ի�ͼ
i=0;
if flight_mode==1
%��̬�Ƕ�����

i=i+1;
figure(i)
plot(system_time.signals.values,[tar_angle.signals.values,cur_angle.signals.values])
xlabel('ʱ��[s]')
ylabel('��̬�Ƕ�[radian]')
h=legend('roll-tar','pitch-tar','yaw-tar','roll-cur','pitch-cur','yaw-cur');

%roll���Ƶ���log
i=i+1;
figure(i)
% plot(system_time.signals.values,roll_rate_kpid_out.signals.values)
% xlabel('ʱ��[s]')
% ylabel('��̬�Ƕ�[radian]')
% h=legend('Kp','Ki','Kd',3);
%plot(system_time.signals.values,[tar_angle.signals.values(:,1),cur_angle.signals.values(:,1),roll_rate_kpid_out.signals.values])
plot(system_time.signals.values,[roll_rate_kpid_out.signals.values])
xlabel('ʱ��[s]')
ylabel('roll��̬���ٶ�[radian/s]')
h=legend('Kp','Ki','Kd','rate_tar','rate_cur');

%yaw���Ƶ���log
i=i+1;
figure(i)
plot(system_time.signals.values,[yaw_rate_kpid_out.signals.values])
xlabel('ʱ��[s]')
ylabel('yaw��̬���ٶ�[radian/s]')
h=legend('Kp','Ki','Kd','rate_tar','rate_cur');
end 
%% �ɻ�״̬��Ϣ��ͼ
%ң��������ź�
i=i+1;
figure(i)
plot([rc_out.signals.values])
xlabel('ʱ��[s]')
ylabel('ң����ͨ������ź�')
%h=legend('ch1','ch2','ch3','ch4','ch5','ch6',6);
h=legend('ch1','ch2','ch3','ch4','ch5','ch6');
%�ɻ�λ������
i=i+1;
figure(i)
plot([NED_x_out.signals.values])
xlabel('ʱ��[s]')
ylabel('�ɻ�λ��[x]')
h=legend('x','y','z');
%�ɻ���̬����
i=i+1;
figure(i)
plot([NED_a_out.signals.values])
xlabel('ʱ��[s]')
ylabel('�ɻ���̬[radian]')
h=legend('roll','pitch','yaw');
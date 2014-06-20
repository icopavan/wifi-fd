% SISO��LS�ز�����
M = 16; % QAM���ƽ���
N = 1000000;% ���Ÿ���
SIRdB=30;%���ű�
SNRdB=45;%�����
%�����ź�
tx_near_code = randint(N,1,M);
tx_near=modulate(modem.qammod(M),tx_near_code);
tx_near_noise=awgn(tx_near,SNRdB,'measured');


%Զ���ź�
tx_far_code = randint(N,1,M);
tx_far=modulate(modem.qammod(M),tx_far_code)/10^(SIRdB/20);%�����źű�Զ���ź�ǿ
tx_far_noise=awgn(tx_far,SNRdB,'measured');%�����źű�Զ���ź�ǿ
tx_signal=tx_near_noise+tx_far_noise;

%�����������12bit
tmp=tx_signal(:);
tmp=round(tmp*2048)/2048;
tx_signal=tmp(:);



%LS�ŵ�����
H_est=inv(tx_near'*tx_near)*tx_near'*tx_signal;
%�����źŹ���
tx_est=tx_near*H_est;
%�ӽ����ź��м�ȥ�����ź�
tx_ec=tx_signal-tx_est;

%���ƽ��յ���QAM����
%scatterplot(tx_signal);
%scatterplot(tx_ec);
% ���
z=demodulate(modem.qamdemod(M),tx_ec*10^(SIRdB/20));

% �����ʺ��������
[Num_err_symbol,sym_err_rate]= symerr(tx_far_code,z)
[Num_err_bit,bit_err_rate]= biterr(tx_far_code,z)
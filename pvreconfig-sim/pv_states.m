function [states, labels] = pv_states()
%PV_STATES  16 trạng thái của 4 công tắc nối chéo [S1 S2 S3 S4] và nhãn.
%   states(1,:) = [0 0 0 0] = SP, states(16,:) = [1 1 1 1] = TCT.
%   BL theo Fig. 4e của Ref 3 (nối chéo xen kẽ giữa các mức) -> [1 0 0 1] với 3 cột.
%   HC với 3 cột chưa xác nhận từ tài liệu; tạm gán bản đối xứng [0 1 1 0].

states = dec2bin(0:15) - '0';
labels = cell(16, 1);
for k = 1:16
    labels{k} = ['S=' sprintf('%d', states(k,:))];
end
labels{bin2dec('0000') + 1} = 'SP';
labels{bin2dec('1111') + 1} = 'TCT';
labels{bin2dec('1001') + 1} = 'BL';
labels{bin2dec('0110') + 1} = 'HC?';
end

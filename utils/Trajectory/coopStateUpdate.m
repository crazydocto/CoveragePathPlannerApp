%% coopStateUpdate - 更新合作航行状态
%
% 功能描述：
%   根据给定的路径单元数组、障碍物信息和路径规划参数，更新AUV的合作航行状态。
%
% 输入参数：
%   TrajSeqCell - 可用路径的单元数组
%   state       - AUV的航行路径信息结构体
%   ObsInfo     - 障碍物信息矩阵
%   Property    - 路径规划参数结构体
%
% 输出参数：
%   state       - 更新后的AUV航行路径信息结构体
%
% 版本信息：
%   当前版本：v1.1
%   创建日期：241101
%   最后修改：250110
%
% 作者信息：
%   作者：Chihong（游子昂）
%   邮箱：you.ziang@hrbeu.edu.cn
%   作者：董星犴
%   邮箱：1443123118@qq.com
%   单位：哈尔滨工程大学

function State = coopStateUpdate(TrajSeqCell,State,ObsInfo,Property)

[~,n]=size(TrajSeqCell);                                    % Obtain the number of paths
State.trajLength=zeros(n,1);                               % Initialize the array of path length
State.TrajSeqCell=TrajSeqCell;                              % Save cell array of available paths for the AUV

%% Obtain path information
for i=1:n                                                   % Traverse each path
   length=trajLength(TrajSeqCell{1,i});                    % Calculate path length
   State.trajLength(i,1)=length;                           % Save path length

   %% Obtain the longest and shortest flight paths
   if i==1                                                  % If it is the first path
       State.trajLength_max=length;                        % update longest path length
       State.trajLength_min=length;                        % update shortest path length
   end
   if length>State.trajLength_max
       State.trajLength_max=length;                        % update longest path length
   end
   if length<State.trajLength_min
       State.trajLength_min=length;                        % update shortest path length
   end

   %% The expected path length should be within the interval of two basic path lengths
   % Find the path that is shorter than and closest to the expected path length (Call is as "bottom" path)
   if length<State.ideal_length
       if State.traj_index_bottom==0
           State.traj_index_bottom=i;
       elseif length>State.trajLength...
               (State.traj_index_bottom)
           State.traj_index_bottom=i;
       end
   end
   % Find the path that is longer than and closest to the expected path length (Call is as "top" path)
   if length>State.ideal_length
       if State.traj_index_top==0
           State.traj_index_top=i;
       elseif length<State.trajLength...
               (State.traj_index_top)
           State.traj_index_top=i;
       end
   end
end

%% Generate cooperative path
% In the absence of a 'bottom' path, directly output the 'top' path
if State.traj_index_bottom==0
    State.TrajSeq_Coop=State.TrajSeqCell{State.traj_index_top};
    State.optim_length=trajLength(State.TrajSeq_Coop);
    return;
end

TrajSeq=State.TrajSeqCell{State.traj_index_bottom};
[m,~]=size(TrajSeq);
invasion_bottom=0;
for i=1:m
    if TrajSeq(i,32)==1
       invasion_bottom=1;
    end
end

if invasion_bottom==1
    TrajSeq_new=TrajSeq;
    flag=1;
else
    % Use particle swarm optimization algorithm to adjust the radius of the starting and ending arcs of each path segments, 
    % so that the path length is as close as possible to the expected path length
    [TrajSeq_new,flag]=trajPSO(TrajSeq,State,ObsInfo,Property);
end

if flag==0
    TrajSeq_new=TrajSeq;
end

length_bottom=trajLength(TrajSeq_new);                     % Caluculate the "bottom" path length

if State.traj_index_top~=0                                  % In the presence of a 'top' path
    length_top=trajLength...                               % Caluculate the "top" path length
        (State.TrajSeqCell{State.traj_index_top});
    % Compare the "bottom" path and the "top" path to see which one has the closest length to the expected path length
    if abs(length_bottom-State.ideal_length) > abs(length_top-State.ideal_length)
        % Store the path with the closest length in TrajSeq_Cop
        State.TrajSeq_Coop=State.TrajSeqCell{State.traj_index_top};
    else                                                    
        State.TrajSeq_Coop=TrajSeq_new;                     
    end
% There is no 'top' path, and the expected path length is greater than all path lengths
else
    % No need to compare, simply set the optimized path as a cooperative path
    State.TrajSeq_Coop=TrajSeq_new;                        
end

State.optim_length=trajLength(State.TrajSeq_Coop);         % Calculate the cooperative path length
end


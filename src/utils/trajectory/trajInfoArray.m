%% trajInfoArray - 将Dubins路径信息和路径上的障碍物信息存储到数组中
%
% 功能描述：
%   将Dubins路径信息和路径上的障碍物信息存储到一个数组中。
%
% 输入参数：
%   dubins_info - Dubins路径信息
%   ObsSeries   - 障碍物编号数组
%   Property    - 路径规划参数结构体
%
% 输出参数：
%   TrajInfo    - 路径信息数组
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

function TrajInfo = trajInfoArray(dubins_info,ObsSeries,Property)

TrajInfo=zeros(1,Property.Info_length);
[~,c]=size(ObsSeries);                                      % Obtain the length of the obstacle array
count=0;
for j=1:c                                                   % Traverse every element in the obstacle array
    if ObsSeries(1,j)==0                                    % If the obstacle number is 0, it means that no subsequent elements have been recorded
        break;
    end
    count=count+1;                                          % Accumulate counter
end
%% Starting information
TrajInfo(1,1)=dubins_info.traj.type;                        % Type of Dubins path
TrajInfo(1,2)=dubins_info.start.x;                          % Starting point x coordinate
TrajInfo(1,3)=dubins_info.start.y;                          % Starting point y coordinate
TrajInfo(1,4)=dubins_info.start.phi;                        % Starting heading angle
TrajInfo(1,5)=dubins_info.start.R;                          % Starting arc radius
TrajInfo(1,6)=dubins_info.start.phi_c;                      % Starting point azimuth angle
TrajInfo(1,7)=dubins_info.start.xc;                         % Starting arc center x coordinate
TrajInfo(1,8)=dubins_info.start.yc;                         % Starting arc center y coordinate
TrajInfo(1,9)=dubins_info.start.phi_ex;                     % Cutting out azimuth angle
TrajInfo(1,10)=dubins_info.start.x_ex;                      % Cutting out point x coordinate
TrajInfo(1,11)=dubins_info.start.y_ex;                      % Cutting out point y coordinate
TrajInfo(1,12)=dubins_info.start.psi;                       % Travel angle on the starting arc

%% Ending information
TrajInfo(1,13)=dubins_info.finish.x;                        % Ending point x coordinate
TrajInfo(1,14)=dubins_info.finish.y;                        % Ending point y coordinate
TrajInfo(1,15)=dubins_info.finish.phi;                      % Ending heading angle
TrajInfo(1,16)=dubins_info.finish.R;                        % Ending arc radius
TrajInfo(1,17)=dubins_info.finish.phi_c;                    % Ending point azimuth angle
TrajInfo(1,18)=dubins_info.finish.xc;                       % Ending arc center x coordinate
TrajInfo(1,19)=dubins_info.finish.yc;                       % Ending arc center y coordinate
TrajInfo(1,20)=dubins_info.finish.phi_en;                   % Cutting in azimuth angle
TrajInfo(1,21)=dubins_info.finish.x_en;                     % Cutting in point x coordinate
TrajInfo(1,22)=dubins_info.finish.y_en;                     % Cutting in point y coordinate
TrajInfo(1,23)=dubins_info.finish.psi;                      % Travel angle on the ending arc

%% Path length
TrajInfo(1,24)=dubins_info.traj.length; 

%% Obstacle information
TrajInfo(1,25)=0;                                           % The number of the obstacle to be avoided currently
TrajInfo(1,26)=count;                                       % Number of obstacles intersect with path 
TrajInfo(1,27)=ObsSeries(1,1);                              % 1st Obstacle number
TrajInfo(1,28)=ObsSeries(1,2);                              % 2nd Obstacle number
TrajInfo(1,29)=ObsSeries(1,3);                              % 3rd Obstacle number
TrajInfo(1,30)=ObsSeries(1,4);                              % 4th Obstacle number
TrajInfo(1,31)=ObsSeries(1,5);                              % 5th Obstacle number

%% Other information
TrajInfo(1,32)=Property.invasion;                           % Flag of intrusion the threat circle
TrajInfo(1,33)=0;                                           % Flag of reach the endpoint

end


%% plotTrajCoop - 绘制所有UAV的备选路径和合作路径
%
% 功能描述：
%   绘制所有UAV的备选路径和合作路径。
%
% 输入参数：
%   Coop_State - UAV路径信息的单元数组
%   ObsInfo    - 障碍物信息矩阵
%   Property   - 路径规划参数结构体
%   flag       - 绘制备选路径的选项，0: 不绘制；1: 绘制
%   demo       - 示例索引
%
% 版本信息：
%   当前版本：v1.1
%   创建日期：241101
%   最后修改：250110
%
% 作者信息：
%   作者：董星犴
%   邮箱：1443123118@qq.com
%   单位：哈尔滨工程大学
function Plot_Traj_Coop(Coop_State,ObsInfo,Property,flag,demo)
%% Initialize information 
[~,n]=size(Coop_State);
scale=Property.scale;                                               % Set the drawing scale
px=zeros(1,2*n);
py=zeros(1,2*n);
figure;
hold on;

%% Plot obstacles
theta=0:0.05:2*pi;
[obs_num,~]=size(ObsInfo);
for i=1:obs_num
    xo_temp=ObsInfo(i,1)+ObsInfo(i,3)*cos(theta);
    yo_temp=ObsInfo(i,2)+ObsInfo(i,3)*sin(theta);
    o1=plot(xo_temp*scale,yo_temp*scale,'r');
    o1.LineWidth=1.5;
    s=sprintf('%d',i);
    text(ObsInfo(i,1)*scale,ObsInfo(i,2)*scale,s);
end

%% Plot the path and its starting and ending points
for i=1:n
    if flag==1                                                      % Plot alternative paths
        [~,m]=size(Coop_State(i).TrajSeqCell);                      % Obtain the path number in TrajSeqCell
        for j=1:m                                                   % Traverse each path
            [Traj_x,Traj_y]=Traj_Discrete...                        % Obtain a discretized waypoint sequence
                (Coop_State(i).TrajSeqCell{j},Property);
            hold on;
            l2=plot(Traj_x*scale,Traj_y*scale,'b');                 % Plot alternative path
            l2.LineWidth=1;                                         % Set the path width
            %l2.Color=[1 1 1]*0.7;                                  % Grey opaque mode, transparency does not overlap
            l2.Color(4)=0.3;                                        % Gray transparent mode, transparency will be overlaid
        end
    end
    [~,c]=size(Traj_x);                                             % Obtain the number of discrete waypoints
    px(i)=Traj_x(1);                                                % Obtain the starting point x coordinate
    py(i)=Traj_y(1);                                                % Obtain the starting point y coordinate
    px(n+i)=Traj_x(c);                                              % Obtain the ending point x coordinate
    py(n+i)=Traj_y(c);                                              % Obtain the ending point y coordinate
end
pt=scatter(px*scale,py*scale,80);                                   % Plot starting and ending points
pt.MarkerFaceColor='r';
pt.MarkerEdgeColor='k';

for i=1:n                                                           % Plot cooperative path of each UAV
    [Traj_x,Traj_y]=Traj_Discrete...
        (Coop_State(i).TrajSeq_Coop,Property);                      % Obtain the discrete waypoints sequence
    hold on;
    l1=plot(Traj_x*scale,Traj_y*scale,'k');                         % Plot cooperative path
    l1.LineWidth=1.5;                                               % Set the path width
end

max_points = max(cellfun(@length, {Coop_State.TrajSeq_Coop})); % 假设TrajSeq_Coop是单元数组
all_x = NaN(max_points, length(Coop_State));
all_y = NaN(max_points, length(Coop_State));

for i = 1:length(Coop_State)
    [Traj_x, Traj_y] = Traj_Discrete(Coop_State(i).TrajSeq_Coop, Property);
    all_x(1:length(Traj_x), i) = Traj_x;
    all_y(1:length(Traj_y), i) = Traj_y;
end

% 将所有路径点写入CSV文件
csv_filename = 'all_uav_paths.csv';
writematrix([all_x(:), all_y(:)], csv_filename);

data = readtable('all_uav_paths.csv');

% 删除含有NaN的行
data_cleaned = rmmissing(data);

% 保存处理后的CSV文件
writetable(data_cleaned, 'cleaned_file.csv');

% 读取原始CSV文件
data = readmatrix('cleaned_file.csv');

% 假设数据中第一列是x坐标，第二列是y坐标
x = data(:, 1);
y = data(:, 2);

% 找到有效的路径点（即x和y都不为0的点）
valid_idx = find(x ~= 0 & y ~= 0);

% 使用有效的索引过滤数据
x_valid = x(valid_idx);
y_valid = y(valid_idx);

% 将清洗后的数据合并回一个矩阵，如果需要的话
valid_data = [x_valid, y_valid];

% 将清洗后的数据写入新的CSV文件
new_filename = 'filtered_uav_paths.csv';
writematrix(valid_data, new_filename);

% 指定CSV文件路径
csvFilePath = 'filtered_uav_paths.csv'; % 请替换为您的CSV文件路径

% 读取CSV文件
data = readtable(csvFilePath);

% 获取数据的行数
numRows = height(data);

% 初始化一个空表格来存储结果
result = data(1, :); % 假设第一行不是重复的，先添加到结果中

% 遍历数据，比较每一行与其下一行
for i = 1:numRows-1
    if ~isequal(data(i, :), data(i+1, :))
        % 如果当前行与下一行不同，则添加到结果表格中
        result = [result; data(i+1, :)];
    end
end

% 将结果保存到新的CSV文件中
resultFilePath = 'result_no_duplicates.csv'; % 结果文件的保存路径
writetable(result, resultFilePath);



%% Set figure parameters
% switch demo
%     case 1
%         set(gcf,'unit','inches','position',[0,0,6,4.5]);
%         xlim([-150,600]); 
%         ylim([-250,350]);
%     case 2
%         set(gcf,'unit','inches','position',[0,0,12,4]);
%         xlim([-50,1050]);
%         ylim([-100,300]);
% end

set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('$X/m$','Interpreter','latex');
ylabel('$Y/m$','Interpreter','latex');
zlabel('$Y/m$','Interpreter','latex');
grid on;
box on;
L=legend([l1,l2,o1],{'Path-Cooperative',...
    'Path-Alternative','Threaten Area'});
L.Location='northeast';
L.FontSize=12;

end


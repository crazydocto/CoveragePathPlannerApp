    % 障碍物标记
    %
    % 功能描述：
    %   此函数用于从地形高度图中检测障碍物，并标记每个障碍物的最小外接圆。
    %   它加载高度图数据，生成障碍物地图，计算每个障碍物的外接圆，并将结果保存到.mat文件中。
    %
    % 输入参数：
    %   app - AUVCoveragePathPlannerApp的实例
    %
    % 输出参数：
    %   无直接输出，结果通过UI界面显示，并保存到.mat文件中
    %
    % 注意事项：
    %   1. 确保.mat文件存在且格式正确。
    %   2. 该函数会更新UI界面中的按钮状态。
    %
    % 版本信息：
    %   版本：v1.1
    %   创建日期：241101
    %   最后修改：250110
    %
    % 作者信息：
    %   作者：董星犴
    %   邮箱：1443123118@qq.com
    %   单位：哈尔滨工程大学
function obstaclemarking(app)
%% Obstacle circumscribed circle

% 加载.mat文件中的数据
filename = 'terrainHeightMap_feed8_2000.mat'; % 将 'data.mat' 替换为你的.mat文件名
loadedData = load(filename);

% 检查加载的数据是什么类型，并列出所有字段名称
if isstruct(loadedData)
    disp('Loaded data is a struct. Available fields:');
    fieldnames(loadedData) % 列出所有字段名称
else
    disp('Loaded data is not a struct.');
end

% 假设我们知道矩阵的字段名称为 'matrixData'
% 如果不确定，请根据上面输出的字段名称进行替换
matrixFieldName = 'terrainHeightMap'; % 将 'matrixData' 替换为实际的字段名

% 提取矩阵
if isfield(loadedData, matrixFieldName)
    heightData = loadedData.(matrixFieldName);
else
    error(['Field "', matrixFieldName, '" not found in the loaded data.']);
end

% 定义障碍物阈值（根据你的具体需求设定）
threshold = 3.2; % 你可以调整这个值

% 创建障碍物地图
obstacleMap = heightData > threshold;

% % 显示原始高度图和障碍物地图
% figure;
% subplot(1, 2, 1);
% imagesc(heightData);
% title('Original Height Data');
% colorbar;
% axis equal;
% 
% subplot(1, 2, 2);
% imagesc(obstacleMap);
% title('Obstacle Map');
% colorbar;
% axis equal;


% 假设已经加载了 heightData 和创建了 obstacleMap

% 将障碍物地图转换为二值图像
obstacleBW = double(obstacleMap);

% 标记连通区域（每个障碍物）
[L, numObstacles] = bwlabel(obstacleBW);

% 初始化用于存储所有圆心坐标和半径的数组
centers = zeros(numObstacles, 2);
radii = zeros(numObstacles, 1);

% figure;
% imagesc(app.UIAxes3,heightData);
% hold(app.UIAxes3, 'on');
% title('Original Height Data with Circumscribed Circles');
% colorbar;
% axis equal;

% 绘制高度数据
imagesc(app.UIAxes3, heightData);

% 保持当前图形，以便在上面添加其他元素
hold(app.UIAxes3, 'on');

% 添加标题
title(app.UIAxes3, '地形图及障碍物标注');

% 添加颜色条
colorbar(app.UIAxes3);
colormap(app.UIAxes3, 'jet'); % 使用 'jet' 色彩映射
caxis(app.UIAxes3, [-30 30]);
% 设置坐标轴比例为相等
axis(app.UIAxes3, 'equal');


for i = 1:numObstacles
    % 提取当前障碍物区域的所有点
    [rows, cols] = find(L == i);
    
    % 计算最小外接圆 (初始估算)
    stats = regionprops(L == i, 'Centroid', 'MajorAxisLength');
    center = stats.Centroid;
    radius = stats.MajorAxisLength / 2; % 使用主轴长度的一半作为半径估计
    
    % 检查并调整半径，确保所有点都在圆内
    for j = 1:length(rows)
        distance = sqrt((cols(j) - center(1))^2 + (rows(j) - center(2))^2);
        if distance > radius
            radius = distance;
        end
    end
    
    % 存储当前圆的信息
    centers(i, :) = center;
    radii(i) = radius;
    
    % 绘制当前圆
    th = linspace(0, 2*pi, 100);
    x_circle = center(1) + radius * cos(th);
    y_circle = center(2) + radius * sin(th);
    plot(app.UIAxes3,x_circle, y_circle, 'r-', 'LineWidth', 2); % 绘制圆周
    plot(app.UIAxes3,center(1), center(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2); % 绘制圆心
end

% hold off;

% 显示原始高度图、原始障碍物地图以及外接圆后的障碍物地图
% figure;
% subplot(1, 3, 1);
% imagesc(heightData);
% title('Original Height Data');
% colorbar;
% axis equal;
% 
% subplot(1, 3, 2);
% imagesc(obstacleMap);
% title('Original Obstacle Map');
% colorbar;
% axis equal;
% 
% subplot(1, 3, 3);
% imshow(app.UIAxes3,obstacleMap, []);改
% imshow(obstacleMap, [], 'Parent', app.UIAxes3);
hold(app.UIAxes3,'on');
for i = 1:numObstacles
    % 再次绘制所有圆
    th = linspace(0, 2*pi, 100);
    x_circle = centers(i, 1) + radii(i) * cos(th);
    y_circle = centers(i, 2) + radii(i) * sin(th);
    plot(app.UIAxes3,x_circle, y_circle, 'r-', 'LineWidth', 2); % 绘制圆周
    plot(app.UIAxes3,centers(i, 1), centers(i, 2), 'r+', 'MarkerSize', 10, 'LineWidth', 2); % 绘制圆心
end
% title('Obstacles with Circumscribed Circles');
% colorbar;
% axis equal;


% 假设 numObstacles 已经被正确初始化为障碍物的数量

% 创建一个矩阵用于保存每个圆的信息
% 每一行表示一个圆：[CenterX, CenterY, Radius]
circlesInfo = zeros(numObstacles, 3);

for i = 1:numObstacles
%     绘制当前圆 (这部分代码保持不变)
%     th = linspace(0, 2*pi, 100);
%     x_circle = centers(i, 1) + radii(i) * cos(th);
%     y_circle = centers(i, 2) + radii(i) * sin(th);
%     plot(x_circle, y_circle, 'r-', 'LineWidth', 2); % 绘制圆周
%     plot(centers(i, 1), centers(i, 2), 'r+', 'MarkerSize', 10, 'LineWidth', 2); % 绘制圆心

    % 将当前圆的信息添加到矩阵中
    circlesInfo(i, :) = [centers(i, 1), centers(i, 2), radii(i)];
end

% 定义要保存的数据文件名
filename = 'circlesInformation.mat';

% 使用 save 函数保存数据到 .mat 文件
save(filename, 'circlesInfo');

disp(['圆的信息已保存至文件: ', filename]);

% 显示原始高度图、原始障碍物地图以及外接圆后的障碍物地图
% ... 之后的代码保持不变 ...

end
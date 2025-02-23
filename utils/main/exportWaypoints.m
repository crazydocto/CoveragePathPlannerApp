%% exportWaypoints - AUV路径点数据导出工具
%
% 功能描述：
%   将生成的AUV路径点数据导出为CSV格式文件，支持数值型和单元格型数据的
%   导出，包含坐标、航向角和转弯半径信息。通过图形界面交互实现文件保存。
%
% 作者信息：
%   作者：Chihong（游子昂）
%   邮箱：you.ziang@hrbeu.edu.cn
%   单位：哈尔滨工程大学
%
% 版本信息：
%   当前版本：v1.1
%   创建日期：241101
%   最后修改：250110
%
% 版本历史：
%   v1.1 (250110)
%       + 增加数据类型自动检测
%       + 添加默认保存路径处理
%       + 优化错误处理机制
%   v1.0 (241101)
%       + 首次发布
%       + 实现基础路径点导出
%       + 添加用户界面交互
%
% 输入参数：
%   app - [object] AUVCoveragePathPlannerApp实例
%         必选参数，包含以下关键属性：
%         - Waypoints: [nx4 double] 路径点数据
%           [X坐标, Y坐标, 航向角theta, 转弯半径r]
%         - StatusLabel: [UILabel] 状态显示标签
%
% 输出参数：
%   无直接返回值，结果通过以下方式输出：
%   1. CSV文件：保存路径点数据
%   2. UI反馈：状态标签更新
%   3. 消息框：操作结果提示
%
% 注意事项：
%   1. 数据格式：路径点必须为nx4矩阵
%   2. 存储路径：默认在data目录下
%   3. 文件命名：默认为CSV_waypoints.csv
%   4. 权限要求：需要写入权限
%
% 调用示例：
%   % 在APP中调用导出功能
%   app = AUVCoveragePathPlannerApp;
%   app.Waypoints = [0,0,0,5; 10,0,0,5; 10,10,pi/2,5];
%   exportWaypoints(app);
%
% 依赖函数：
%   - writematrix
%   - writecell
%   - writetable
%   - array2table
%
% 参见函数：
%   importWaypoints, generateCombPath

function exportWaypoints(app)
    if ~isempty(app.Waypoints)
        try
            % 创建表格
            T = array2table(app.Waypoints, 'VariableNames', {'X', 'Y','theta','r'});
            
            % 获取保存文件名，添加默认路径处理
            % 提取数据
            data = app.Waypoints; % 从 app 对象中获取数据
            
            % 检查数据类型
            if iscell(data)
                % 如果数据是单元格数组，使用 writecell
                saveFunction = @writecell;
            elseif isnumeric(data)
                % 如果数据是数值矩阵，使用 writematrix
                saveFunction = @writematrix;
            else
                error('数据类型不支持保存为 CSV 文件。');
            end
            
            % 生成目标文件路径
            defaultPath = fullfile(pwd, 'data', 'CSV_waypoints.csv');
            
            % 确保目标文件夹存在，如果不存在则创建
            if ~exist(fullfile(pwd, 'data'), 'dir')
                mkdir(fullfile(pwd, 'data'));
            end
            
            % 调用保存函数
            saveFunction(data, defaultPath);
            
            % 提示用户
            disp(['数据已保存到: ', defaultPath]);
            defaultPath = fullfile(pwd, 'CSV_waypoints.csv');
            [filename, pathname] = uiputfile({'*.csv', 'CSV文件 (*.csv)'}, '保存路径点', defaultPath);
            
            if filename ~= 0
                % 保存到CSV文件
                fullPath = fullfile(pathname, filename);
                try
                    writetable(T, fullPath);
                    % 更新状态
                    app.StatusLabel.Text = '已成功导出规划路径数据！';
                    app.StatusLabel.FontColor = [0 0.5 0];
                    msgbox(sprintf('路径点已成功导出到:\n%s', fullPath), '导出成功');
                catch saveErr
                    app.StatusLabel.Text = '保存文件失败！';
                    app.StatusLabel.FontColor = [0.8 0 0];
                    errordlg(sprintf('保存文件失败:\n%s', saveErr.message), '保存错误');
                    return;
                end
            end
        catch ME
            errordlg(sprintf('导出错误:\n%s', ME.message), '错误');
        end
    else
        app.StatusLabel.Text = '没有可导出的路径点数据！';
        app.StatusLabel.FontColor = [0.8 0 0];
        return;
    end
end
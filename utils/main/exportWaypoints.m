%% exportWaypoints - AUV路径点数据导出工具
%
% 功能描述：
%   将生成的AUV路径点数据导出为CSV格式文件。支持以下功能：
%   1. CSV格式数据导出
%   2. 自动创建存储目录
%   3. 文件命名规范化
%   4. 实时状态反馈
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
%   v1.1 (250110) - 优化数据导出机制，改进用户界面
%   v1.0 (241101) - 首次发布，实现基本导出功能
%
% 输入参数：
%   app - [object] AUVCoveragePathPlannerApp实例
%         包含以下关键属性：
%         - Waypoints: [nx4 double] 路径点数据
%         - StatusLabel: [UILabel] 状态显示标签
%
% 输出参数：
%   无直接返回值，结果通过以下方式输出：
%   1. CSV文件：保存路径点数据
%   2. UI反馈：状态标签更新
%   3. 消息框：操作结果提示
%
% 注意事项：
%   1. 确保输入数据格式为nx4矩阵
%   2. 检查目标文件夹写入权限
%   3. 注意文件命名规范
%
% 依赖函数：
%   - writematrix
%   - writetable
%   - array2table
%
% 参见函数：
%   importMapData, generatePath

function exportWaypoints(app)
    if ~isempty(app.Waypoints)
        try
            % 创建表格
            T = array2table(app.Waypoints, 'VariableNames', {'X', 'Y','theta','r'});
            
            % 设置默认保存路径为 app.currentFolderPath/data
            defaultPath = fullfile(app.currentFolderPath, 'data');
            
            % 如果目录不存在则创建
            if ~(exist(defaultPath, 'dir'))
                mkdir(defaultPath);
            end
            
            % 设置默认文件名
            defaultFileName = fullfile(defaultPath, 'CSV_waypoints.csv');
            
            % 获取保存文件名
            [filename, pathname] = uiputfile({'*.csv', 'CSV文件 (*.csv)'}, ...
                '保存路径点', defaultFileName);
            
            if filename ~= 0
                % 完整路径
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
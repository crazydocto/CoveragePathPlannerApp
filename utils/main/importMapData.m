    % 导入地图数据
    %
    % 功能描述：
    %   此函数用于从用户选择的.mat文件中导入地图数据，并将其复制到应用程序的目录中。
    %   用户通过文件选择对话框选择文件，文件将被复制到应用程序的目录中。
    %
    % 输入参数：
    %   app - AUVCoveragePathPlannerApp的实例
    %
    % 输出参数：
    %   无直接输出，结果通过UI界面显示
    %
    % 注意事项：
    %   1. 确保用户选择的文件存在且格式正确。
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
function importMapData(app)
    % 获取文件名
    [filename, pathname] = uigetfile('*.mat', '选择地图数据文件');
    
    if isequal(filename, 0) || isequal(pathname, 0)
        % 用户取消操作
        app.StatusLabel.Text = '导入操作已取消';
        return;
    end

    % 完整路径
    fullPath = fullfile(pathname, filename);

    % 获取 CoveragePathPlannerApp.m 文件所在的目录
    appDir = fileparts(mfilename('fullpath'));

    % 目标路径
    targetPath = fullfile(appDir, filename);

    % 复制文件
    try
        copyfile(fullPath, targetPath);
        app.StatusLabel.Text = ['文件已成功导入到: ' targetPath];
    catch copyErr
        app.StatusLabel.Text = ['导入失败: ' copyErr.message];
    end
    app.obstaclemarkingButton.Enable = 'on';
end
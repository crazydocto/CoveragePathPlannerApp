%% sendDubinsTCPData - 发送局部路径规划数据到AUV
%
% 功能描述：
%   根据设置的服务器IP和端口，将局部路径规划数据发送到AUV设备。
%
% 输入参数：
%   app - AUVCoveragePathPlannerApp的实例
%
% 版本信息：
%   当前版本：v1.1
%   创建日期：241101
%   最后修改：250110
%
% 作者信息：
%   作者：Chihong（游子昂）
%   邮箱：you.ziang@hrbeu.edu.cn
%   作者：Chihong（游子昂）
%   邮箱：you.ziang@hrbeu.edu.cn
%   作者：董星犴
%   邮箱：1443123118@qq.com
%   单位：哈尔滨工程大学

function sendDubinsTCPData(app)

    % 获取TCP设置
    serverIP = app.ServerIPEditField.Value;
    port = app.PortEditField.Value;
    app.SendTCPButton.Enable = false;

    if isempty(serverIP) || isempty(port)
        app.TotalLengthLabelandTCP.Text = '请输入有效的IP地址和端口';
        app.TotalLengthLabelandTCP.FontColor = [0.8 0 0];
        app.SendTCPButton.Enable = true;
        return;
    end

    % 显示连接中状态
    app.TotalLengthLabelandTCP.Text = '正在尝试连接...';
    app.TotalLengthLabelandTCP.FontColor = [0.8 0.8 0];
    drawnow; % 立即更新UI

    % 设置10秒超时
    try
        client = tcpclient(serverIP, port, 'Timeout', 10, 'ConnectTimeout', 10);
        
        % 连接成功
        app.TotalLengthLabelandTCP.Text = 'TCP连接成功';
        app.TotalLengthLabelandTCP.FontColor = [0 0.5 0];
    catch tcpErr
        % 区分超时和其他错误
        if contains(tcpErr.message, 'Timeout') || contains(tcpErr.message, 'timed out')
            app.TotalLengthLabelandTCP.Text = '连接超时，请检查目标设备是否开启';
        else
            app.TotalLengthLabelandTCP.Text = sprintf('TCP连接失败: %s\n请检查IP地址和端口设置', tcpErr.message);
        end
        app.TotalLengthLabelandTCP.FontColor = [0.8 0 0];
        app.SendTCPButton.Enable = true;
        return;
    end

    % 获取初始位置和姿态角
    try
        P0 = [app.P0XEditField.Value, app.P0YEditField.Value, app.P0ZEditField.Value];
        A0 = [app.A0XEditField.Value, app.A0YEditField.Value, app.A0ZEditField.Value];
        
        % 获取Waypoints和添加Z坐标列
        WPNum = size(result_no_duplicates, 1);
        zero_column = zeros(WPNum, 1);
        result_no_duplicates = [result_no_duplicates, zero_column];
        
        % 创建数据结构
        dataStruct = struct('Waypoints', result_no_duplicates, ...
                            'WPNum', WPNum, ...
                            'P0', P0, ...
                            'A0', A0);
        
        % 转换为JSON
        jsonData = jsonencode(dataStruct);
    catch dataErr
        app.TotalLengthLabelandTCP.Text = ['数据准备失败: %s', dataErr.message];   
        app.TotalLengthLabelandTCP.FontColor = [0.8 0 0];
        app.SendTCPButton.Enable = true;
        return;
    end
    
    % 发送数据
    try
        flush(client);
        write(client, jsonData, 'string');
        % 更新状态
        app.StatusLabel.Text = '规划路径数据发送成功！';
        app.StatusLabel.FontColor = [0 0.5 0];
    catch writeErr
        app.StatusLabel.Text = ['数据发送失败: %s', writeErr.message];
        app.StatusLabel.FontColor = [0.8 0 0];
        app.SendTCPButton.Enable = true;
        return;
    end
    app.SendTCPButton.Enable = true;
end
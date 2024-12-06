function sendTCPData(app)

    % 获取TCP设置
    serverIP = app.ServerIPEditField.Value;
    port = app.PortEditField.Value;
    app.SendTCPButton.Enable = false;

    if isempty(serverIP) || isempty(port)
        app.TotalLengthLabelandTCP.Text = '请输入有效的IP地址和端口';
        app.TotalLengthLabelandTCP.FontColor = [0.8 0 0];
        return;
    end

    % % 创建TCP客户端配置
    % try
    %     client = tcpclient(serverIP, port);
    %     app.TotalLengthLabelandTCP.Text = ('TCP连接成功');
    %     app.TotalLengthLabelandTCP.FontColor = [0 0.5 0];
    % catch tcpErr
    %     app.TotalLengthLabelandTCP.Text = ['TCP连接失败: %s\n请检查IP地址和端口设置', tcpErr.message];
    %     app.TotalLengthLabelandTCP.FontColor  = [0.8 0 0];
    %     return;
    % end 
    % 创建TCP客户端配置
    try
        % 显示连接中状态
        app.TotalLengthLabelandTCP.Text = '正在尝试连接...';
        app.TotalLengthLabelandTCP.FontColor = [0.8 0.8 0];
        drawnow; % 立即更新UI

        % 设置10秒超时
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

    try
        % 获取初始位置和姿态角
        P0 = [app.P0XEditField.Value, app.P0YEditField.Value, app.P0ZEditField.Value];
        A0 = [app.A0XEditField.Value, app.A0YEditField.Value, app.A0ZEditField.Value];
        
        % 获取Waypoints和添加Z坐标列
        WPNum = size(app.Waypoints, 1);
        zero_column = zeros(WPNum, 1);
        Waypoints = [app.Waypoints, zero_column];
        
        % 创建数据结构
        dataStruct = struct('Waypoints', Waypoints, ...
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
        flush(client)
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
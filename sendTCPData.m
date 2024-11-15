function sendTCPData(app)
    try
        % 获取TCP设置
        serverIP = app.ServerIPEditField.Value;
        port = app.PortEditField.Value;
        
        % 设置TCP连接超时
        timeout = 10; % 5秒超时
        
        % 创建TCP客户端配置
        try
            client = tcpclient(serverIP, port, 'Timeout', timeout);
        catch tcpErr
            error('TCP连接失败: %s\n请检查IP地址和端口设置', tcpErr.message);
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
            error('数据准备失败: %s', dataErr.message);
        end
            
        % 发送数据
        try
            
            write(client, jsonData, 'string');
            % 更新状态
            app.StatusLabel.Text = '规划路径数据发送成功！';
            app.StatusLabel.FontColor = [0 0.5 0];
        catch writeErr
            error('数据发送失败: %s', writeErr.message);
        end

    catch ME
        % 错误处理
        app.StatusLabel.Text = ['规划路径数据发送失败: ' ME.message];
        app.StatusLabel.FontColor = [0.8 0 0];
        errordlg(ME.message, '发送错误');
    end
end
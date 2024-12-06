function generatePath(app)
    % 收集GUI中的参数
    startPoint = [app.XEditField.Value, app.YEditField.Value];
    lineSpacing = app.LineSpacingEditField.Value;
    pathWidth = app.PathWidthEditField.Value;
    numLines = app.NumLinesEditField.Value;
    direction = lower(app.DirectionDropDown.Value);
    
    % 调用路径生成函数
    try
        % 清除当前axes
        cla(app.UIAxes);
        
        % 生成路径
        app.Waypoints = generateCombPath(app, startPoint, lineSpacing, pathWidth, numLines, direction);
        
        % 将路径点保存到基础工作区
        assignin('base', 'Waypoints', app.Waypoints);
        
        % 手动绘制路径
        plot(app.UIAxes, app.Waypoints(:,1), app.Waypoints(:,2), 'b-', 'LineWidth', 2);
        hold(app.UIAxes, 'on');
        
        % 绘制路径点
        plot(app.UIAxes, app.Waypoints(:,1), app.Waypoints(:,2), 'bo', 'MarkerSize', 6);
        
        % 绘制起点（绿色方块）
        plot(app.UIAxes, app.Waypoints(1,1), app.Waypoints(1,2), 'gs', 'MarkerSize', 10, 'LineWidth', 2);
        
        % 绘制终点（红色方块）
        plot(app.UIAxes, app.Waypoints(end,1), app.Waypoints(end,2), 'rs', 'MarkerSize', 10, 'LineWidth', 2);
        
        % 计算总长度
        totalLength = 0;
        for i = 1:size(app.Waypoints,1)-1
            totalLength = totalLength + norm(app.Waypoints(i+1,:) - app.Waypoints(i,:));
        end
        
        % 更新总长度标签
        app.TotalLengthLabelandTCP.Text = sprintf('总路径长度: %.1f 米', totalLength);
        
        % 设置图形属性
        grid(app.UIAxes, 'on');
        xlabel(app.UIAxes, 'X轴 (米)');
        ylabel(app.UIAxes, 'Y轴 (米)');
        title(app.UIAxes, sprintf('AUV梳状覆盖路径规划图 (%s方向)', upper(direction)));
        legend(app.UIAxes, '路径', '路径点', '起点', '终点');
        axis(app.UIAxes, 'equal');
        hold(app.UIAxes, 'off');
        
        % 启用导出按钮和TCP发送按钮
        app.ExportButton.Enable = 'on';
        app.SendTCPButton.Enable = 'on';
        
    catch ME
        % 错误处理
        errordlg(['路径生成错误: ' ME.message], '错误');
    end
end
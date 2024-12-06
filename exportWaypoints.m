function exportWaypoints(app)
    if ~isempty(app.Waypoints)
        try
            % 创建表格
            T = array2table(app.Waypoints, 'VariableNames', {'X', 'Y'});
            
            % 获取保存文件名，添加默认路径处理
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
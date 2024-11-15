classdef CoveragePathPlannerApp < matlab.apps.AppBase
    % 生成 AUV 海底探测梳状全覆盖路径拐点
    % 输出：AUV 梳状全覆盖路径拐点坐标，格式为.csv/.mat
    % 为避免重复造轮子，有优化需求请联系游子昂，统一安排迭代升级
    %
    % 版本：1.1
    % 时间：20241101
    %

    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        StartPointPanel          matlab.ui.container.Panel
        XEditField               matlab.ui.control.NumericEditField
        XEditFieldLabel          matlab.ui.control.Label
        YEditField               matlab.ui.control.NumericEditField
        YEditFieldLabel          matlab.ui.control.Label
        PathParametersPanel      matlab.ui.container.Panel
        LineSpacingEditField     matlab.ui.control.NumericEditField
        LineSpacingEditFieldLabel  matlab.ui.control.Label
        PathWidthEditField       matlab.ui.control.NumericEditField
        PathWidthEditFieldLabel  matlab.ui.control.Label
        NumLinesEditField        matlab.ui.control.NumericEditField
        NumLinesEditFieldLabel   matlab.ui.control.Label
        DirectionDropDown        matlab.ui.control.DropDown
        DirectionDropDownLabel   matlab.ui.control.Label
        
        % 新增的初始化面板
        InitPanel          matlab.ui.container.Panel

        % 新增初始位置和姿态角面板
        P0XEditField             matlab.ui.control.NumericEditField
        P0XLabel                 matlab.ui.control.Label
        P0YEditField             matlab.ui.control.NumericEditField
        P0YLabel                 matlab.ui.control.Label
        P0ZEditField             matlab.ui.control.NumericEditField
        P0ZLabel                 matlab.ui.control.Label
        
        A0XEditField            matlab.ui.control.NumericEditField
        A0XLabel                matlab.ui.control.Label
        A0YEditField            matlab.ui.control.NumericEditField
        A0YLabel                matlab.ui.control.Label
        A0ZEditField            matlab.ui.control.NumericEditField
        A0ZLabel                matlab.ui.control.Label
        
        % 新增TCP设置面板
        TCPPanel                matlab.ui.container.Panel
        ServerIPEditField       matlab.ui.control.EditField
        ServerIPLabel           matlab.ui.control.Label
        PortEditField           matlab.ui.control.NumericEditField
        PortLabel               matlab.ui.control.Label
        
        GenerateButton          matlab.ui.control.Button
        SendTCPButton          matlab.ui.control.Button % 新增TCP发送按钮
        UIAxes                  matlab.ui.control.UIAxes
        TotalLengthLabel       matlab.ui.control.Label
        StatusLabel            matlab.ui.control.Label % 新增状态显示标签
        ExportButton           matlab.ui.control.Button
        Waypoints
    end

    methods (Access = private)
        function createComponents(app)
            % 主窗口设置
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 1200 800];
            app.UIFigure.Name = 'AUV全覆盖梳状路径拐点生成器1.1（单位：m）';
            
            % 1. 坐标初始化面板
            app.InitPanel = uipanel(app.UIFigure);
            app.InitPanel.Title = '相关坐标初始化';
            app.InitPanel.Position = [30 470 320 240];
            
            % 起始点坐标
            uilabel(app.InitPanel, 'Text', '规划路径起始点坐标:', 'Position', [10 190 120 22]);
            
            app.XEditFieldLabel = uilabel(app.InitPanel);
            app.XEditFieldLabel.Position = [10 160 25 22];
            app.XEditFieldLabel.Text = ' X:';
            app.XEditFieldLabel.HorizontalAlignment = 'center';
            
            app.XEditField = uieditfield(app.InitPanel, 'numeric');
            app.XEditField.Position = [50 160 80 22];
            app.XEditField.Value = 60;
            app.XEditField.HorizontalAlignment = 'center';
            
            app.YEditFieldLabel = uilabel(app.InitPanel);
            app.YEditFieldLabel.Position = [150 160 25 22];
            app.YEditFieldLabel.Text = ' Y:';
            app.YEditFieldLabel.HorizontalAlignment = 'center';
            
            app.YEditField = uieditfield(app.InitPanel, 'numeric');
            app.YEditField.Position = [190 160 80 22];
            app.YEditField.Value = 90;
            app.YEditField.HorizontalAlignment = 'center';
            
            % 初始位置
            uilabel(app.InitPanel, 'Text', 'AUV初始位置:', 'Position', [10 115 100 22]);
            
            app.P0XLabel = uilabel(app.InitPanel);
            app.P0XLabel.Position = [10 85 35 22];
            app.P0XLabel.Text = ' X:';
            app.P0XLabel.HorizontalAlignment = 'center';
            
            app.P0XEditField = uieditfield(app.InitPanel, 'numeric');
            app.P0XEditField.Position = [50 85 50 22];
            app.P0XEditField.Value = 0;
            app.P0XEditField.HorizontalAlignment = 'center';
            
            app.P0YLabel = uilabel(app.InitPanel);
            app.P0YLabel.Position = [110 85 35 22];
            app.P0YLabel.Text = ' Y:';
            app.P0YLabel.HorizontalAlignment = 'center';
            
            app.P0YEditField = uieditfield(app.InitPanel, 'numeric');
            app.P0YEditField.Position = [150 85 50 22];
            app.P0YEditField.Value = 0;
            app.P0YEditField.HorizontalAlignment = 'center';
            
            app.P0ZLabel = uilabel(app.InitPanel);
            app.P0ZLabel.Position = [210 85 35 22];
            app.P0ZLabel.Text = ' Z:';
            app.P0ZLabel.HorizontalAlignment = 'center';
            
            app.P0ZEditField = uieditfield(app.InitPanel, 'numeric');
            app.P0ZEditField.Position = [250 85 50 22];
            app.P0ZEditField.Value = 0;
            app.P0ZEditField.HorizontalAlignment = 'center';
            
            % 初始姿态角
            uilabel(app.InitPanel, 'Text', 'AUV初始姿态角:', 'Position', [10 40 100 22]);
            
            app.A0XLabel = uilabel(app.InitPanel);
            app.A0XLabel.Position = [10 10 35 22];
            app.A0XLabel.Text = ' Roll:';
            app.A0XLabel.HorizontalAlignment = 'center';
            
            app.A0XEditField = uieditfield(app.InitPanel, 'numeric');
            app.A0XEditField.Position = [50 10 50 22];
            app.A0XEditField.Value = 0;
            app.A0XEditField.HorizontalAlignment = 'center';
            
            app.A0YLabel = uilabel(app.InitPanel);
            app.A0YLabel.Position = [110 10 35 22];
            app.A0YLabel.Text = ' Pitch:';
            app.A0YLabel.HorizontalAlignment = 'center';
            
            app.A0YEditField = uieditfield(app.InitPanel, 'numeric');
            app.A0YEditField.Position = [150 10 50 22];
            app.A0YEditField.Value = 0;
            app.A0YEditField.HorizontalAlignment = 'center';
            
            app.A0ZLabel = uilabel(app.InitPanel);
            app.A0ZLabel.Position = [210 10 35 22];
            app.A0ZLabel.Text = ' Yaw:';
            app.A0ZLabel.HorizontalAlignment = 'center';
            
            app.A0ZEditField = uieditfield(app.InitPanel, 'numeric');
            app.A0ZEditField.Position = [250 10 50 22];
            app.A0ZEditField.Value = 0;
            app.A0ZEditField.HorizontalAlignment = 'center';
            
            % 2. 路径参数面板
            app.PathParametersPanel = uipanel(app.UIFigure);
            app.PathParametersPanel.Title = '路径参数';
            app.PathParametersPanel.Position = [30 310 320 140];
            
            % 方向选择
            app.DirectionDropDownLabel = uilabel(app.PathParametersPanel);
            app.DirectionDropDownLabel.Position = [35 95 80 22];
            app.DirectionDropDownLabel.Text = '路径方向:';
            
            app.DirectionDropDown = uidropdown(app.PathParametersPanel);
            app.DirectionDropDown.Items = {'                    X        ', '                    Y         '};  % 通过添加空格实现视觉居中
            app.DirectionDropDown.Position = [115 95 175 22];
            app.DirectionDropDown.Value = '                    Y         ';  % 需要匹配Items中的完整字符串
            
            % 梳状齿间距
            app.LineSpacingEditFieldLabel = uilabel(app.PathParametersPanel);
            app.LineSpacingEditFieldLabel.Position = [35 65 80 22];
            app.LineSpacingEditFieldLabel.Text = '梳状齿间距:';
            
            app.LineSpacingEditField = uieditfield(app.PathParametersPanel, 'numeric');
            app.LineSpacingEditField.Position = [115 65 150 22];
            app.LineSpacingEditField.Value = 200;
            app.LineSpacingEditField.HorizontalAlignment = 'center';
            
            % 路径宽度
            app.PathWidthEditFieldLabel = uilabel(app.PathParametersPanel);
            app.PathWidthEditFieldLabel.Position = [35 35 80 22];
            app.PathWidthEditFieldLabel.Text = '路径宽度:';
            
            app.PathWidthEditField = uieditfield(app.PathParametersPanel, 'numeric');
            app.PathWidthEditField.Position = [115 35 150 22];
            app.PathWidthEditField.Value = 1000;
            app.PathWidthEditField.HorizontalAlignment = 'center';
            
            % 梳状路径数量
            app.NumLinesEditFieldLabel = uilabel(app.PathParametersPanel);
            app.NumLinesEditFieldLabel.Position = [35 5 80 22];
            app.NumLinesEditFieldLabel.Text = '路径数量:';
            
            app.NumLinesEditField = uieditfield(app.PathParametersPanel, 'numeric');
            app.NumLinesEditField.Position = [115 5 150 22];
            app.NumLinesEditField.Value = 6;
            app.NumLinesEditField.HorizontalAlignment = 'center';
            
            % 3. TCP设置面板
            app.TCPPanel = uipanel(app.UIFigure);
            app.TCPPanel.Title = 'TCP设置';
            app.TCPPanel.Position = [30 200 320 90];
            
            % TCP控件布局
            app.ServerIPLabel = uilabel(app.TCPPanel);
            app.ServerIPLabel.Position = [35 40 60 22];
            app.ServerIPLabel.Text = '服务器IP:';
            
            app.ServerIPEditField = uieditfield(app.TCPPanel);
            app.ServerIPEditField.Position = [95 40 170 22];
            app.ServerIPEditField.Value = '192.168.1.108';
            app.ServerIPEditField.HorizontalAlignment = 'center';
            
            app.PortLabel = uilabel(app.TCPPanel);
            app.PortLabel.Position = [35 10 60 22];
            app.PortLabel.Text = '端口:';
            
            app.PortEditField = uieditfield(app.TCPPanel, 'numeric');
            app.PortEditField.Position = [95 10 170 22];
            app.PortEditField.Value = 5000;
            app.PortEditField.HorizontalAlignment = 'center';
            
            % 4. 按钮组和状态标签
            app.GenerateButton = uibutton(app.UIFigure, 'push');
            app.GenerateButton.ButtonPushedFcn = @(~,~) generatePath(app);
            app.GenerateButton.Position = [30 150 320 30];
            app.GenerateButton.Text = '生成规划路径';
            
            app.ExportButton = uibutton(app.UIFigure, 'push');
            app.ExportButton.ButtonPushedFcn = @(~,~) exportWaypoints(app);
            app.ExportButton.Position = [30 110 320 30];
            app.ExportButton.Text = '导出规划路径点(csv格式)';
            app.ExportButton.Enable = 'off';
            
            app.SendTCPButton = uibutton(app.UIFigure, 'push');
            app.SendTCPButton.ButtonPushedFcn = @(~,~) sendTCPData(app);
            app.SendTCPButton.Position = [30 70 320 30];
            app.SendTCPButton.Text = '发送规划路径数据到AUV';
            app.SendTCPButton.Enable = 'off';

            % 总路径长度
            app.TotalLengthLabel = uilabel(app.UIFigure);
            app.TotalLengthLabel.Position = [30 40 320 22];
            app.TotalLengthLabel.Text = '总路径长度: 0.0 米';
            app.TotalLengthLabel.HorizontalAlignment = 'center';
            
            % 状态标签
            app.StatusLabel = uilabel(app.UIFigure);
            app.StatusLabel.Position = [30 10 320 30];
            app.StatusLabel.Text = '还未生成规划路径数据！';
            app.StatusLabel.HorizontalAlignment = 'center';
            app.StatusLabel.FontColor = [0.8 0 0];
            
            % 绘图区域
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [400 20 780 780];
            title(app.UIAxes, 'AUV规划路径效果图');
            xlabel(app.UIAxes, 'X轴 (米)');
            ylabel(app.UIAxes, 'Y轴 (米)');
            grid(app.UIAxes, 'on');
        end
    
        % 添加启动和关闭时的清理代码
        function startup(app)
            try
                % 设置默认工作目录
                if ~isdeployed % 如果不是已编译的版本
                    cd(fileparts(mfilename('fullpath')));
                else
                    [status, result] = system('echo %TEMP%');
                    if status == 0
                        tempDir = strtrim(result);
                        cd(tempDir);
                    end
                end
                
                % 初始化状态
                app.StatusLabel.Text = '还未生成规划路径数据！';
                app.StatusLabel.FontColor = [0.8 0 0];
                
            catch ME
                warning('启动初始化失败:', '%s', ME.message);
            end
        end
        
        function cleanup(app)
            try
                % 清理任何打开的TCP连接
                if isfield(app, 'tcpClient') && isvalid(app.tcpClient)
                    clear app.tcpClient;
                end
            catch
                % 忽略清理错误
            end
        end
    end 

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CoveragePathPlannerApp
            % 创建组件
            createComponents(app)
            
            % 初始化属性
            app.Waypoints = [];
            
            % 运行启动代码
            startup(app)
            
            % 显示界面
            app.UIFigure.Visible = 'on';
        end

        % 修改删除函数，添加清理代码
        function delete(app)
            % 运行清理代码
            cleanup(app)
            
            % 删除界面
            delete(app.UIFigure)
        end
    end
end
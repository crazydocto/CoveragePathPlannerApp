% setupAppPaths - 项目路径设置脚本
%
% 在编译或运行应用程序前运行此脚本，以确保所有必要的文件夹都在搜索路径中

function setupAppPaths()
    % 获取当前脚本所在的目录
    currentDir = fileparts(mfilename('fullpath'));
    
    % 定义需要编译进应用程序的核心文件夹
    pathsToAdd = {
        fullfile(currentDir, 'utils')      % 工具函数目录
    };
    
    % 添加核心文件夹到搜索路径
    for i = 1:length(pathsToAdd)
        if exist(pathsToAdd{i}, 'dir')
            addpath(pathsToAdd{i});
            fprintf('已添加路径: %s\n', pathsToAdd{i});
        else
            warning('文件夹不存在: %s', pathsToAdd{i});
            % 创建不存在的文件夹
            mkdir(pathsToAdd{i});
            addpath(pathsToAdd{i});
            fprintf('已创建并添加路径: %s\n', pathsToAdd{i});
        end
    end
    
    % 创建外部数据文件夹（如果不存在）
    dataDir = fullfile(currentDir, '..', 'data');  % 移到上级目录
    if ~exist(dataDir, 'dir')
        mkdir(dataDir);
        fprintf('已创建外部数据文件夹: %s\n', dataDir);
    end
    
    fprintf('路径设置完成！\n');
end

%% dubinsSelectionLength - Dubins路径长度选择工具
%
% 功能描述：
%   在给定的Dubins路径集合中选择最短路径，通过比较路径长度更新最小长度
%   和对应的路径索引。
%
% 作者信息：
%   作者：Chihong（游子昂）
%   邮箱：you.ziang@hrbeu.edu.cn
%   作者：董星犴
%   邮箱：1443123118@qq.com
%   单位：哈尔滨工程大学
%
% 版本信息：
%   当前版本：v1.1
%   创建日期：241101
%   最后修改：250110
%
% 版本历史：
%   v1.0 (241101) - 首次发布
%       + 实现基础的路径长度比较功能
%       + 支持路径索引更新
%   v1.1 (250110) - 功能优化
%       + 添加长度为0的特殊情况处理
%       + 优化代码结构和注释
%
% 输入参数：
%   TrajCollect - [n×24 double] AUV路径信息矩阵
%                 必选参数，包含多条可选Dubins路径的完整信息
%   length_min  - [double] 当前已知的最小路径长度
%                 必选参数，用于比较和更新
%   index      - [int] 当前最短路径的索引
%                必选参数，范围>0
%   i          - [int] 当前待评估路径的索引
%                必选参数，范围>0
%
% 输出参数：
%   length_min - [double] 更新后的最小路径长度
%   index     - [int] 更新后的最短路径索引
%
% 注意事项：
%   1. TrajCollect矩阵第24列必须存储路径长度信息
%   2. 输入的索引值必须为正整数且不超过路径集合大小
%   3. 长度为0的路径将被忽略
%
% 调用示例：
%   % 示例：在路径集合中查找最短路径
%   [min_len, best_idx] = dubinsSelectionLength(traj_data, current_min, current_idx, 5);
%
% 参见函数：
%   dubinsPathGenerator, dubinsDiscret

function [length_min,index] = dubinsSelectionLength(TrajCollect,length_min,index,i)
    length=TrajCollect(i,24);

    if length==0
        return;
    end

    if length_min==0
        length_min=length;
        index=i;
    end

    if length_min>length
        length_min=length;
        index=i;
    end
end


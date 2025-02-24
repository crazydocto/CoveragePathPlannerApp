%% dubinsDiscret - Dubins路径离散化为航路点序列
%
% 功能描述：
%   将计算的Dubins路径信息离散化为航路点序列，支持LSL、RSR、LSR、RSL四种
%   Dubins路径类型的离散化处理。
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
%       + 实现基础的Dubins路径离散化功能
%       + 支持四种标准Dubins路径类型
%   v1.1 (250110) - 功能优化
%       + 优化了直线段离散化的处理逻辑
%       + 添加了特殊情况的处理
%
% 输入参数：
%   dubins_info  - [struct] Dubins路径信息结构体
%                  必选参数，包含起始点、终止点、路径类型等信息
%   ns           - [int] 起始圆弧离散点数
%                  必选参数，范围>0
%   nl           - [int] 直线段离散点数
%                  必选参数，范围>0
%   nf           - [int] 终止圆弧离散点数
%                  必选参数，范围>0
%
% 输出参数：
%   dubins_x     - [1×n double] 离散航路点x坐标序列
%   dubins_y     - [1×n double] 离散航路点y坐标序列
%
% 注意事项：
%   1. dubins_info结构体必须包含完整的路径信息
%   2. 离散点数参数必须为正整数
%   3. 输出序列长度约等于ns+nl+nf
%
% 调用示例：
%   % 示例：将Dubins路径离散化为50个点
%   [x_seq, y_seq] = dubinsDiscret(dubins_path, 20, 10, 20);
%
% 参见函数：
%   dubinsPathGenerator, calculateDubinsPath

function [dubins_x,dubins_y] = dubinsDiscret(dubins_info,ns,nl,nf)
    % 根据起始和终止位置以及速度方向的确定，
    % Dubins路径共有四种类型：
    % (1) LSL (左-直线-左), (2) RSR (右-直线-右)
    % (3) LSR (左-直线-右), (4) RSL (右-直线-左)

    circle_centre_start_param = [-1, 1,-1, 1];                  % -1表示左转(L), 1表示右转(R)
    circle_centre_finish_param =[-1, 1, 1,-1];                  % -1表示左转(L), 1表示右转(R)
    param_s=circle_centre_start_param(dubins_info.traj.type);   % 起始圆弧中心计算参数
    param_f=circle_centre_finish_param(dubins_info.traj.type);  % 终止圆弧中心计算参数

    %% 将起始圆弧离散为航路点序列
    xc_s=dubins_info.start.xc;                                  % 起始圆弧中心x坐标
    yc_s=dubins_info.start.yc;                                  % 起始圆弧中心y坐标
    R_s=dubins_info.start.R;                                    % 起始圆弧半径
    phi_sc=dubins_info.start.phi_c;                             % 起始点方位角
    % phi_ex=dubins_info.start.phi_ex;                          % 切出点方位角
    psi_s=dubins_info.start.psi;                                % 起始圆弧行程角

    if psi_s==0
        phi_s_temp=phi_sc;
    else
        d_phi_s=-param_s*psi_s/ns;                              % 计算起始圆弧离散角度大小
        phi_s_temp=phi_sc:d_phi_s:phi_sc-param_s*psi_s;         % 离散化起始圆弧行程角
    end

    dubins_xs=xc_s+R_s*cos(phi_s_temp);                         % 计算起始圆弧上航路点x坐标序列
    dubins_ys=yc_s+R_s*sin(phi_s_temp);                         % 计算起始圆弧上航路点y坐标序列

    %% 将终止圆弧离散为航路点序列
    xc_f=dubins_info.finish.xc;                                 % 终止圆弧中心x坐标
    yc_f=dubins_info.finish.yc;                                 % 终止圆弧中心y坐标
    R_f=dubins_info.finish.R;                                   % 终止圆弧半径
    % phi_fc=dubins_info.finish.phi_c;                          % 终止点方位角
    phi_en=dubins_info.finish.phi_en;                           % 切入点方位角
    psi_f=dubins_info.finish.psi;                               % 终止圆弧行程角

    if psi_f==0
        phi_f_temp=phi_en;
    else
        d_phi_f=-param_f*psi_f/nf;                              % 计算终止圆弧离散角度大小
        phi_f_temp=phi_en:d_phi_f:phi_en-param_f*psi_f;         % 离散化终止圆弧行程角
    end
    dubins_xf=xc_f+R_f*cos(phi_f_temp);                         % 计算终止圆弧上航路点x坐标序列
    dubins_yf=yc_f+R_f*sin(phi_f_temp);                         % 计算终止圆弧上航路点y坐标序列

    %% 将直线段离散为航路点序列
    x_ex=dubins_info.start.x_ex;                                % 切出点x坐标
    y_ex=dubins_info.start.y_ex;                                % 切出点y坐标
    x_en=dubins_info.finish.x_en;                               % 切入点x坐标
    y_en=dubins_info.finish.y_en;                               % 切入点y坐标

    if x_en==x_ex&&y_en==y_ex                                   % 直线段长度为0的情况
        dubins_xl=x_ex;
        dubins_yl=y_ex;
    elseif x_en==x_ex&&y_en~=y_ex                               % 直线段垂直于x轴的情况
        dubins_yl=y_ex:(y_en-y_ex)/nl:y_en;
        [~,m]=size(dubins_yl);
        dubins_xl=zeros(1,m)+x_en;
    elseif x_en~=x_ex&&y_en==y_ex                               % 直线段垂直于y轴的情况
        dubins_xl=x_ex:(x_en-x_ex)/nl:x_en;
        [~,m]=size(dubins_xl);
        dubins_yl=zeros(1,m)+y_en;
    else
        dubins_xl=x_ex:(x_en-x_ex)/nl:x_en;                     % 计算直线段上航路点x坐标序列
        dubins_yl=y_ex:(y_en-y_ex)/nl:y_en;                     % 计算直线段上航路点y坐标序列
    end

    %% 合成完整航路点序列
    dubins_x=[dubins_xs,dubins_xl,dubins_xf];
    dubins_y=[dubins_ys,dubins_yl,dubins_yf];
end


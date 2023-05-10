function the_end = Kekule( t1, t2, half_nx, ny )

% 计算矩阵的总行数
nx = half_nx * 2;

% 计算六角晶格数量
N = nx * ny;

% 构建哈密顿量矩阵
matrix_t1 = f_matrix_t1( t1, N );
matrix_t2 = f_matrix_t2( t2, N, half_nx, ny );

hamilton = matrix_t1 + matrix_t2;

% 计算能量本征向量和能量本征值，并存储在eigenvectors和eigenvalues中
[ eigenvectors, eigenvalues ] = eig( hamilton );

% 绘制能带
energies = diag( eigenvalues );

figure;
plot( energies, '<', 'MarkerSize', 4 );
xlabel( '能级指标' );
ylabel( '能量本征值' );
grid on;

savefig( gcf, '能带.fig' );

% 绘制波函数

% 选择角态对应的能量本征向量
angular_state = 3 * N -100;

psi = eigenvectors( :, angular_state );

% 归一化波函数
norm_psi = psi / sqrt( trapz( psi.*conj( psi ) ) );

% 可视化波函数
total_number = 6 * N;

wave_x = 1 : total_number;

figure;
plot( wave_x, real( norm_psi ) );
xlabel( '格点' );
ylabel( '|Ψ|^2' );
grid on;

savefig( gcf, '波函数.fig' );

dx = 10;

the_end = trapz(dx, abs(norm_psi).^2);
end
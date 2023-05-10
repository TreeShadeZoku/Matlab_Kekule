function matrix_t1 = f_matrix_t1( t1, N )

% t1 = 10; % t1的值改为函数输入

% 将t1的值矩阵化
val_t1 = t1 * ones( 6, 1 );

% 将t1分成4个对角线矩阵生成

% 创建对角线矩阵，对角线偏移量为+2和-2
diag_t1_1 = spdiags( val_t1, 2, 6, 6 );
diag_t1_2 = spdiags( val_t1, -2, 6, 6 );

% 将对角线矩阵翻转得到反对角线矩阵，对角线偏移量为+4和-4
diag_t1_3 = fliplr( spdiags( val_t1, 4, 6, 6 ) );
diag_t1_4 = fliplr( spdiags( val_t1, -4, 6, 6 ) );

% 将4个对角线矩阵求和，得到元矩阵t1
meta_matrix_t1 = diag_t1_1 + diag_t1_2 + diag_t1_3 + diag_t1_4;

% 将大量的元矩阵t1沿对角线排列

% 利用 cell 数组储存元矩阵
cell_t1 = cell( 1, N );
for i = 1:N
    cell_t1{i} = meta_matrix_t1;
end

% 使用 blkdiag 函数将元矩阵t1沿对角线方向排列
matrix_t1 = blkdiag( cell_t1{:} );

% 将矩阵转化为表格，并输出为csv文件
% table_matrix_t1 = array2table( matrix_t1 );
% writetable( table_matrix_t1, 'matrix_t1.csv' )

end
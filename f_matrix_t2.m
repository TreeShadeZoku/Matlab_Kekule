function matrix_t2 = f_matrix_t2( t2, N, half_nx, ny )

% t2的矩阵构建将分为3部分完成：
% 1: 构建两个元矩阵t1相互连接的部分，实现 1 x 1 → 1 x 2
% 2: 构建两个 1 x 2 元矩阵相互连接的部分，实现 1 x 2 → n x 2
% 3: 构建两个 n x 2 元矩阵带相互连接的部分，实现 n x 2 → n x 2n

% 1: 构建两个元矩阵t1相互连接的部分，实现 1 x 1 → 1 x 2

% 构建一个 12 x 12 的稀疏矩阵，直接暴力填入数值，作为t2元矩阵的第一部分
meta_matrix_t2_1 = sparse( 12, 12 );
meta_matrix_t2_1( 5, 8 ) = t2;

% 利用 cell 数组储存元矩阵
cell_t2_1 = cell( 1, N / 2 );
for i = 1 : N / 2
    cell_t2_1{i} = meta_matrix_t2_1;
end

% 使用 blkdiag 函数将元矩阵沿对角线方向排列
matrix_t2_1 = blkdiag( cell_t2_1{:} );

% 2: 构建两个 1 x 2 元矩阵相互连接的部分，实现 1 x 2 → n x 2

% 构建一个 12 x 12 的稀疏矩阵,暴力填入数值，作为t2元矩阵的第二部分
meta_matrix_t2_2 = sparse( 12, 12 );
meta_matrix_t2_2( 4, 3 ) = t2;
meta_matrix_t2_2( 6, 7 ) = t2;
meta_matrix_t2_2( 10, 9 ) = t2;

% 将第二部分的元矩阵排列成一行晶格的形式
row_meta_matrix_t2_2 = zeros( ny * 12, ny * 12 );

% 初始化偏移量
idx_2 = [ 1, 13 ] + [ 0, 0 ];
row_meta_matrix_t2_2( idx_2( 1 ) : idx_2( 1 ) + 11, idx_2( 2 ) : idx_2( 2 ) + 11 ) = meta_matrix_t2_2;

% 每隔12行12列插入一次矩阵
for i = 2 : ny - 1 % 每一行晶格的末尾不插入
    idx_2 = idx_2 + [ 12, 12 ]; % 计算下一个插入位置
    row_meta_matrix_t2_2( idx_2( 1 ) : idx_2( 1 ) + 11, idx_2( 2 ) : idx_2( 2 ) + 11 ) = meta_matrix_t2_2;
end

% 利用 cell 数组储存元矩阵
cell_t2_2 = cell( 1, half_nx );
for i = 1 : half_nx
    cell_t2_2{i} = row_meta_matrix_t2_2;
end

% 使用 blkdiag 函数将元矩阵沿对角线方向排列
matrix_t2_2 = blkdiag( cell_t2_2{:} );

% 3: 构建两个 n x 2 元矩阵带相互连接的部分，实现 n x 2 → n x 2n

% 初始化第三部分元矩阵
meta_matrix_t2_3 = sparse( 12 * ny, 12 * ny);

% 计算第三部分中各点的坐标
coords = find_coords( ny );

% 将计算得到的坐标作为行索引和列索引，将t2的值填入第三部分元矩阵
meta_matrix_t2_3( sub2ind( size( meta_matrix_t2_3 ), coords( : , 1 ), coords( : , 2 ) ) ) = t2;

% 初始化第三部分矩阵
matrix_t2_3 = zeros( N * 6, N * 6 );

% 初始化偏移量
idx_3 = [ 1, ny * 12 + 1 ] + [ 0, 0 ];
matrix_t2_3( idx_3( 1 ) : idx_3( 1 ) + ( ny * 12 - 1 ), idx_3( 2 ) : idx_3( 2 ) + ( ny * 12 - 1 ) ) = meta_matrix_t2_3;

% 每隔[ ny * 12, ny * 12 ]插入一次矩阵
for i = 2 : half_nx - 1 % 最后一行晶格不插入
    idx_3 = idx_3 + [ ny * 12, ny * 12 ]; % 计算下一个插入位置
    matrix_t2_3( idx_3( 1 ) : idx_3( 1 ) + ( ny * 12 - 1 ), idx_3( 2 ) : idx_3( 2 ) + ( ny * 12 - 1 ) ) = meta_matrix_t2_3;
end

% 4: 将各部分求和，获得矩阵t2，但是这只是上半部分
matrix_t2_up = matrix_t2_1 + matrix_t2_2 + matrix_t2_3;

% 5: 对半矩阵t2求共轭，再求和，获得完整的矩阵t2

matrix_t2_down = rot90( matrix_t2_up , 2 );

matrix_t2 = matrix_t2_up + matrix_t2_down;

% 将矩阵转化为表格，并输出为csv文件
% table_matrix_t2 = array2table( matrix_t2_3 );
% writetable( table_matrix_t2 , 'matrix_t2_3.csv' )

end
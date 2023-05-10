function coords = find_coords( ny )
% n: 数列的项数，必须为奇数

n_find = ny * 2;

coords = zeros( n_find, 2 );

for i = 1 : n_find - 1
    law_1_1 = 12 * ( ( i + 1 ) / 2 );
    law_1_2 = 12 * ( ( i - 1 ) / 2 ) + 1;
    law_2_1 = 12 * ( ( i / 2 ) + 1 ) - 1;
    law_2_2 = 12 * ( ( i - 2 ) / 2 ) + 2;
    if mod( i, 2 ) == 1 % 奇数项
        coords( i, : ) = [ law_1_1 law_1_2 ];
    else % 偶数项
        coords(i,:) = [ law_2_1 law_2_2 ];
    end
end

% 此时 coords 数组中的最后一个值为[0 0]，需要将之删除
coords = coords( 1 : end - 1, : );
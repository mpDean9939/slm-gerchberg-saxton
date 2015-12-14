% Takes the input image, x_grid in x direction, y_grid in y direction
function duplication_image = duplicate_image (A,x_grid,y_grid)

[m,n] = size(A);        % n in x direction, m in y direction

X = floor(x_grid/n);    % duplicate time in x
x = x_grid - X*n;       % columns left for duplication
Y = floor(y_grid/m);    % duplicate time in y
y = y_grid - Y*m;       % rows left for duplicatoin

% duplicate columns
B = A;
for i = 1:X-1
    B = [B, A];
end
B=[B, A(:, 1:x)];

% duplicate rows
C = B;
for i = 1:Y-1
    C = [C; B];
end
C = [C; B(1:y, :)];

duplication_image = C;
end

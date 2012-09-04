x = xPositionMatrix;
y = yPositionMatrix;

x(isnan(x)) = 0;
y(isnan(y)) = 0;

Trajs = cell(1, size(x, 2));

for ind = 1:size(x, 2)
  Trajs{ind} = [x(find(x(:, ind)), ind), y(find(y(:, ind)), ind)];
end

  
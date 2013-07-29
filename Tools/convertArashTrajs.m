x = xPositionMatrix5;
y = yPositionMatrix5;

x(isnan(x)) = 0;
y(isnan(y)) = 0;

Exp1_Traj_Pos5 = cell(1, size(x, 2));

for ind = 1:size(x, 2)
  Exp1_Traj_Pos5{ind} = [x(find(x(:, ind)), ind), y(find(y(:, ind)), ind)];
end

  
function PALMplot(posData, res)

x = posData(:, 1);
y = posData(:, 2);
z = posData(:, 3);
xDev = posData(:, 4);
yDev = posData(:, 5);

% Obtain coord system for entire frame
xC = floor(min(x)-20):res:ceil(max(x)+20);
yC = floor(min(y)-20):res:ceil(max(y)+20);
[xcoord, ycoord] = meshgrid(xC, yC);

xcoordArr = xcoord(:);
ycoordArr = ycoord(:);

% Reconstruct model from fitted parameters
fitFrame = zeros(size(xcoord));
for i = 1:length(x)
    i
    params = [1000/(2*pi*xDev(i)*yDev(i)) 0 x(i) y(i) xDev(i) yDev(i)];
    fitFrame = max(fitFrame, reshape(pointGaussian(params',[xcoordArr, ycoordArr]), size(fitFrame)));
end

figure('Name', 'PALM plot','NumberTitle','off');;
PALM = surf(xC,yC,fitFrame, 'EdgeColor','none');
colormap(hot)
view(0,90)
axis equal
axis off

end

function pG = pointGaussian(beta,xdata)
pG = beta(1)*exp(-.5*(bsxfun(@minus,xdata,beta(3:4)').^2)*(1./beta(5:6).^2)) + beta(2);
end


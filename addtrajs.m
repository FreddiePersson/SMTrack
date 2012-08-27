function addtrajs(expNr, posNr)

trajName = strcat('Exp', num2str(expNr), '_Traj_Pos', num2str(posNr));
stepName = strcat('Exp', num2str(expNr), '_slXY_Pos', num2str(posNr));

W = evalin('base','whos');
existsInWS = ismember(trajName, [W(:).name]);

if existsInWS
    trajs = evalin('base', trajName);
    finalTraj = evalin('base', 'finalTraj');
    steps = evalin('base', stepName);
    steplengthXY = evalin('base', 'steplengthXY');
    
    assignin('base', trajName, [trajs, finalTraj]);
    assignin('base', stepName, [steps; steplengthXY]);
    
else
    finalTraj = evalin('base', 'finalTraj');
    steplengthXY = evalin('base', 'steplengthXY');
    
    assignin('base', trajName, [finalTraj]);
    assignin('base', stepName, [steplengthXY]);
    
end



end
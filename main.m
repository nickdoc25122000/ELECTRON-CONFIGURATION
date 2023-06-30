clear
%
%
baseEV = 2;   %ενεργεια της χαμηλοτερης στοιβαδας
stepEV = 0.1; %ενεργειακη αποσταση των στοιβαδων
targetEV = 15.5 %συνολικη ενέργεια των ηλεκτρονιων
ne=7
N =(targetEV-baseEV-(baseEV*(ne-1)))/stepEV; %αριθμος στοιβάδων
N=N+1
%οι δυαστασεις γραφιμματων σε ενα παραθυροv
c = 6; % number of columns
d = 2; % number of rows
%
%
%
E = baseEV:stepEV:(baseEV+(N-1)*stepEV);
A = zeros(3,N);
for j = 1:N
    A(:,j) = E(j) .* [0, 1, 2];
end
A(1,:)=[]
find_configs(A', targetEV,ne);
varNames = who('config*');
numConfigs = length(varNames);
for i = 1:numConfigs
    if mod(i-1, c*d) == 0 % need a new figure
        fig = figure;
    end
    subplot(d, c, mod(i-1, c*d) + 1)
    configName = varNames{i};
    eval(sprintf('config = %s;', configName));
    hold on
    title(sprintf('Configuration %d', i));
    ylabel('Energy (EV)');
    b = max(E) + stepEV;
    a = min(E) - stepEV;
    ylim([a b]);
    xlim([0 3]);
    set(gca,'XTickLabel',[]);
    for j = 1:length(E)
        y = [E(j) E(j)];
        x = xlim;
        h = line(x, y, 'Color', 'r', 'LineWidth', 2);
        set(h, 'Clipping', 'off');
    end
    y = baseEV + stepEV * (config(:,1) - 1);
    for j = 1:size(config,1)
        if config(j,2) == 1
            scatter(1.5, y(j), 'filled', 'b', 'SizeData', 70);
        end
        if config(j,2) == 2
            scatter(1, y(j), 'filled', 'b', 'SizeData', 70);
            scatter(2, y(j), 'filled', 'b', 'SizeData', 70);
        end 
    end
end


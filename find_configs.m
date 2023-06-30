function find_configs(A, target,ne)
A1=A(:,1);
A2=A(:,2);
num_cells = numel(A);
le=ceil(ne/2);
for n=le:ne
if n==ne
    combos = nchoosek(1:num_cells/2, n);
    sums = sum(A1(combos), 2);
else
combos = nchoosek(1:num_cells, n);
sums = sum(A(combos), 2);
end
sums=round(sums,1);
if min(sums)>target
    break
end
i=0;
sums_logic=sums==target;
if sum(sums_logic)==0
    continue;
end
sums=sums_logic.*sums;
combos=combos.*sums_logic;
sums = sums(sums_logic, :);
combos = combos(sums_logic, :);
for idx = 1:size(combos,1)
    [row, col] = ind2sub(size(A), combos(idx,:));
    unique_row = unique(row);
    if length(unique_row) < length(row)
        continue;
    end
    B=[row ; col]';
    if sum(B(:,2)) ~= ne
       continue;
    end
    i=i+1;
    arrayName = sprintf('config%d_%d',n, i);
    eval([arrayName ' = B;']);
end
end




varNames = who('config*');
uniqueConfigs = {};
configIndex = 1;
for i = 1:numel(varNames)
    data = eval(varNames{i});
    data = unique(data, 'rows');
    alreadyExists = false;
    for j = 1:numel(uniqueConfigs)
        if isequaln(uniqueConfigs{j}, data)
            alreadyExists = true;
            break;
        end
    end
    if ~alreadyExists
        uniqueConfigs{end+1} = data;
        assignin('base', ['config', num2str(configIndex)], data);
        configIndex = configIndex + 1;
    end
end
myStrings = {'energy levels','electrons'};
for i = 1:numel(uniqueConfigs)
    fprintf('config%d:\n', i);
    disp(myStrings);
    disp(uniqueConfigs{i});
end
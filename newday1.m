% Number of seed points
N = 100;  % Adjust as needed

% Bamboo node frequency and size factors
nodeFrequency = 0.15;  % Adjust as needed: Fraction of points that are larger nodes
largeGrainSize = 2;   % Adjust as needed: Size factor for larger grains
smallGrainSize = 1;   % Size factor for smaller grains

% Define area
xlim = [0, 2];
ylim = [0, 2];

% Generate initial random points
points = rand(N, 2);
points(:,1) = points(:,1) * (xlim(2) - xlim(1)) + xlim(1);
points(:,2) = points(:,2) * (ylim(2) - ylim(1)) + ylim(1);

% Assign initial sizes (1 for all)
sizes = ones(N, 1);

% Determine which points are 'nodes'
numNodes = round(N * nodeFrequency);
[~, nodeIndices] = datasample(points, numNodes, 1, 'Replace', false);
sizes(nodeIndices) = largeGrainSize;

% Find neighbors and adjust sizes based on larger grain proximity
radius = 0.05;  % Define your radius here
for i = 1:N
    if sizes(i) == smallGrainSize
        neighbors = findNeighbors(points(i,:), points, radius);
        if any(sizes(neighbors) == largeGrainSize)
            % Increase size of the grain if it has a neighboring large grain
            sizes(i) = largeGrainSize;
        end
    end
end

% 3D Visualization of seed points
% Assuming the size could represent the Z coordinate in a 3D plot
scatter3(points(:,1), points(:,2), sizes, sizes*10, sizes, 'filled'); % multiply sizes by 10 for visibility
xlabel('X coordinate');
ylabel('Y coordinate');
zlabel('Size (as Z coordinate)');
title('3D Scatter Plot of Seed Points');
view(3); % Adjust the view to 3D
drawnow; % Ensure the plot updates before moving on

% Combine points and sizes
seedPoints = [points, sizes];

% Output to a text file
% Open the file for writing
filename = 'C:\ubuntu_programs\New folder\voronoi_seeds.txt';
fileID = fopen(filename, 'w');

% Check if the file was opened successfully
if fileID == -1
    error('Failed to open file for writing. Check if you have write permission in the directory.');
end

% Loop through each seed point and write to file
for i = 1:size(seedPoints, 1)
    fprintf(fileID, '%f %f %d\n', seedPoints(i, 1), seedPoints(i, 2), seedPoints(i, 3));
end

% Close the file
fclose(fileID);

disp(['Seed points saved to ', filename]);

% Define the findNeighbors function at the end of the file
function neighbors = findNeighbors(point, points, radius)
    % Calculate the distances from the current point to all others
    distances = sqrt(sum((points - point).^2, 2));
    
    % Find the indices of points that are within the specified radius
    % Exclude the point itself by ensuring the distance is greater than 0
    neighbors = find(distances < radius & distances > 0);
end

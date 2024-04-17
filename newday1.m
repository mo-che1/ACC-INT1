% Number of seed points, reduced to allow for larger grain areas
N = 100;  % Adjust as needed

% Scalar short-range order for distribution of larger grains

ssro = 0.9375;

% Define area
xlim = [0, 2];
ylim = [0, 2];

% Generate initial random points
points = rand(N, 2);
points(:,1) = points(:,1) * (xlim(2) - xlim(1)) + xlim(1);
points(:,2) = points(:,2) * (ylim(2) - ylim(1)) + ylim(1);

% Initially consider all points for potential large grain centers
largeGrainProb = ssro;  % Probability a point is a center of a large grain

% Mark large grain centers
isLargeGrain = rand(N, 1) < largeGrainProb;

% Increase spacing around points marked as large grain centers
for i = 1:N
    if isLargeGrain(i)
        % Increase radius of effect for large grains
        radius = 0.1;  % Adjust this value as needed
        % Find all points within the radius
        for j = 1:N
            if i ~= j && norm(points(i,:) - points(j,:)) < radius
                % Push points away from the large grain center
                direction = (points(j,:) - points(i,:)) / norm(points(j,:) - points(i,:));
                points(j,:) = points(i,:) + direction * radius;
                % Ensure points remain within bounds
                points(j,1) = max(min(points(j,1), xlim(2)), xlim(1));
                points(j,2) = max(min(points(j,2), ylim(2)), ylim(1));
            end
        end
    end
end

% Scatter plot of all points
figure; 
hold on; % Holds the plot to overlay different datasets
scatter(points(:,1), points(:,2), 'b'); % Scatter plot for normal points in blue
scatter(points(isLargeGrain, 1), points(isLargeGrain, 2), 'r', 'filled'); % Scatter plot for large grain centers in red
xlabel('X coordinate'); 
ylabel('Y coordinate'); 
title('Distribution of Seed Points with Large Grain Centers'); 
hold off; 

% Output only the coordinates to a text file
filename = 'voronoi_seeds.txt';
fileID = fopen(filename, 'w');
if fileID == -1
    error('Failed to open file for writing. Check if you have write permission in the directory.');
end
fprintf(fileID, '%f %f\n', points');
fclose(fileID);

disp(['Seed points saved to ', filename]);

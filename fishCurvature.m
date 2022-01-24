function [R, arcLength, relCurve] = fishCurvature(points)
    
    % R is the radius of curvature based on the equation of a cirle
    % arclength is the splined length of the clicked points
    % relCurve is the relative curvature (arclength/euclidian length)
    % points is the number of points you want to click (I go with 10)
    
    % to run the code enter
    % [R, arcLength, relCurve] = fishCurvature(10);
    
    % Have the user choose the image
    [fileName, filePath] = uigetfile('*.*', 'Select the photo you want to trace');
    traceImage = imread([filePath,fileName]);
    imshow(traceImage)
    hold on
    
    clickedPoints = zeros(points,2);
    
    % loop through the specified number of points and plot each one
    for k = 1:points
        % get the mouse click point, or terminate if user presses enter
        %  in which case the coordinates will be returned empty
        coords = ginput(1);
        if isempty(coords)
            break
        end
        clickedPoints(k,:) = coords;
        plot(coords(:,1),coords(:,2),'b.');
    end
    
    % interpolate a curve with 100 points using the users clicked points
    pt = interparc(100,clickedPoints(:,1),clickedPoints(:,2));
    plot(pt(:,1), pt(:,2),'b.')
    
    % calculate the radius of curvature based on the equation of a circle
    % (X-h)^2 + (y-k)^2 = R^2 where
    %   (h,k) is the coordinates of the center of the circle
    %   R is the radius
    x=pt(:,1); y=pt(:,2);
    a=[x y ones(size(x))]\(-(x.^2+y.^2));
    h = -.5*a(1);
    k = -.5*a(2);
    R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));
    
    % plot just to show you what's up
    plot(h,k,'rO')
    plot([h, pt(1,1)], [k, pt(1,2)], 'r')
    plot([h, pt(50,1)], [k, pt(50,2)], 'r')
    plot([h, pt(100,1)], [k, pt(100,2)], 'r')
    
    % calculate relative arclength based on length of splined curve and
    % euclidean length between two endpoints
    linearLength = pdist([clickedPoints(1,:); clickedPoints(end,:)]);
    [arcLength, ~] = arclength(pt(:,1), pt(:,2));
    relCurve = arcLength/linearLength;
    
end

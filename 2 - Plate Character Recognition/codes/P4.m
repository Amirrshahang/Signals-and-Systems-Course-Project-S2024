video = VideoReader("video.mp4");
%disp(video.NumberOfFrames);
reference_frame = readFrame(video);
reference_frame_gray = rgb2gray(reference_frame); 

while hasFrame(video)
    current_frame = readFrame(video);
    current_frame_gray = rgb2gray(current_frame);
    
    diff_frame = abs(current_frame_gray - reference_frame_gray);
    
    threshold = 50;
    binary_frame = diff_frame > threshold;
    
    stats = regionprops(binary_frame, 'Centroid');
    
    if ~isempty(stats)
        centroid = stats(1).Centroid;
        x = centroid(1);
        y = centroid(2);
        
    end
end
distance_pixels = sqrt((x2 - x1)^2 + (y2 - y1)^2);

pixels_to_meters = 0.05; %farzi
distance_meters = distance_pixels * pixels_to_meters;

time_elapsed = 1 / video.FrameRate;

speed = distance_meters / time_elapsed;

video = VideoReader("video.mp4");
firstFrame = readFrame(video);
firstFrameGray = rgb2gray(firstFrame); 

total_distance_meters = 0;
total_time = 0;
frame_count = 0;

previous_centroid = [];

while hasFrame(video)
    current_frame = readFrame(video);
    current_frame_gray = rgb2gray(current_frame);
    
    diff_frame = abs(current_frame_gray - firstFrameGray);
    
    threshold = 50;
    binary_frame = diff_frame > threshold;
    
    stats = regionprops(binary_frame, 'Centroid');
    
    if ~isempty(stats)
        centroid = stats(1).Centroid;
        x = centroid(1);
        y = centroid(2);
        
        if ~isempty(previous_centroid)
            distance_pixels = sqrt((x - previous_centroid(1))^2 + (y - previous_centroid(2))^2);
            pixels_to_meters = 0.05; % مقدار فرضی
            distance_meters = distance_pixels * pixels_to_meters;

            total_distance_meters = total_distance_meters + distance_meters;

            total_time = total_time + (1 / video.FrameRate);
            frame_count = frame_count + 1; % شمارش فریم‌ها
        end
        
        previous_centroid = [x, y];
    end
end

if total_time > 0
    average_speed = total_distance_meters / total_time;
    disp(['Average Speed: ' num2str(average_speed) ' m/s']);
else
    disp('No motion detected.');
end
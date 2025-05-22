video = VideoReader("video.mp4");

% خواندن فریم مرجع
if hasFrame(video)
    reference_frame = readFrame(video);
    reference_frame_gray = rgb2gray(reference_frame); 
end

% متغیرها برای محاسبه مجموع مسافت و زمان
total_distance_meters = 0;
total_time = 0;
frame_count = 0;

% ذخیره مختصات قبلی خودرو برای محاسبه فاصله
previous_centroid = [];

while hasFrame(video)
    current_frame = readFrame(video);
    current_frame_gray = rgb2gray(current_frame);
    
    % محاسبه تفاوت بین فریم‌ها
    diff_frame = abs(current_frame_gray - reference_frame_gray);
    
    % آستانه‌گذاری برای شناسایی حرکت
    threshold = 50;
    binary_frame = diff_frame > threshold;
    
    % پیدا کردن مختصات خودرو
    stats = regionprops(binary_frame, 'Centroid');
    
    if ~isempty(stats)
        centroid = stats(1).Centroid; % مختصات خودرو
        x = centroid(1);
        y = centroid(2);
        
        if ~isempty(previous_centroid)
            % محاسبه فاصله بین مختصات قبلی و کنونی
            distance_pixels = sqrt((x - previous_centroid(1))^2 + (y - previous_centroid(2))^2);
            pixels_to_meters = 0.05; % مقدار فرضی
            distance_meters = distance_pixels * pixels_to_meters;

            % افزودن مسافت طی شده به مجموع
            total_distance_meters = total_distance_meters + distance_meters;

            % محاسبه زمان سپری‌شده
            total_time = total_time + (1 / video.FrameRate);
            frame_count = frame_count + 1; % شمارش فریم‌ها
        end
        
        % ذخیره مختصات کنونی برای مرحله بعد
        previous_centroid = [x, y];
    end
end

% محاسبه سرعت متوسط
if total_time > 0
    average_speed = total_distance_meters / total_time;
    disp(['Average Speed: ' num2str(average_speed) ' m/s']);
else
    disp('No motion detected.');
end

function result = Myremovecom(picture, n)

    components = bwconncomp(picture);
    num = components.NumObjects;
    
    result = zeros(size(picture));
    
    for i = 1:num
        
        component = false(size(picture));
        component(components.PixelIdxList{i}) = true;
        
        if sum(component(:)) >= n
            result = result | component;
        end
    end
end

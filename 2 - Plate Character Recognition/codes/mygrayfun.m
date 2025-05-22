function picture = mygrayfun(picture)

    picture = double(picture);

    redChannel = picture(:,:,1);
    greenChannel = picture(:,:,2);
    blueChannel = picture(:,:,3);
    
    picture = 0.299 * redChannel + 0.578 *  greenChannel + 0.114 * blueChannel;
    
    picture = uint8(picture);
    
end


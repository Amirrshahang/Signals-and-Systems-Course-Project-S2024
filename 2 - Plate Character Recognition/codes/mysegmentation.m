function [L,Ne] = mysegmentation(picture)

    %figure
    %imshow(picture)

    component = bwconncomp(picture);
    L = labelmatrix(component);
    Ne = component.NumObjects;

    propied=regionprops(L,'BoundingBox');

    hold on

    for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end

    hold off

end
function image = mybinaryfun(picture,thr)

    image = ~(picture >= thr);
end
function visible=LineOfSight(pos_1,pos_2)
    global M;
    global limit_height;
    x0=int32(pos_1(1));
    y0=int32(pos_1(2));
    x1=int32(pos_2(1));
    y1=int32(pos_2(2));
    dx=x1-x0;
    dy=y1-y0;
    f=0;
    if dy<0
        dy=-dy;
        sy=-int32(1);
    else
        sy=int32(1);
    end
    if dx<0
        dx=-dx;
        sx=-int32(1);
    else
        sx=int32(1);
    end
    
    if dx>=dy
        while x0~=x1
            f=f+dy;
            if f>=dx
                if M(x0+idivide(sx-1,2),y0+idivide(sy-1,2))>limit_height
                    visible=false;                    
                    return;
                end
                y0=y0+sy;
                f=f-dx;
            end    
            if f~=0 && M(x0+idivide(sx-1,2),y0+idivide(sy-1,2))>limit_height
                visible=false;
                return;
            end
            if dy==0 && M(x0+idivide(sx-1,2),y0)>limit_height  &&(y0==1 || (y0>1 && M(x0+idivide(sx-1,2),y0-1)>limit_height))
                visible=false;
                return;
            end
            x0=x0+sx;
        end
    else
        while y0~=y1
            f=f+dx;
            if f>=dy
                if M(x0+idivide(sx-1,2),y0+idivide(sy-1,2))>limit_height
                    visible=false;
                    return;
                end
                x0=x0+sx;
                f=f-dy;
            end    
            if f~=0 && M(x0+idivide(sx-1,2),y0+idivide(sy-1,2))>limit_height
                visible=false;
                return;
            end
            if dx==0 && M(x0,y0+idivide(sy-1,2))>limit_height && (x0==1 || (x0>1 && M(x0-1,y0+idivide(sy-1,2))>limit_height))
                visible=false;
                return;
            end
            y0=y0+sy;
        end
    end
    visible=true;                
end
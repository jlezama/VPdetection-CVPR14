function draw_dual_spaces(points, detections, space, vpimg, params)
% Draws the dual spaces.

% plot alignment detections
hfig = figure();
hold on

if ~isempty(vpimg)
    max_nfa = max(detections(:,6));
    min_nfa = min(detections(:,6));
end

for i = 1:size(detections,1)
    det = detections(i,:);
    ang = atan2(det(4)-det(2),det(3)-det(1));
    wi = det(5);
    nfa = det(6);
    
    rot = [cos(ang) sin(ang);-sin(ang) cos(ang)];
    side = [0 wi/2]*rot;
    
    P1 = [det(1) det(2)]+side;
    P2 = [det(3) det(4)]+side;
    P3 = [det(3) det(4)]-side;
    P4 = [det(1) det(2)]-side;
    P5 = [det(1) det(2)]+side;
    rect = [P1;P2;P3;P4;P5];
    
    col = 1-[.6 .6 .6]*(nfa-min_nfa)/(max_nfa-min_nfa+1e-10);
    
    fill(rect(:,1),rect(:,2), col)
    
end
plot(points(:,1), points(:,2),'k.')

% plot vanishing points
V = size(vpimg,2);
colors = hsv(V);

if ~isempty(vpimg)
    vpimg(1,:) = vpimg(1,:)/params.W;
    vpimg(2,:) = vpimg(2,:)/params.H;
end


[m, b] = PCLines(vpimg', space);

x = [-1000 1000]; %[min(points(:,1)) max(points(:,1))];
hold on
for i = 1:V
    plot(x,x*m(i)+b(i),'--','Color',colors(i,:),'LineWidth',1.1) ;
end

if isequal(space,'straight')
    axis([-1 2 -1 2])
else
    axis([-2 1 -2 1])
end

print(hfig,'-depsc', '-r600', sprintf('%s/%s', params.folder_out, space));
end
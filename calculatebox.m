function initi_bdbox=calculatebox(landmarks,row,col)

% disrat=1.0;
% faceupratio=1.9*disrat;
% facedownratio=1.7*disrat;
% faceleftratio=1.6*disrat;
% facerightratio=1.6*disrat;
% c_ycenter=0.3*disrat;
% 
% landmarkpoints_rote=landmarks;
% lefteye=(landmarkpoints_rote(37,:)+landmarkpoints_rote(40,:))/2;
% righteye=(landmarkpoints_rote(43,:)+landmarkpoints_rote(46,:))/2;
% eyedis=norm(lefteye-righteye,2);
% imgcenter=(lefteye+righteye)/2+[0,c_ycenter*eyedis];
% leftuppoint=imgcenter-[faceleftratio*eyedis,faceupratio*eyedis];
% leftuppoint(find(leftuppoint<0))=0;
% facescale=[(faceleftratio+facerightratio)*eyedis,(faceupratio+facedownratio)*eyedis];
% facescale=[min(facescale(1),col-leftuppoint(1)),min(facescale(2),row-leftuppoint(2))];
% initi_bdbox=[leftuppoint,facescale];
diff=10;
minx=min(landmarks(:,1));
miny=min(landmarks(:,2));
maxx=max(landmarks(:,1));
maxy=max(landmarks(:,2));
bd_minx=max(0,minx-diff);
bd_miny=max(0,miny-diff*4);
width=min(maxx-minx+2*diff,col);
height=min(maxy-miny+5*diff,row);

initi_bdbox=[bd_minx,bd_miny,width,height];

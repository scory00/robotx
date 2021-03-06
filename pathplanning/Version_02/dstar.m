% RobotX Maritime Path Planning
% Requires: Robotics Matlab Toolbox by Peter Corke
% found here: http://www.petercorke.com/RTB/dl-zip.php?file=current/robot-9.10.zip


%% Initialization
% Sub/Pub/Msg
OGridSub = rossubscriber('/OccupancyGrid', 'nav_msgs/OccupancyGrid');
GPSSub = rossubscriber('/GPSLocation', 'sensor_msgs/NavSatFix');
GoalSub = rossubscriber('/GoalCoordinates', 'GOAL MSGTYPE HERE');
OptimalPathPub = rospublisher('/OptimalPath', 'nav_msgs/Path');            % rostype.std_msgs_Int32MultiArray
OptimalPathMsg = rosmessage('nav_msgs/Path');

% Get Occupancy Grid from ROS
OGridData = receive(OGridSub, 3);       % OGridData = OgridSub.LatestMessage;
GPSData = receive(GPSSub, 3);           % GPSData = GPSSub.LatestMessage;
GoalData = receive(GoalSub, 3);         % GoalData = GoalSub.LatestMessage;
% Get Coordinates of Goal from ROS

% Get State from ROS

% Create a D* Object using the map
map = OGridData;
goal = [1, 1];          % TODO: 
ds = Dstar(map);
ds.plan(goal);

spath = path(ds, curr_pos);

% Update Path
OGridData = receive(Ogrid);

% Publish the path to ROS
msg = rosmessage(rostype.std_msgs_Int32MultiArray);
msg.data = spath;

send(OptimalPathPub, msg);
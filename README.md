# README

Example input and output:

a) Input: PLACE 0,0,NORTH MOVE REPORT Output: 0,1,NORTH

b) Input: PLACE 0,0,NORTH LEFT REPORT Output: 0,0,WEST

c) Input: PLACE 1,2,EAST MOVE MOVE LEFT MOVE REPORT Output: 3,3,NORTH

I Have covered given scenarios and also have added a video to go through how i am passing parameters and have covered different scenarios.

In this code it checks for PLACE and REPORT command, upper or lowercase both works, checks if robot is on table or not, checks if robot can fall or not and success return of location on successfull input commands.

api format will be as below (as given in the example input):- 

http://localhost:3000/api/robot/0/orders?commands=PLACE 0,0,WEST LEFT MOVE REPORT

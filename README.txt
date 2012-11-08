==== README ====
Running the program requires Ruby (my solution has been tested to worth with both 1.8 [on dice]  and 1.9 [literally the rest of the world])

The code itself is contained in distributed_system.rb and can be run by executing $ ruby <path_to_distributed_system.rb>
However it takes an argument, the network_description.txt file which follows the syntax given in the handout to allow the system
to be specified.

This means that the full syntax to run (if in the folder) is $ ruby distributed_system.rb network_description.txt
This can be followed by an optional '1' if you wish to skip the sender (see below).

===Part 2===
== Question 1==
If each node is not transmitting its table every 30s (such as the scenario in this practical), it is necessary
for each node to transmit its updated table back to the sender of a table as otherwise it is not guaranteed that
nodes will discover all other nodes in the system before the algorithm converges.
This can lead to both incomplete routing tables and the system converging to a solution that is not the optimum.

== Question 2==
Not requring the retransmission of an updated table to the sender greatly reduces the number of events before the
algorithm converges.
If the full table is transmitted to all known nodes every 30 seconds, skipping the sender is a good way of dramatically reducing the traffic between these events whilst still giving a 'good' rate of convergence and allowing all nodes to discover eachother.


===Experimental Results===
* Triggered by $ ruby ./distributed_system.rb network_description.txt
==Without skip sender==
* 108 Events later =>
table p1 (1|local|0) (10|p6|2) (2|p2|1) (3|p4|2) (4|p4|1) (5|p4|1) (6|p6|2) (7|p6|2) (8|p6|2) (9|p6|1)
table p2 (1|p1|1) (10|p1|3) (2|local|0) (3|p3|1) (4|p3|2) (5|p3|2) (6|p1|3) (7|p1|3) (8|p1|3) (9|p1|2)
table p3 (1|p2|2) (10|p4|4) (2|p2|1) (3|local|0) (4|p4|1) (5|p4|1) (6|p4|4) (7|p4|4) (8|p4|4) (9|p4|3)
table p4 (1|p1|1) (10|p1|3) (2|p3|2) (3|p3|1) (4|local|0) (5|local|0) (6|p1|3) (7|p1|3) (8|p1|3) (9|p1|2)
table p5 (1|p6|2) (10|p6|2) (2|p6|2) (3|p6|4) (4|p6|1) (5|p6|3) (6|local|0) (7|local|0) (8|local|0) (9|local|0)
table p6 (1|p1|1) (10|p8|1) (2|p7|1) (3|p1|3) (4|local|0) (5|p1|2) (6|p5|1) (7|p5|1) (8|p5|1) (9|local|0)
table p7 (1|p6|2) (10|p6|2) (2|local|0) (3|p6|4) (4|p6|1) (5|p6|3) (6|p6|2) (7|p6|2) (8|p6|2) (9|local|0)
table p8 (1|p6|2) (10|local|0) (2|p6|2) (3|p6|4) (4|p6|1) (5|p6|3) (6|p6|2) (7|p6|2) (8|p6|2) (9|p6|1)
* 148 Events later =>
table p1 (1|local|0) (10|p6|2) (2|p2|1) (3|p4|2) (4|p4|1) (5|p4|1) (6|p6|2) (7|p6|2) (8|p6|2) (9|p6|1)
table p2 (1|p1|1) (10|p1|3) (2|local|0) (3|p3|1) (4|p1|2) (5|p1|2) (6|p1|3) (7|p1|3) (8|p1|3) (9|p1|2)
table p3 (1|p4|2) (10|p2|4) (2|p2|1) (3|local|0) (4|p4|1) (5|p4|1) (6|p4|4) (7|p4|4) (8|p4|4) (9|p2|3)
table p4 (1|p1|1) (10|p1|3) (2|p1|2) (3|p3|1) (4|local|0) (5|local|0) (6|p1|3) (7|p1|3) (8|p1|3) (9|p1|2)
table p5 (1|p6|2) (10|p6|2) (2|p6|2) (3|p6|4) (4|p6|1) (5|p6|3) (6|local|0) (7|local|0) (8|local|0) (9|local|0)
table p6 (1|p1|1) (10|p8|1) (2|p7|1) (3|p1|3) (4|local|0) (5|p1|2) (6|p5|1) (7|p5|1) (8|p5|1) (9|local|0)
table p7 (1|p6|2) (10|p6|2) (2|local|0) (3|p6|4) (4|p6|1) (5|p6|3) (6|p6|2) (7|p6|2) (8|p6|2) (9|local|0)
table p8 (1|p6|2) (10|local|0) (2|p6|2) (3|p6|4) (4|p6|1) (5|p6|3) (6|p6|2) (7|p6|2) (8|p6|2) (9|p6|1)
* More tests =>
156 Events
158 Events
116 Events
126 Events
120 Events

* Triggered by $ ruby ./distributed_system.rb network_description.txt 1
==With skip sender==
* 42 Events later =>
table p1 (1|local|0) (2|p2|1) (3|p4|2) (4|p4|1) (5|p4|1)
table p2 (1|p1|1) (2|local|0) (3|p3|1) (4|p1|2) (5|p1|2)
table p3 (1|p2|2) (2|p2|1) (3|local|0) (4|p4|1) (5|p4|1)
table p4 (1|p1|1) (2|p3|2) (3|p3|1) (4|local|0) (5|local|0)
table p5 (1|p6|2) (2|p6|3) (3|p6|4) (4|p6|1) (5|p6|3) (6|local|0) (7|local|0) (8|local|0) (9|local|0)
table p6 (1|p1|1) (2|p1|2) (3|p1|3) (4|local|0) (5|p1|2) (9|local|0)
table p7 (1|p6|2) (2|local|0) (3|p6|4) (4|p6|1) (5|p6|3) (9|local|0)
table p8 (1|p6|2) (10|local|0) (2|p6|3) (3|p6|4) (4|p6|1) (5|p6|3) (9|p6|1)
* 42 Events later =>
table p1 (1|local|0) (2|p2|1) (3|p4|2) (4|p4|1) (5|p4|1)
table p2 (1|p1|1) (2|local|0) (3|p3|1) (4|p1|2) (5|p1|2)
table p3 (1|p2|2) (2|p2|1) (3|local|0) (4|p4|1) (5|p4|1)
table p4 (1|p1|1) (2|p3|2) (3|p3|1) (4|local|0) (5|local|0)
table p5 (1|p6|2) (2|p6|3) (3|p6|4) (4|p6|1) (5|p6|3) (6|local|0) (7|local|0) (8|local|0) (9|local|0)
table p6 (1|p1|1) (2|p1|2) (3|p1|3) (4|local|0) (5|p1|2) (9|local|0)
table p7 (1|p6|2) (2|local|0) (3|p6|4) (4|p6|1) (5|p6|3) (9|local|0)
table p8 (1|p6|2) (10|local|0) (2|p6|3) (3|p6|4) (4|p6|1) (5|p6|3) (9|p6|1)
* More tests =>
48 Events
48 Events
48 Events
48 Events
48 Events

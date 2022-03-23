**This is a folder forked from from [my personal repo](https://github.com/yiyangthesame/RobotaPsyche/tree/main/March%209%20-%20Midterm) for group collaboration.** Below is the original README.md file.

## Description

This project, as an midterm assignment, is to simulate an ecosystem in Processing. It incorporates the concepts we have learned from the book *Vehicles*, and is the continuation and complication of the previous ecosystem assignment.

The ecosystem I tried to build consists of a group of insects. Each insect has a different initial velocity represented by the black & white gradient. They have two different sets of behavior in the dark mode and the day mode.

In the dark mode:

- the light sources are highly attracting
- the insect only moves when it is stimulated by the movement of neighboring insects

In the day mode:

- the light sources are less attracting
- the insect is attracted to other individuals with similar gradients
- the insect avoids other individuals with disparate gradients

The insects obey Newton's first law of inertia, that they would not change their velocities (direction & magnitude) immediately when attracted. Instead, their velocities change due to the forces exerted by the attraction, according to Newton's second law.

The insects slows down when it approaches the wall, and it bounces back with certain energy loss from the wall.



## Demo

[A link to the video](https://od20-my.sharepoint.com/:v:/g/personal/xu_od20_onmicrosoft_com/Ec4AwBT2cGZMsV-Cq_Hw-6sBHVJkdRv4D2aw2tZF6r3k-Q?e=7CMe5N&download=1)

![1647163929(1)](https://user-images.githubusercontent.com/51028862/158053450-970e9c87-d024-4a64-9b8a-291e2af5fa16.png)

![1647163945(1)](https://user-images.githubusercontent.com/51028862/158053458-f40cc134-cc02-4dd9-80f6-fff63c4518dd.png)

![1647163979(1)](https://user-images.githubusercontent.com/51028862/158053477-74de2c10-3ce8-48dd-887a-8af07f65d65a.png)



## Roadmap

I have made a list of objectives after drafting possible features as an upgrade of the previous ecosystem assignment:

- [x] variation in insect properties represented by the gradient;
- [x] day and night modes with two different sets of fireflies behavior;
- [x] a different mechanism of the wall/edges;
- [x] instructions on the screen.

More details about what I have done in the process of development are in the [journal](/March%209%20-%20Midterm/Journal.md) in the folder of the project.



## Attempts

### Borderless canvas

I have examined idea of borderless canvas, which allows the insects to go beyond the site of the user. Yet, it was proven unsuccessful due to the low chance that the user is able to observe the movement of the insects after a while.

If I have implemented this, the behavior of the insects would be like mosquitoes - we cannot find them except that we have something, for example, the light sources, appealing to them.

### Fading trails with no lagging

In the attempt to fix the lagging bug, I tried to apply other approaches to implement the fading trails, yet it does not resolve the issue of lagging - it appears that some other calculations occupy a high level of resources as well. So I decided to

- remove the trail functionality
- and limit the maximum number of light sources.



## Discussion

I observed that with some rather simple principles, the entire system seems to be chaos, which is unpredictable. I am more convinced that the entire world may be set alive in the innate simplicity and observed unpredictability.

Furthermore, adding contrasting sets of behavior to different scenarios, the insects become surprisingly authentic in the view of an observer. It has further proven to me that every organism consists of "conditioned responses" which I learned in psychology.

# Learn to Code
## Add a Tree

Look through the code, find where it renders trees, and add a 4th tree.

- How to control the position of the tree?
- How to control the size of the tree?

## Change tree species
- Modify the pine tree's green triangle into a green circle
- Modify them again to have a green oval. Hint: there is an oval function:

```
oval width height
```
## Draw something else

What can you think to add to the scene? Could you add ...
- clouds?
- a cat?
- the LaunchCode® Mentor Center™

## Rocketry

Pressing and holding 's' activates the thruster on the
rocket. Pressing 'a' and 'd' steer left and right.  

The code that governs this is the `update` function, and it's various
helper functions.

- Add a key 'r' that resets the rocket to it's initial state - hint:
  the initial state is conveniently located in the term `init`.

## Crashing
(Advanced)
Check out the RocketState type:

```

type RocketState = Landed
                 | Thrusting
                 | Falling

```

The rocket is initially in the `Landed` state, and when you press 's' it
transitions to `Thrusting`. There is also the `Falling` state. Add a 4th
state, `Crashed`:

- transition to this state when the rocket collides with the ground.
- change the way the rocket draws when it's crashed
- change the physics to have the crash site remain stationary
- when you crash, you should lose control of the rocket


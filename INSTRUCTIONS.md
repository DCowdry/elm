# Learn to Code
Do as much or as little of this as you want!

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

## Afterburners

Add another button that also activates the thruster. If you hold
either of them, you thrust. If you hold both of them, you accellerate
twice as fast!

## Bouncing
(Advanced)
If the rocket gets below the ground (`groundY`), have it bounce off.

### Hints
- Set the model's velocity.y to be positive. Look at gravityUpdate for
  an example of how to change the model's velocity.y.
- You may want to add a bounceUpdate function.

## Crashing
(Advanced)
Check out the RocketState type:

```

type RocketState = Landed
                 | Thrusting
                 | Falling

```

The rocket is initially in the `Landed` state, and when you press 's' it
transitions to `Thrusting`. There is also the `Falling` state.

- add a 4th state, `Crashed`.
- transition to this state when the rocket collides with the ground by
  adding a crashUpdate function
- change the way the rocket draws when it's crashed.
- change the physics to have the crash site remain stationary.
- when you crash, you should lose control of the rocket.

### Hint 1

The compiler will force you to add code to account for your new state,
so you don't have to understand the whole program.

There are lots of functions that slightly modify the state of the
rocket. Most of them have very narrow scopes, and don't require huge
changes: For example, gravityUpdate, that accellerates the y velocity
of the rocket down. You don't have to do much work to modify these
functions!


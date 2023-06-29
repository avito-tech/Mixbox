# Ideas

* Track times of timed asserts. Increase timeouts if actual time is near current timeout of a specific assert.
* Track situations when tap() or other action is probably failed, insert tapUntilDisappears() in that cases.

## Performance

* Ability to use some kind of optimization profiles for fast test execution and thorough test execution
    * Programmatic scroll instead of honest scroll 
    * Disable animations instead of speeding them up
    * Different polling settings (longer polling utilizes CPU better for parallelized tests)
    * Disable some logs / add more logs (depending on profile)
    * Disable many logs if test is not restarted (logs are used for failed tests mostly)

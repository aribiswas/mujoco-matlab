classdef Go1Environment < rl.env.MATLABEnvironment
    properties
        PyEnv
        Seed = 0
    end
    methods
        function this = Go1Environment(args)
            arguments
                args.Seed (1,1) double {mustBeNonnegative, mustBeFinite} = 0
                args.Render (1,1) logical = false
            end
            pyrun("import go1");
            pyrun("import random");
            pyrun("random.seed(seed)",seed=py.int(args.Seed));
            if args.Render
                env = pyrun("env = go1.create_env_with_recording()","env");
            else
                env = pyrun("env = go1.create_env()","env");
            end
            numObs = double(env.observation_space.shape);
            numAct = double(env.action_space.shape);
            oinfo = rlNumericSpec([numObs,1]);
            ainfo = rlNumericSpec([numAct,1]);
            ainfo.UpperLimit = double(env.action_space.high)';
            ainfo.LowerLimit = double(env.action_space.low)';
            this@rl.env.MATLABEnvironment(oinfo,ainfo);
            this.PyEnv = env;
            this.Seed = args.Seed;
        end
        function obs = reset(this)
            pyObs = this.PyEnv.reset(seed=py.int(this.Seed));
            obs = double(pyObs{1});
        end
        function [nextObs,reward,isDone,info] = step(this,action)
            pyAct       = py.numpy.array(action);
            pyStepOut   = this.PyEnv.step(pyAct);
            nextObs     = double(pyStepOut{1});
            reward      = double(pyStepOut{2});
            isDone      = pyStepOut{3} || pyStepOut{4};
            info        = [];
        end
    end
end
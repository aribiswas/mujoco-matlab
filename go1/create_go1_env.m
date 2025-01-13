pyrun("import go1");
env = pyrun("env = go1.create_env()","env");
rec_env = pyrun("rec_env = go1.create_env_with_recording()","rec_env");
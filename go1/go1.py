import gymnasium
from gymnasium.wrappers import RecordEpisodeStatistics, RecordVideo
from robot_descriptions import go1_mj_description

num_eval_episodes = 4

def create_env():
    return gymnasium.make(
        'Ant-v5',
        xml_file=go1_mj_description.MJCF_PATH,
        forward_reward_weight=1,
        ctrl_cost_weight=0.05,
        contact_cost_weight=5e-4,
        healthy_reward=1,
        main_body=1,
        healthy_z_range=(0.195, 0.75),
        include_cfrc_ext_in_observation=True,
        exclude_current_positions_from_observation=False,
        reset_noise_scale=0.1,
        frame_skip=25,
        max_episode_steps=1000,
    )

def create_env_with_recording(video_folder="recordings", render_mode="rgb_array"):
    env = gymnasium.make(
        'Ant-v5',
        xml_file=go1_mj_description.MJCF_PATH,
        forward_reward_weight=1,
        ctrl_cost_weight=0.05,
        contact_cost_weight=5e-4,
        healthy_reward=1,
        main_body=1,
        healthy_z_range=(0.195, 0.75),
        include_cfrc_ext_in_observation=True,
        exclude_current_positions_from_observation=False,
        reset_noise_scale=0.1,
        frame_skip=25,
        max_episode_steps=1000,
        render_mode=render_mode,
        camera_id=0
    )
    env = RecordVideo(
        env, 
        video_folder=video_folder, 
        name_prefix="eval",
        episode_trigger=lambda x: True
    )
    return RecordEpisodeStatistics(env, buffer_length=num_eval_episodes)

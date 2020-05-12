Linux安装环境：https://www.deepfaker.xyz/?p=1202
Windows安装环境：https://deepfacelabs.com/list-6-3.html
换脸步骤：https://www.deepfaker.xyz/?page_id=513

conda create -y -n deepfacelab python=3.6.6 cudatoolkit=9.0 cudnn=7.3.1
conda activate deepfacelab
apt install git
git clone https://github.com/dream80/DeepFaceLab_Linux
cd DeepFaceLab_Linux
python -m pip install -r requirements-cuda.txt
chmod 777 scripts/*
cd scripts
apt install ffmpeg
./2_extract_PNG_from_video_data_src.sh

conda deactivate
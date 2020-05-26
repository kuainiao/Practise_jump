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


conda activate deepfacelab
cd DeepFaceLab_Linux
cd scripts

./4_data_src_extract_faces_S3FD_best_GPU.sh
./4.2.1_data_src_sort_by_blur.sh
./5_data_dst_extract_faces_S3FD_best_GPU.sh

./6_train_H64.sh

./7_convert_H64.sh
Running converter.

You have multi GPUs in a system: 
[0] : TITAN V
[1] : TITAN V
[2] : TITAN V
[3] : TITAN V
[4] : TITAN V
[5] : TITAN V
[6] : TITAN V
[7] : TITAN V
[8] : TITAN V
[9] : TITAN V
Which GPU idx to choose? ( skip: best GPU ) : 1
Loading model...

Model first run. Enter model options as default for each run.
Enable autobackup? (y/n ?:help skip:n) : n
Write preview history? (y/n ?:help skip:n) : n
Target iteration (skip:unlimited/default) : 
0
Batch_size (?:help skip:0) : 4
Feed faces to network sorted by yaw? (y/n ?:help skip:n) : n
Flip faces randomly? (y/n ?:help skip:y) : y
Src face scale modifier % ( -30...30, ?:help skip:0) : 0
Resolution ( 64-256 ?:help skip:128) : 
128
Half or Full face? (h/f, ?:help skip:f) : f
Learn mask? (y/n, ?:help skip:y) : y
Optimizer mode? ( 1,2,3 ?:help skip:1) : 1
AE architecture (df, liae ?:help skip:df) : df
AutoEncoder dims (32-1024 ?:help skip:512) : 
512
Encoder dims per channel (21-85 ?:help skip:42) : 
42
Decoder dims per channel (10-85 ?:help skip:21) : 
21
Use multiscale decoder? (y/n, ?:help skip:n) : 
n
Use CA weights? (y/n, ?:help skip: n ) : 
n
Use pixel loss? (y/n, ?:help skip: n ) : 
n
Face style power ( 0.0 .. 100.0 ?:help skip:0.00) : 
0.0
Background style power ( 0.0 .. 100.0 ?:help skip:0.00) : 
0.0
Apply random color transfer to src faceset? (y/n, ?:help skip:n) : 
n
Enable gradient clipping? (y/n, ?:help skip:n) : 
n
Pretrain the model? (y/n, ?:help skip:n) : n
Using TensorFlow backend.
===== Model summary =====
== Model name: SAE
==
== Current iteration: 0
==
== Model options:
== |== batch_size : 4
== |== sort_by_yaw : False
== |== random_flip : True
== |== resolution : 128
== |== face_type : f
== |== learn_mask : True
== |== optimizer_mode : 1
== |== archi : df
== |== ae_dims : 512
== |== e_ch_dims : 42
== |== d_ch_dims : 21
== |== multiscale_decoder : False
== |== ca_weights : False
== |== pixel_loss : False
== |== face_style_power : 0.0
== |== bg_style_power : 0.0
== |== apply_random_ct : False
== |== clipgrad : False
== Running on:
== |== [1 : TITAN V]
=========================
Choose mode: (1) overlay, (2) hist match, (3) hist match bw, (4) seamless, (5) raw. Default - 4 : 1
Mask mode: (1) learned, (2) dst, (3) FAN-prd, (4) FAN-dst , (5) FAN-prd*FAN-dst (6) learned*FAN-prd*FAN-dst (?) help. Default - 1 : 1
Choose erode mask modifier [-200..200] (skip:0) : 
0
Choose blur mask modifier [-200..200] (skip:0) : 
0
Choose output face scale modifier [-50..50] (skip:0) : 
0
Apply color transfer to predicted face? Choose mode ( rct/lct skip:None ) : 
None
Apply super resolution? (y/n ?:help skip:n) : 
n
Degrade color power of final image [0..100] (skip:0) : 
0
Export png with alpha channel? (y/n skip:n) : 
n

./8_converted_to_mp4.sh 
Bitrate of output file in MB/s ? (default:16) : 16